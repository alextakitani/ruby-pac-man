class Tijolo < GameObject
    def initialize x, y
        surface = Rubygame::Surface.load "../media/tijolo.jpg"
        super x, y, surface
    end
end
