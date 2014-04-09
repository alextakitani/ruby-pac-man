class Pulica < GameObject
    RIGHT_IMG = "media/gualda.png"
    RIGHT_IMG_ALT = "media/gualda.png"
    LEFT_IMG = "media/gualda.png"
    LEFT_IMG_ALT = "media/gualda.png"
    UP_IMG = "media/gualda.png"
    UP_IMG_ALT = "media/gualda.png"
    DOWN_IMG = "media/gualda.png"
    DOWN_IMG_ALT = "media/gualda.png"

    def initialize x, y
        surface = Rubygame::Surface.load Pulica::RIGHT_IMG
        @vx = @vy = 0
        @moving_up = false
        @moving_down = false
        @moving_left = false
        @moving_right = false
        super x, y, surface
    end


    def update screen
        @x += @vx
        @y += @vy

        if @moving_up and @y > @top_limit
            @selected_image = @selected_image == Roleman::UP_IMG ? Roleman::UP_IMG_ALT : Roleman::UP_IMG
            self.surface = Rubygame::Surface.load @selected_image
            @y -= 5
        end
        if @moving_down and @y+@height < @bottom_limit
            @selected_image = @selected_image == Roleman::DOWN_IMG ? Roleman::DOWN_IMG_ALT : Roleman::DOWN_IMG
            self.surface = Rubygame::Surface.load @selected_image
            @y += 5
        end
        if @moving_left and @x > @left_limit
            @selected_image = @selected_image == Roleman::LEFT_IMG ? Roleman::LEFT_IMG_ALT : Roleman::LEFT_IMG
            self.surface = Rubygame::Surface.load @selected_image
            @x -= 5
        end
        if @moving_right and @x+@height < @right_limit
            @selected_image = @selected_image == Roleman::RIGHT_IMG ? Roleman::RIGHT_IMG_ALT : Roleman::RIGHT_IMG
            self.surface = Rubygame::Surface.load @selected_image
            @x += 5
        end

    end


end