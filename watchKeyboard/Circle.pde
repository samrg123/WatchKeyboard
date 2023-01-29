
class Circle {

    public float x, y;
    public float radius = 100;

    public Circle(float x, float y, float radius) {
        this.x = x;
        this.y = y;
        this.radius = radius; 
    }

    public Circle(PVector center, float radius) {
        this(center.x, center.y, radius);
    }

    public void setCenter(PVector center) {
        x = center.x;
        y = center.y;
    }

    public boolean inBounds(float x, float y) {

        float dx = this.x - x;
        float dy = this.y - y; 

        // distace^2 < radius^2 
        return (dx*dx + dy*dy) <= (radius*radius);
    }

};