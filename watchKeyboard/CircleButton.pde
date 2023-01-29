class CircleButton extends Button {

    protected Circle bounds = new Circle(0, 0, 100);

    public boolean inBounds(float x, float y) {
        return bounds.inBounds(x, y);
    }

    public void draw() {

        applySettings();

        circle(bounds.x, bounds.y, 2*bounds.radius);

        super.draw();
    }

}