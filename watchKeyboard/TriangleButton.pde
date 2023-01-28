class TriangleButton extends Button {

    protected Triangle vertices = new Triangle(
        -50, -50,
         50, -50,
         25,  50
    );

    public boolean inBounds(float x, float y) {        
        return vertices.inBounds(x, y);
    }

    public void draw() {
        
        applySettings();

        triangle(
            vertices.v1.x, vertices.v1.y, 
            vertices.v2.x, vertices.v2.y, 
            vertices.v3.x, vertices.v3.y
        );

        super.draw();
    }

}