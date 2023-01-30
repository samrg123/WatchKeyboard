
class KeyboardButton extends TriangleButton {

    public Face face;
    
    private App app;

    public KeyboardButton(App app, String letters, 
                          Triangle vertices, Rectangle textboxBounds, 
                          String[][] faceChars) {

        this.vertices = vertices;

        // TODO: fix this! This is to cover up the bug of onMouseDown not being called on a button when enabled during mousePressed() 
        this.activeSettings.vibrate = false;
        
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

        // TODO: fix this! This is to cover up the bug of onMouseDown not being called on a button when enabled during mousePressed() 
        activate();

        Circle deadzone = app.kKeyboardDeadzone;
        float deadzoneDistance = distance(mouseX, mouseY, deadzone.x, deadzone.y);

        // Scale transparency of button color based on distance from deadzone center
        // TODO: test this and make sure this works!
        int alpha = int(255 * clamp(deadzoneDistance/deadzone.radius, 0, 1));
        color originalColor = activeSettings.fillColor; 
        
        activeSettings.fillColor = color(red(originalColor), green(originalColor), blue(originalColor), alpha);

        if(deadzoneDistance > deadzone.radius) {

            vibrate(50);
           
            app.currentFace = face;
            app.setState(State.FACE);
           
            deactivate();
        }
    }

    public void onMouseEnter() {
        
        // TODO: fix this! This is to cover up the bug of onMouseDown not being called on a button when enabled during mousePressed() 
        vibrate(50);
        activate();
    }

    public void onMouseExit() {
        deactivate();
    }
};