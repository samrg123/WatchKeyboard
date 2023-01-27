
import java.util.Vector;

abstract class Button {

    abstract public void draw();

    // TODO: scale mouseX, mouseY by correct factors to match
    // current scale(x);
    // and translate(x, x);
    abstract public boolean inBounds(float x, float y);

    public void onMouseUp()    {}
    public void onMouseDown()  {}
    public void onMouseEnter() {}
    public void onMouseExit()  {}
    public void onMouseDrag()  {}
}

class ButtonsClass {
    
    public Vector<Button> gButtons = new Vector<Button>();

    public void add(Button b) {
        gButtons.add(b);
    }

    public void draw() {

        pushMatrix();

        //Note: Needed to ensure that mouse coordinates match with drawn coordinates
        resetMatrix();

        for(Button b : gButtons) {
            b.draw();
        }

        popMatrix();
    }
}
final ButtonsClass Buttons = new ButtonsClass();

// TOOD: can we place this logic in Buttons class?
void mousePressed() {

    for(Button b : Buttons.gButtons) {

        if(b.inBounds(mouseX, mouseY)) {
            b.onMouseDown();
        }
    }
}

void mouseReleased() {

    for(Button b : Buttons.gButtons) {

        if(b.inBounds(mouseX, mouseY)) {
            b.onMouseUp();
        }
    }
}

void mouseDragged() {
    
    for(Button b : Buttons.gButtons) {

        boolean inBounds = b.inBounds(mouseX, mouseY);
        boolean pInBounds = b.inBounds(pmouseX, pmouseY);

        if(pInBounds) {
       
            if(inBounds) b.onMouseDrag();
            else b.onMouseExit();
       
        } else if(inBounds) {
            b.onMouseEnter();
        }
    }
}