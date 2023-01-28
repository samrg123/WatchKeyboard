class CircleButton extends Button {

    protected float radius = 100;
    protected PVector center = new PVector(0, 0);

    public boolean inBounds(float x, float y) {

        float dx = center.x - x;
        float dy = center.y - y; 

        // distace^2 < radius^2 
        return (dx*dx + dy*dy) <= (radius*radius);
    }

    public void draw() {

        applySettings();

        circle(center.x, center.y, 2*radius);

        super.draw();
    }

}