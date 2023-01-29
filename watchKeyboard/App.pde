// Note: This is dumb, but processing wraps our App code in a
//       wrapper "watchKeyboard" class so we can't have nested classes/enums
enum State {
    INIT,

    IDLE,
    KEYBOARD,
    SELECT_LETTER,

    FINISHED,
};

class App {

    private PImage watch;
    private PFont font;

    private State state;
    private Phrases phrases;
    private BenchmarkResults benchmarkResults;
        
    private final int kWatchScreenSize = 144;
    private final float kWatchPixelScale = kDPI/kWatchScreenSize;

    private final float deadzoneRatio = 0.8;
    private int deadzone;


    private final Rectangle kWatchScreenBounds;

    private Button circleButton;
    private Vector<Button> keyboardButtons;
    private Vector<Button> idleButtons;
    private Face face;
    private int faceID = 0;

    private Textbox textInput;

    public App() {
        
        // Init kWatchScreenBounds
        float watchScreenPixels = kWatchPixelScale*kWatchScreenSize;
        kWatchScreenBounds = new Rectangle(
            .5 * (width - watchScreenPixels), .5 * (height - watchScreenPixels),
            watchScreenPixels, watchScreenPixels
        );

        deadzone = int(deadzoneRatio * kWatchScreenBounds.width / 2);

        // Load font 
        font = createFont("NotoSans-Regular.ttf", 14 * displayDensity);
        textFont(font); //set the font to Noto Sans 14 pt. Creating fonts is expensive, so make difference sizes once in setup, not draw
        noStroke(); //my code doesn't use any strokes
        
        // Load Images
        watch = loadImage("watchhand3smaller.png");
        // finger = loadImage("pngeggSmaller.png"); //not using this
        
        phrases = new Phrases(2);
        benchmarkResults = new BenchmarkResults();

        // Init watch
        createWatchGUI();
        setState(State.INIT);
    }

    private void createTextInput() {
        
        textInput = new Textbox(kWatchScreenBounds) {{

            str = "";

            fontColor       = color(255, 255, 255, 255); //white
            backgroundColor = color(  0,   0,   0, 255); //black

            setPadding(20);
        }};
    }

    private void createKeyboardButtons() {

        class KeyboardButton extends TriangleButton {

            public KeyboardButton(String letters, Triangle vertices, Rectangle textboxBounds) {

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
            }

            public void onMouseEnter() {
                //activate();
            }

            public void onMouseExit() {
                deactivate();
            }

        };

        float overScan = 100;        
        Rectangle bounds = new Rectangle(
            kWatchScreenBounds.x - overScan, kWatchScreenBounds.y, 
            kWatchScreenBounds.width + 2*overScan, kWatchScreenBounds.height 
        );

        PVector halfWatchScreenSize = new PVector(.5*kWatchScreenBounds.width, .5*kWatchScreenBounds.height);
        PVector center = bounds.center();

        keyboardButtons = new Vector<Button>();
        keyboardButtons.add(new KeyboardButton(
            "QWERT",
            new Triangle(
                bounds.x,  bounds.y,
                center.x,  bounds.y,
                center.x,  center.y
            ),
            new Rectangle(
                kWatchScreenBounds.x, kWatchScreenBounds.y,
                halfWatchScreenSize.x, halfWatchScreenSize.y 
            )
        ){
            public void onMouseDrag() {
                super.activate();
                if (distance(mouseX, mouseY, center.x, center.y) > deadzone) {
                    setState(State.SELECT_LETTER);
                    faceID = 0;
                    super.deactivate();
                }
            }
        });

        keyboardButtons.add(new KeyboardButton(
            "YUIOP",
            new Triangle(
                center.x,  bounds.y,
                (bounds.x+bounds.width),  bounds.y,
                center.x,  center.y
            ),
            new Rectangle(
                center.x, bounds.y,
                halfWatchScreenSize.x, halfWatchScreenSize.y 
            )
        ){
            public void onMouseDrag() {
                super.activate();
                if (distance(mouseX, mouseY, center.x, center.y) > deadzone) {
                    setState(State.SELECT_LETTER);
                    faceID = 1;
                    super.deactivate();
                }
            }
        });


        // TODO: Make triangleButton use Triangle Textbox
        //       so that text wraps properly!
        keyboardButtons.add(new KeyboardButton(
            "ASDFG",
            new Triangle(
                center.x,  center.y,
                bounds.x,  bounds.y,
                bounds.x,  (bounds.y+bounds.height)
            ),
            new Rectangle(
                kWatchScreenBounds.x, kWatchScreenBounds.y + 150,
                halfWatchScreenSize.x - 150, kWatchScreenBounds.height - 300 
            )
        ){
            public void onMouseDrag() {
                super.activate();
                if (distance(mouseX, mouseY, center.x, center.y) > deadzone) {
                    setState(State.SELECT_LETTER);
                    faceID = 2;
                    super.deactivate();
                }
            }
        });

        keyboardButtons.add(new KeyboardButton(
            "HJKL",
            new Triangle(
                center.x,  center.y,
                (bounds.x+bounds.width),  bounds.y,
                (bounds.x+bounds.width),  (bounds.y+bounds.height)
            ),
            new Rectangle(
                center.x + 160, kWatchScreenBounds.y + 150,
                halfWatchScreenSize.x - 160, kWatchScreenBounds.height - 300
            )
        ){
            public void onMouseDrag() {
                super.activate();
                if (distance(mouseX, mouseY, center.x, center.y) > deadzone) {
                    setState(State.SELECT_LETTER);
                    faceID = 3;
                    super.deactivate();
                }
            }
        });        
        

        keyboardButtons.add(new KeyboardButton(
            "ZXCV",
            new Triangle(
                center.x,  center.y,
                bounds.x,  (bounds.y+bounds.height),
                center.x,  (bounds.y+bounds.height)
            ),
            new Rectangle(
                kWatchScreenBounds.x, (bounds.y+bounds.height)-100,
                halfWatchScreenSize.x, 100 
            )
        ){
            public void onMouseDrag() {
                super.activate();
                if (distance(mouseX, mouseY, center.x, center.y) > deadzone) {
                    setState(State.SELECT_LETTER);
                    faceID = 4;
                    super.deactivate();
                }
            }
        });

        keyboardButtons.add(new KeyboardButton(
            "BNM",
            new Triangle(
                center.x,  center.y,
                center.x,  (bounds.y+bounds.height),
                (bounds.x+bounds.width),  (bounds.y+bounds.height)
            ),
            new Rectangle(
                center.x, (bounds.y+bounds.height)-100,
                halfWatchScreenSize.x, 100 
            )
        ){
            public void onMouseDrag() {
                super.activate();
                if (distance(mouseX, mouseY, center.x, center.y) > deadzone) {
                    setState(State.SELECT_LETTER);
                    faceID = 5;
                    super.deactivate();
                }
            }
        });        

    }

    private void createCircleButton() {
       
        // TODO: Make this a special rectangular button the size of the screen
        //       that draws circle to follow finger.... This way we can span to
        //       anywhere the user touches on screen, not just the circle area.
        circleButton = new CircleButton() {
            {    
                activeSettings = new Settings(){{
                    fillColor = color( 46, 167, 224, .5*255); //transparent blue
                }};

                inactiveSettings = new Settings(){{
                    fillColor = color(160, 160, 160); //grey
                }};
            }

            protected void moveToMouse() {
                center.x = clamp(mouseX, kWatchScreenBounds.x, kWatchScreenBounds.x + kWatchScreenBounds.width);
                center.y = clamp(mouseY, kWatchScreenBounds.y, kWatchScreenBounds.y + kWatchScreenBounds.height);
            }

            public void activate() {
                super.activate();

                radius = 60;
                moveToMouse();
            
                setState(State.KEYBOARD);
            }

            public void deactivate() {
                super.deactivate();

                radius = 50;
                center.set(kWatchScreenBounds.center());
                
                setState(State.IDLE);
            }

            public void onMouseEnter() {
                activate();
            }

            public void onMouseExit() {

                if(kWatchScreenBounds.inBounds(mouseX, mouseY)) {
                    
                    //Note: This can happen on fast movements
                    moveToMouse();

                } else {
                    deactivate();
                }
            }
            
            public void onMouseDrag() {
                moveToMouse();
            }
        };
    }

    private void createIdleButtons() {

        PVector halfWatchScreenSize = new PVector(.5*kWatchScreenBounds.width, .5*kWatchScreenBounds.height);

        idleButtons = new Vector<Button>();

        float bottomButtonWidth = kWatchScreenBounds.width / 3f; 
        float bottomBarHeight = 150; 
        float bottomBarY      = kWatchScreenBounds.y + kWatchScreenBounds.height - bottomBarHeight;
        
        idleButtons.add(new TextInputButton(
            "SP", 
            " ", textInput,
            new Rectangle(kWatchScreenBounds.x, bottomBarY, bottomButtonWidth, bottomBarHeight)
        ));

    
        // TODO: Add text suggestion button in the middle;


        idleButtons.add(new TextInputButton(
            "\u2190", //left arrow 
            "\b", textInput,
            new Rectangle(kWatchScreenBounds.x + 2*bottomButtonWidth, bottomBarY, bottomButtonWidth, bottomBarHeight)
        ));
    }

    private void createWatchGUI() {

        createTextInput();
        
        createCircleButton();

        createKeyboardButtons();

        createIdleButtons();

        face = new Face(kWatchScreenBounds);
    }

    private void drawWatchGui() {

        // draw2x3();
        // draw_void();
        // draw_void_no_text_entry();
        // draw_quert();

        textInput.draw();
        if (state == State.SELECT_LETTER) {
            face.draw(faceID);
        }
        Buttons.draw();

        // TODO: draw text fields
        // TODO: draw cursor

    }

    private void setState(State newState) {
        
        switch(newState) {

            case INIT: {

                state = State.INIT;
                Buttons.clear();
                Buttons.addAll(keyboardButtons);
                Buttons.addAll(face.buttons);
                Buttons.add(circleButton);
                Buttons.addAll(idleButtons);

            } break;

            case IDLE: {

                state = State.IDLE;
                circleButton.enabled = true;
                //face.enabled = false;
                for(Button b : idleButtons) b.enabled = true;
                for(Button b : keyboardButtons) b.enabled = false;
                for(Button b : face.buttons) b.enabled = false;
 
            } break;

            case KEYBOARD: {
                
                state = State.KEYBOARD;
                circleButton.enabled = true;
                //face.enabled = false;
                for(Button b : idleButtons) b.enabled = false;
                for(Button b : keyboardButtons) b.enabled = true;
                for(Button b : face.buttons) b.enabled = false;

            } break;

            case SELECT_LETTER: {
                vibrate(50);
                state = State.SELECT_LETTER;
                circleButton.enabled = true;
                //face.enabled = true;
                for(Button b : idleButtons) b.enabled = false;
                for(Button b : keyboardButtons) b.enabled = false;
                for(Button b : face.buttons) b.enabled = true;

            } break;

            default: {
                assert(false);
            } break;
        }
    }

    public void update() {
        if(state == State.INIT) {
            benchmarkResults.startTime = millis();
            setState(State.IDLE);
        }
        else if (state == State.IDLE) {
            String result = face.checkTyped();    
            if (result != "") {
                switch (result) {
                    case " ":
                        break;
                    case "space":
                        textInput.addChar(' ');
                        break;
                    case "backspace":
                        textInput.removeChar();
                        break;
                    default:
                        textInput.addChar(result.toLowerCase().charAt(0));
                        break;
                }
                setState(State.IDLE);
            }
        }
        
        //TODO: blink cursor!
    }

    private void clearScreen() {
        background(255);
    }

    private void drawWatch() {

        // Note: We draw GUI first so elements drawn off watch screen get covered up
        drawWatchGui();

        pushMatrix();

        // Draw watch background image
        translate(width/2, height/2);
        scale(kWatchPixelScale);
        imageMode(CENTER);
        image(watch, 0, 0);
        
        popMatrix();    
    }

    public void draw() {

        clearScreen();

        if(state == State.FINISHED) {
            benchmarkResults.draw();
            return;
        }

        drawWatch();
        phrases.draw("FaceID: " + String.valueOf(faceID)
            + " State: " + String.valueOf(state)
        );
    }
}
