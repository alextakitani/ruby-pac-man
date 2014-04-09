require 'rubygems'
require 'rubygame'
require './game_object'
require './roleman'
require './moeda'
require './pulica'
require './tijolo'
require 'pry'
require 'pry-nav'
Rubygame::TTF.setup
Rubygame::Mixer::open_audio
class Game
    def initialize
        @music = Rubygame::Sound.load "../media/leklek.ogg"
        @music.play
        @gemido = Rubygame::Sound.load "../media/groan.wav"

        @screen = Rubygame::Screen.new [640, 480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
        @screen.title = "Role-Man"

        @queue = Rubygame::EventQueue.new
        @clock = Rubygame::Clock.new
        @clock.target_framerate = 60

        limit = @screen.height - 10
        limit_right = @screen.width - 10

        @roleman = Roleman.new @screen.width/2, @screen.height/2, Rubygame::K_UP, Rubygame::K_DOWN, Rubygame::K_LEFT, Rubygame::K_RIGHT, 10, limit, 10,limit_right
        @puli_x = 0
        @puli_y = 350
        @delegacia = []
        @delegacia << Pulica.new(350,350)
        @delegacia << Pulica.new(350,50)
        @won = false

        @win_text = Text.new
        @play_again_text = Text.new 0, 0, "lelekar denovo? Aperte S or N", 24
        @background = Background.new @screen.width, @screen.height

        @moedas = []
        carrega_rolezeiras
        @paredes = []
        carrega_paredes


    end

    def carrega_paredes
        tijolo = Tijolo.new 300,200
        @paredes << tijolo
    end

    def carrega_rolezeiras
        64.step(512,64) do |x|
           moeda = Moeda.new(x,32)
           @moedas << moeda
           moeda = Moeda.new(x,96)
           @moedas << moeda
           moeda = Moeda.new(x,160)
           @moedas << moeda
        end
    end

    def run!
        loop do
            update
            draw
            @clock.tick
        end
    end

    def win

        @win_text.text = "Ae Lek, pegou as rolezeira!"

        @won = true
        @win_text.center_x @screen.width
        @win_text.center_y @screen.height
        @play_again_text.center_x @screen.width
        @play_again_text.y = @win_text.y+60

    end

    def loose
        @win_text.text = "Acabou o role, os homi mi pegaro"

        @won = true
        @win_text.center_x @screen.width
        @win_text.center_y @screen.height
        @play_again_text.center_x @screen.width
        @play_again_text.y = @win_text.y+60
    end

    def update

        @roleman.update @screen unless @won
        @delegacia.each{|p| p.update @screen, @roleman}

        @moedas.each do |moeda|
            if collision? @roleman,moeda
                @moedas.delete(moeda)
                @gemido.play
            end
        end

        @delegacia.each do |pulica|
            if collision? @roleman, pulica
                loose
            end
        end

        win if @moedas.empty?

        @queue.each do |ev|
            @roleman.handle_event ev
            case ev
                when Rubygame::QuitEvent
                    Rubygame.quit
                    exit
                when Rubygame::KeyDownEvent
                    if ev.key == Rubygame::K_ESCAPE
                        @queue.push Rubygame::QuitEvent.new
                    end
                    if ev.key == Rubygame::K_S and @won
                        # Reset the game
                        @roleman.center_y @screen.height

                        carrega_rolezeiras

                        @delegacia.each do |pulica|
                            pulica.x = @puli_x + 50
                            pulica.y = @puli_y
                            @puli_x += 50
                        end

                        @won = false
                    end
                    if ev.key == Rubygame::K_N and @won
                        Rubygame.quit
                        exit
                    end
            end
        end

        # if collision? @ball, @player
        #     @ball.collision @player, @screen
        # elsif collision? @ball, @enemy
        #     @ball.collision @enemy, @screen
        # end
    end

    def draw
        @screen.fill [0,0,0]

        unless @won

            @background.draw @screen

            @moedas.each{|m| m.draw @screen}

            @roleman.draw @screen

            @delegacia.each{ |p| p.draw @screen}

            @paredes.each{ |p| p.draw @screen}

        else
            @win_text.draw @screen
            @play_again_text.draw @screen
        end

        @screen.flip
    end

    def collision? obj1, obj2
        if obj1.y + obj1.height < obj2.y ; return false ; end
        if obj1.y > obj2.y + obj2.height ; return false ; end
        if obj1.x + obj1.width < obj2.x ; return false ; end
        if obj1.x > obj2.x + obj2.width ; return false ; end
        return true
    end
end




class Background < GameObject
    def initialize width, height
        surface = Rubygame::Surface.new [width, height]

        # Draw background
        white = [255, 255, 255]

        # Top
        surface.draw_box_s [0, 0], [surface.width, 10], white
        # Left
        surface.draw_box_s [0, 0], [10, surface.height], white
        # Bottom
        surface.draw_box_s [0, surface.height-10], [surface.width, surface.height], white
        # Right
        surface.draw_box_s [surface.width-10, 0], [surface.width, surface.height], white

        super 0, 0, surface
    end
end

class Text < GameObject
    def initialize x=0, y=0, text="Hello, World!", size=36
        @font = Rubygame::TTF.new "../media/Freshman.ttf", size
        @text = text
        super x, y, rerender_text()
    end

    def rerender_text
        @width,@height = @font.size_text(@text)
        @surface = @font.render(@text, true, [255, 255, 255])
    end

    def text
        @text
    end

    def text= string
        @text = string
        rerender_text
    end
end

g = Game.new
g.run!
