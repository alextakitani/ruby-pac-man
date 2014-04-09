class Roleman < GameObject
    RIGHT_IMG = "media/right.png"
    RIGHT_IMG_ALT = "media/right_alt.png"
    LEFT_IMG = "media/left.png"
    LEFT_IMG_ALT = "media/left_alt.png"
    UP_IMG = "media/up.png"
    UP_IMG_ALT = "media/up_alt.png"
    DOWN_IMG = "media/down.png"
    DOWN_IMG_ALT = "media/down_alt.png"

    def initialize x, y, up_key, down_key, left_key, right_key, top_limit, bottom_limit,left_limit,right_limit
        surface = Rubygame::Surface.load Roleman::RIGHT_IMG
        @vx = @vy = 0
        @up_key = up_key
        @down_key = down_key
        @left_key = left_key
        @right_key = right_key
        @moving_up = false
        @moving_down = false
        @moving_left = false
        @moving_right = false
        @top_limit = top_limit
        @bottom_limit = bottom_limit
        @left_limit = left_limit
        @right_limit = right_limit
        @selected_image = ""
        super x, y, surface
    end

    def handle_event event
        case event
            when Rubygame::KeyDownEvent
                case event.key
                when @up_key
                    @moving_up = true
                when @down_key
                    @moving_down = true
                when @left_key
                    @moving_left = true
                when @right_key
                    @moving_right = true
                end
            when Rubygame::KeyUpEvent
                case event.key
                when @up_key
                    @moving_up = false
                when @down_key
                    @moving_down = false
                when @left_key
                    @moving_left = false
                when @right_key
                    @moving_right = false
                end
        end
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

    def score screen
        @vx *= -1
        # Move to somewhere in the middle two-fourths of the screen
        @x = screen.width/4 + rand(screen.width/2)
        # Spawn anywhere on the y-axis except along the edges
        @y = rand(screen.height-50)+25
    end

    def collision paddle, screen
        # Determine which paddle we've hit
        # Left
        if paddle.x < screen.width/2
            # Check if we are behind the paddle
            # (we use a 5 pixel buffer just in case)
            unless @x < paddle.x-5
                @x = paddle.x+paddle.width+1
                @vx *= -1
            end
        # Right
        else
            unless @x > paddle.x+5
                @x = paddle.x-@width-1
                @vx *= -1
            end
        end
    end
end