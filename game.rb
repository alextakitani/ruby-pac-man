require 'rubygems'
require 'rubygame'
require './game_object'
require './roleman'
Rubygame::TTF.setup

class Game
    def initialize
        @screen = Rubygame::Screen.new [640, 480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
        @screen.title = "Role-Man"

        @queue = Rubygame::EventQueue.new
        @clock = Rubygame::Clock.new
        @clock.target_framerate = 60

        limit = @screen.height - 10
        limit_right = @screen.width - 10

        @roleman = Roleman.new @screen.width/2, @screen.height/2, Rubygame::K_UP, Rubygame::K_DOWN, Rubygame::K_LEFT, Rubygame::K_RIGHT, 10, limit, 10,limit_right
        @won = false

        @win_text = Text.new
        @play_again_text = Text.new 0, 0, "Play Again? Press Y or N", 40
        @background = Background.new @screen.width, @screen.height
    end

    def run!
        loop do
            update
            draw
            @clock.tick
        end
    end

    def win player
        if player == 1
            @win_text.text = "Player 1 Wins!"
        elsif player == 2
            @win_text.text = "Player 2 Wins!"
        end
        @won = true
        @win_text.center_x @screen.width
        @win_text.center_y @screen.height
        @play_again_text.center_x @screen.width
        @play_again_text.y = @win_text.y+60
    end

    def update

        @roleman.update @screen unless @won


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
                    if ev.key == Rubygame::K_Y and @won
                        # Reset the game
                        @player.center_y @screen.height
                        @enemy.center_y @screen.height
                        @player.score = 0
                        @enemy.score = 0
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
            @roleman.draw @screen
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



class Paddle < GameObject
    def initialize x, y, score_x, score_y, up_key, down_key, top_limit, bottom_limit
        surface = Rubygame::Surface.new [20, 100]
        surface.fill [255, 255, 255]
        @up_key = up_key
        @down_key = down_key
        @moving_up = false
        @moving_down = false
        @top_limit = top_limit
        @bottom_limit = bottom_limit

        @score = 0
        @score_text = Text.new score_x, score_y, @score.to_s, 100

        super x, y, surface
    end

    def handle_event event
        case event
            when Rubygame::KeyDownEvent
                if event.key == @up_key
                    @moving_up = true
                elsif event.key == @down_key
                    @moving_down = true
                end
            when Rubygame::KeyUpEvent
                if event.key == @up_key
                    @moving_up = false
                elsif event.key == @down_key
                    @moving_down = false
                end
        end
    end

    def update
        if @moving_up and @y > @top_limit
            @y -= 5
        end
        if @moving_down and @y+@height < @bottom_limit
            @y += 5
        end
    end

    def score
        @score
    end

    def score= num
        @score = num
        @score_text.text = num.to_s
    end

    def draw screen
        super
        @score_text.draw screen
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
        # Middle Divide
        #surface.draw_box_s [surface.width/2-5, 0], [surface.width/2+5, surface.height], white

        super 0, 0, surface
    end
end

class Text < GameObject
    def initialize x=0, y=0, text="Hello, World!", size=48
        @font = Rubygame::TTF.new "Freshman.ttf", size
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
