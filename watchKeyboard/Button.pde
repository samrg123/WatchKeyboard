
import java.util.Vector;

abstract class Button {

    public class Settings {
        public color fillColor = color(100, 100, 100, 255); //light grey;
        public color fontColor = color(  0,   0,   0, 255); //black
    }

    protected Settings activeSettings = new Settings(){{
        fillColor = color(0, 255, 0, 255);
    }};

    protected Settings inactiveSettings = new Settings() {{
        fillColor = color(255, 0, 0, 255);
    }};

    protected Settings currentSettings;

    public void applySettings() { 
        
        if(currentSettings == null) return;

        resetMatrix();
        fill(currentSettings.fillColor);

        if(textbox != null) {
            textbox.fontColor = currentSettings.fontColor;
        }
    }

    protected Textbox textbox = null;

    // Initialization function called after global button is added 
    public void Init() {

        // Note: we deactive the button on startup, this 
        //       calls into child class if overriden 
        deactivate();
    }

    public void draw() {

        if(textbox == null) return;

        applySettings();
        textbox.draw();
    }

    // TODO: scale mouseX, mouseY by correct factors to match
    // current scale(x);
    // and translate(x, x);
    abstract public boolean inBounds(float x, float y);

    public void activate() {
        currentSettings = activeSettings;
    }

    public void deactivate() {
        currentSettings = inactiveSettings;
    }    

    public void onMouseDown() {
        activate();
    }

    public void onMouseUp() {
        deactivate();
    }

    public void onMouseEnter() {}
    public void onMouseExit()  {}
    public void onMouseDrag()  {}
}

class ButtonsClass {
    
    public Vector<Button> gButtons = new Vector<Button>();

    public void add(Button b) {
        gButtons.add(b);
        b.Init();
    }

    public void draw() {
        
        for(Button b : gButtons) {
            b.draw();
        }
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