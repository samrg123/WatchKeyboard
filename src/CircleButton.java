import Button;

class CircleButton extends Button {

    private float center;
    private float radius;


    public Bool IsInBounds(float x, float y) {
        
        float minCoord = center-radius;
        if(x < minCoord || y < minCoord) return false; 
        
        float maxCoord = center+radius;
        return x <= maxCoord && y <= maxCoord;
    }

    // public vooi


    public void Draw() {

    }

}