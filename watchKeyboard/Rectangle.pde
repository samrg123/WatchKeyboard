
class Rectangle {
    float x, y;
    float width, height;

    public Rectangle(float x, float y, float width, float height) {
        
        this.x = x;
        this.y = y;
        
        this.width  = width;
        this.height = height;
    }

    public PVector center() {
        return new PVector(x + .5*width, y + .5*height);
    }

    public boolean inBounds(float x, float y) {
        
        return x >= this.x && x <= (this.x + width) &&
               y >= this.y && y <= (this.y + height);
    }
}