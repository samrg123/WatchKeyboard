class TriangleButton extends Button {

    Triangle vertices = new Triangle(
        -50, -50,
         50, -50,
         25,  50
    );

    protected color fillColor = color(0, 0, 0, 255);

    public boolean inBounds(float x, float y) {
        
        return vertices.inBounds(x, y);
    }

    public void draw() {
        fill(fillColor);
        triangle(
            vertices.v1.x, vertices.v1.y, 
            vertices.v2.x, vertices.v2.y, 
            vertices.v3.x, vertices.v3.y
        );
    }

}