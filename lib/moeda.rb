class Moeda < GameObject
    def initialize x, y
        surface = Rubygame::Surface.load "../media/bolinha.png"
        super x, y, surface
    end
end
