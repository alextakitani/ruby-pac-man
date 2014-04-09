class GameObject
    attr_accessor :x, :y, :width, :height, :surface

    def initialize x, y, surface
        @x = x
        @y = y
        @surface = surface
        @width = surface.width
        @height = surface.height
    end

    def update
    end

    def draw screen
        @surface.blit screen, [@x, @y]
    end

    def handle_event event
    end

    def center_x w
        @x = w/2-@width/2
    end

    def center_y h
        @y = h/2-@height/2
    end
end