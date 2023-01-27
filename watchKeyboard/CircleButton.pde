class CircleButton extends Button {

    protected PVector center = new PVector(0, 0);
    protected float radius = 100;

    protected color fillColor = color(20, 20, 20, 255);

    public boolean inBounds(float x, float y) {

        float dx = center.x - x;
        float dy = center.y - y; 

        // println("Center: "+center.x+"|"+center.y+"; "+dx+"|"+dy);
        println("w: "+pixelWidth+"|"+width+"; "+dx+"|"+dy);
        // println("Center: "+center.x+"|"+center.y+"; "+x+"|"+y);


        // distace^2 < radius^2 
        return (dx*dx + dy*dy) <= (radius*radius);
    }

    public void draw() {
        fill(fillColor);
        circle(center.x, center.y, 2*radius);
    }

}