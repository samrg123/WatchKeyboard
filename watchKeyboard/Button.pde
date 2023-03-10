
import java.util.Vector;

abstract class Button {

    public class Settings {
        public color fillColor = color(100, 100, 100, 255); //light grey;
        public color fontColor = color(  0,   0,   0, 255); //black

        public boolean vibrate = false;
        public boolean wipeText = false;
    }

    protected Settings activeSettings = new Settings(){{
        vibrate   = true;
        fillColor = color(234,  85,  20, 255); //orange
        fontColor = color(255, 255, 255, 255); //white
    }};

    protected Settings inactiveSettings = new Settings() {{
        fillColor = color(  0,   0,   0, 255); //black
        fontColor = color(211, 211, 211, 255); //light grey
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

    public boolean enabled = true;
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
        
        if(currentSettings.vibrate) {
            vibrate(30);
        }
    }

    public void deactivate() {
        currentSettings = inactiveSettings;

        if(currentSettings.vibrate) {
            vibrate(30);
        }
    }    

    public boolean isActive() {
        return currentSettings == activeSettings;
    }

    public void onMouseDown() {
        activate();
    }

    public void onMouseUp() {
        deactivate();
    }

    public void onMouseExit() {
        // Note: Needed when you press a button, slide your finger off it, and then release
        deactivate();
    }


    public void onMouseEnter() {}
    public void onMouseDrag()  {}
    public void onMouseStay()  {}
}

class ButtonsClass {

    private Vector<Button> gButtons = new Vector<Button>();

    public Vector<Button> getButtons() {
        
        // Note: we return a copy of the vector so
        //       we don't run into comodified iterator bugs
        //       if we invoke clear() while processing mouse input  
        return new Vector<Button>(gButtons);
    }

    public void clear() {
        gButtons.clear();
    }

    public void remove(Button b) {
        gButtons.remove(b);
    }

    public void removeAll(Vector<Button> buttons) {
        for(Button b : buttons) remove(b);
    }

    public void add(Button b) {
        gButtons.add(b);
        b.Init();
    }

    public void addAll(Vector<Button> buttons) {
        for(Button b : buttons) add(b);
    }

    public void draw() {
        for(Button b : getButtons()) {
            if(b.enabled) b.draw();
        }
    }
}
final ButtonsClass Buttons = new ButtonsClass();

// TOOD: can we place this logic in Buttons class?
void mousePressed() {

    for(Button b : Buttons.getButtons()) {
        
        if(!b.enabled) continue;

        if(b.inBounds(mouseX, mouseY)) {
            b.onMouseDown();
        }
    }
}

void mouseReleased() {

    for(Button b : Buttons.getButtons()) {

        if(!b.enabled) continue;

        if(b.inBounds(mouseX, mouseY)) {
            b.onMouseUp();
        }
    }
}

void mouseDragged() {

    for(Button b : Buttons.getButtons()) {

        if(!b.enabled) continue;

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