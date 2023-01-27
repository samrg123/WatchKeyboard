
import java.util.Vector;

abstract class Button {

    abstract public void draw();
    abstract public boolean inBounds(float x, float y);

    public void onMouseUp()    {}
    public void onMouseDown()  {}
    public void onMouseEnter() {}
    public void onMouseExit()  {}
}

static class Buttons {
    
    public static Vector<Button> gButtons = new Vector<Button>();

    public static void add(Button b) {
        gButtons.add(b);
    }

    public static void draw() {
        for(Button b : gButtons) {
            b.draw();
        }
    }
}

// TOOD: Make this a process function in Buttons
void mousePressed() {

    for(Button b : Buttons.gButtons) {

        // TODO: scale mouseX, mouseY by correct factors to match
        // current scale(x);
        // and translate(x, x);

        println(b.inBounds(mouseX, mouseY));

        if(b.inBounds(mouseX, mouseY)) {
            b.onMouseDown();
        }
    }
}