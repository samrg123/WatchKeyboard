class CircleButton extends Button {

    protected PVector center = new PVector(0, 0);
    protected float radius = 100;

    protected color fillColor = color(20, 20, 20, 255);

    public boolean inBounds(float x, float y) {

        return x >= (center.x-radius) && y >= (center.y-radius) &&
               x <= (center.x+radius) && y <= (center.y+radius);
    }

    public void draw() {
        fill(fillColor);
        circle(center.x, center.y, radius);
    }

}