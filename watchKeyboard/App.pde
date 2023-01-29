// Note: This is dumb, but processing wraps our App code in a
//       wrapper "watchKeyboard" class so we can't have nested classes/enums
enum State {
    INIT,

    IDLE {{
        textInputEnabled = true;
        circleButtonEnabled = true;
        suggestionButtonsEnabled = true;
    }},

    KEYBOARD {{
        circleButtonEnabled = true;
        keyboardButtonsEnabled = true;
    }},

    FACE {{
        circleButtonEnabled = true;
        faceButtonsEnabled = true;
    }},

    FINISHED;

    public boolean textInputEnabled         = false;
    public boolean faceButtonsEnabled       = false;
    public boolean circleButtonEnabled      = false;
    public boolean keyboardButtonsEnabled   = false;
    public boolean suggestionButtonsEnabled = false;
};

class App {

    public final int   kWatchScreenSize   = 144;
    public final float kWatchPixelScale   = kDPI/kWatchScreenSize;
    public final float kWatchScreenPixels = kWatchPixelScale*kWatchScreenSize;

    public final Rectangle kWatchScreenBounds = new Rectangle(
        .5 * (width - kWatchScreenPixels), .5 * (height - kWatchScreenPixels),
        kWatchScreenPixels, kWatchScreenPixels
    );

    public final float  kKeyboardDeadzoneRatio  = 0.8;
    public final float  kKeyboardDeadzoneRadius = int(kKeyboardDeadzoneRatio * kWatchScreenBounds.width / 2);
    public final Circle kKeyboardDeadzone       = new Circle(kWatchScreenBounds.center(), kKeyboardDeadzoneRadius); 

    public Textbox textInput;

    private PImage watch;
    private PFont font;

    private State state;
    private Phrases phrases;
    private BenchmarkResults benchmarkResults;

    private Button circleButton;
    private Vector<KeyboardButton> keyboardButtons;
    private Vector<Button> suggestionButtons;
    private Face currentFace;

    public App() {
    
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

            fontColor       = color(255, 255, 255, 255); //white
            backgroundColor = color(  0,   0,   0, 255); //black

            setPadding(20);
        }};
    }

    private void createKeyboardButtons() {

        float overScan = 100;        
        Rectangle bounds = new Rectangle(
            kWatchScreenBounds.x - overScan, kWatchScreenBounds.y, 
            kWatchScreenBounds.width + 2*overScan, kWatchScreenBounds.height 
        );

        PVector halfWatchScreenSize = new PVector(.5*kWatchScreenBounds.width, .5*kWatchScreenBounds.height);
        PVector center = bounds.center();

        keyboardButtons = new Vector<KeyboardButton>();
        keyboardButtons.add(new KeyboardButton(
            this, "QWERT",
            new Triangle(
                bounds.x,  bounds.y,
                center.x,  bounds.y,
                center.x,  center.y
            ),
            new Rectangle(
                kWatchScreenBounds.x, kWatchScreenBounds.y,
                halfWatchScreenSize.x, halfWatchScreenSize.y 
            ),

            new String[][] {
                {"" , "" , "T"},
                {"" , "" , "R"},
                {"Q", "W", "E"},
            }
        ));

        keyboardButtons.add(new KeyboardButton(
            this, "YUIOP",
            new Triangle(
                center.x,  bounds.y,
                (bounds.x+bounds.width),  bounds.y,
                center.x,  center.y
            ),
            new Rectangle(
                center.x, bounds.y,
                halfWatchScreenSize.x, halfWatchScreenSize.y 
            ),

            new String[][] {
                {"Y", "" , "" }, 
                {"U", "" , "" }, 
                {"I", "O", "P"},
            }
        ));

        // TODO: Make triangleButton use Triangle Textbox
        //       so that text wraps properly!
        keyboardButtons.add(new KeyboardButton(
            this, "ASDFG",
            new Triangle(
                center.x,  center.y,
                bounds.x,  bounds.y,
                bounds.x,  (bounds.y+bounds.height)
            ),
            new Rectangle(
                kWatchScreenBounds.x, kWatchScreenBounds.y + 150,
                halfWatchScreenSize.x - 150, kWatchScreenBounds.height - 300 
            ),

            new String[][] {
                {"" , "A", "S"},
                {"" , "" , "D"},
                {"" , "G", "F"},
            }
        ));

        keyboardButtons.add(new KeyboardButton(
            this, "HJKL",
            new Triangle(
                center.x,  center.y,
                (bounds.x+bounds.width),  bounds.y,
                (bounds.x+bounds.width),  (bounds.y+bounds.height)
            ),
            new Rectangle(
                center.x + 160, kWatchScreenBounds.y + 150,
                halfWatchScreenSize.x - 160, kWatchScreenBounds.height - 300
            ),

            new String[][] {
                {"H", "J", ""}, 
                {"" , "" , ""}, 
                {"K", "L", ""},
            }            
        ));        
        

        keyboardButtons.add(new KeyboardButton(
            this, "ZXCV",
            new Triangle(
                center.x,  center.y,
                bounds.x,  (bounds.y+bounds.height),
                center.x,  (bounds.y+bounds.height)
            ),
            new Rectangle(
                kWatchScreenBounds.x, (bounds.y+bounds.height)-100,
                halfWatchScreenSize.x, 100 
            ),
        
            new String[][] {
                {"" , "Z", "X"},
                {"" , "" , "C"},
                {"" , "" , "V"},
            }            
        ));

        keyboardButtons.add(new KeyboardButton(
            this, "BNM",
            new Triangle(
                center.x,  center.y,
                center.x,  (bounds.y+bounds.height),
                (bounds.x+bounds.width),  (bounds.y+bounds.height)
            ),
            new Rectangle(
                center.x, (bounds.y+bounds.height)-100,
                halfWatchScreenSize.x, 100 
            ),

            new String[][] {
                {"N" , "M", ""}, 
                {"B" , "" , ""}, 
                {""  , "" , ""},
            }
        ));        

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
                bounds.x = clamp(mouseX, kWatchScreenBounds.x, kWatchScreenBounds.x + kWatchScreenBounds.width);
                bounds.y = clamp(mouseY, kWatchScreenBounds.y, kWatchScreenBounds.y + kWatchScreenBounds.height);
            }

            public void activate() {
                super.activate();

                bounds.radius = 60;
                moveToMouse();
            
                setState(State.KEYBOARD);
            }

            public void deactivate() {
                super.deactivate();

                bounds.radius = 50;
                bounds.setCenter(kWatchScreenBounds.center());
                
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

    private void createSuggestionButtons() {

        PVector halfWatchScreenSize = new PVector(.5*kWatchScreenBounds.width, .5*kWatchScreenBounds.height);

        suggestionButtons = new Vector<Button>();

        float bottomButtonWidth = kWatchScreenBounds.width / 3f; 
        float bottomBarHeight = 150; 
        float bottomBarY      = kWatchScreenBounds.y + kWatchScreenBounds.height - bottomBarHeight;
        
        suggestionButtons.add(new TextInputButton(
            "SP", 
            " ", textInput,
            new Rectangle(kWatchScreenBounds.x, bottomBarY, bottomButtonWidth, bottomBarHeight)
        ));

    
        // TODO: Add text suggestion button in the middle;


        suggestionButtons.add(new TextInputButton(
            "\u2190", //left arrow 
            "\b", textInput,
            new Rectangle(kWatchScreenBounds.x + 2*bottomButtonWidth, bottomBarY, bottomButtonWidth, bottomBarHeight)
        ));
    }

    private void createWatchGUI() {

        createTextInput();
        
        createCircleButton();

        createKeyboardButtons();

        createSuggestionButtons();
    }

    private void drawWatchGui() {

        // draw2x3();
        // draw_void();
        // draw_void_no_text_entry();
        // draw_quert();

        if(state.textInputEnabled) {
            textInput.draw();
        }

        Buttons.draw();

        // TODO: draw text fields
        // TODO: draw cursor
    }

    private void setState(State newState) {

        if(newState == State.INIT) {
            state = State.INIT;
            
            Buttons.clear();
            
            // Note: Buttons are drawn in sequential order            
            for(KeyboardButton keyboardButton : keyboardButtons) {

                Buttons.add(keyboardButton);

                for(Button b : keyboardButton.face.buttons) {
                    b.enabled = false;
                    Buttons.add(b);
                }
            }

            Buttons.add(circleButton);
            Buttons.addAll(suggestionButtons);
        
            return;
        }

        state = newState;

        circleButton.enabled = state.circleButtonEnabled;

        for(Button b : keyboardButtons) b.enabled = state.keyboardButtonsEnabled;
        for(Button b : suggestionButtons) b.enabled = state.suggestionButtonsEnabled;

        if(currentFace != null) {
            for(Button b : currentFace.buttons) b.enabled = state.faceButtonsEnabled;
        }
    }

    public void update() {
        if(state == State.INIT) {
            benchmarkResults.startTime = millis();
            setState(State.IDLE);
        }
        
        //TODO: blink cursor!
    }

    private void clearScreen() {
        background(0); // fill backgroung with black
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

        textLeading(50);

        drawWatch();
        phrases.draw(
            "DPI:   " + Math.round(kDPI) + " | " +
            "State: " + String.valueOf(state)
        );
    }
}
