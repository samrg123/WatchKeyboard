
class KeyboardButton extends TriangleButton {

    public Face face;
    
    private App app;

    public KeyboardButton(App app, String letters, 
                          Triangle vertices, Rectangle textboxBounds, 
                          String[][] faceChars) {

        activeSettings = new Settings() {{
            fillColor = color(234,  85,  20); //orange
            fontColor = color(255, 255, 255); //white
        }};

        inactiveSettings = new Settings() {{
            fillColor = color(  0,   0,   0); //black
            fontColor = color( 58,  58,  58); //dark grey
        }};

        this.vertices = vertices;
        
        textbox = new Textbox(textboxBounds) {{

            str = letters;

            wordwrap = true;
            alignment = CENTER;
            backgroundColor = color(0,0,0,0); //transparent
            
            setPadding(20);
        }};

        this.app = app;
        face = new Face(app.textInput, faceChars, app.kWatchScreenBounds);
    }

    public void onMouseDrag() {
        activate();
        
        // TODO: Change opacity with distance?
        if(!app.kKeyboardDeadzone.inBounds(mouseX, mouseY)) {

            vibrate(50);
           
            app.currentFace = face;
            app.setState(State.FACE);
           
            deactivate();
        }
    }

    public void onMouseEnter() {
        activate();
    }

    public void onMouseExit() {
        deactivate();
    }
};