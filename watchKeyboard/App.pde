// Note: This is dumb, but processing wraps our App code in a
//       wrapper "watchKeyboard" class so we can't have nested classes/enums
enum State {
    INIT,

    START {{
        startButtonEnabled       = true;
    }},

    IDLE {{
        nextButtonEnabled        = true;
        textInputEnabled         = true;
        circleButtonEnabled      = true;
        suggestionButtonsEnabled = true;
    }},

    KEYBOARD {{
        nextButtonEnabled        = true;
        circleButtonEnabled      = true;
        keyboardButtonsEnabled   = true;
    }},

    FACE {{
        nextButtonEnabled        = true;
        circleButtonEnabled      = true;
        faceButtonsEnabled       = true;
    }},

    FINISHED;

    public boolean startButtonEnabled       = false;
    public boolean nextButtonEnabled        = false;
    public boolean textInputEnabled         = false;
    public boolean faceButtonsEnabled       = false;
    public boolean circleButtonEnabled      = false;
    public boolean keyboardButtonsEnabled   = false;
    public boolean suggestionButtonsEnabled = false;
};

class App {

    public final int kNumPhrases = 3;

    public final int   kWatchScreenSize   = 144;
    public final float kWatchPixelScale   = kDPI/kWatchScreenSize;
    public final float kWatchScreenPixels = kWatchPixelScale*kWatchScreenSize;

    public final Rectangle kWatchScreenBounds = new Rectangle(
        .5 * (width - kWatchScreenPixels), .5 * (height - kWatchScreenPixels),
        kWatchScreenPixels, kWatchScreenPixels
    );

    public final float  kKeyboardDeadzoneRatio  = 0.6;
    public final float  kKeyboardDeadzoneRadius = int(kKeyboardDeadzoneRatio * kWatchScreenBounds.width / 2);
    public final Circle kKeyboardDeadzone       = new Circle(kWatchScreenBounds.center(), kKeyboardDeadzoneRadius); 

    public final float kNextButtonSize = 200;
    public final float kNextButtonMargin = 100;
    
    public final Rectangle kNextButtonBounds = new Rectangle(
        width - (kNextButtonSize + kNextButtonMargin), height - (kNextButtonSize + kNextButtonMargin), 
        kNextButtonSize, kNextButtonSize
    );

    public Textbox textInput;

    private PImage watch;
    private PFont font;

    private State state;
    private Phrases phrases;
    private BenchmarkResults benchmarkResults;

    private TextboxButton startButton;
    private TextboxButton nextButton;

    private Button circleButton;
    private Vector<KeyboardButton> keyboardButtons;
    private Vector<Button> suggestionButtons;
    private Face currentFace;

    private WordPredictor wordPredictor = new WordPredictor();
    private TextInputButton predictedWordButton;

    public App() {
    
        // Load font 
        font = createFont("NotoSans-Regular.ttf", 14 * displayDensity);
        textFont(font); //set the font to Noto Sans 14 pt. Creating fonts is expensive, so make difference sizes once in setup, not draw
        noStroke(); //my code doesn't use any strokes
        
        // Load Images
        watch = loadImage("watchhand3smaller.png");
        // finger = loadImage("pngeggSmaller.png"); //not using this

        wordPredictor.load_dictionary("word_freq.txt");
        //wordPredictor.load_dictionary("unigram_freq.csv");
        
        phrases = new Phrases(kNumPhrases);
        benchmarkResults = new BenchmarkResults();

        createStartButton();
        createNextButton();

        // Init watch
        createWatchGUI();
        setState(State.INIT);
    }

    private void createStartButton() {
        startButton = new TextboxButton(kWatchScreenBounds, "Click To Start") {
            public void onMouseDown() {
                super.onMouseDown();

                benchmarkResults.start();
                setState(State.IDLE);
            }
        };

        startButton.inactiveSettings.fillColor = color(  0,   0,   0); //black
        startButton.inactiveSettings.fontColor = color(255, 255, 255); //white
    }

    private void createNextButton() {

        nextButton = new TextboxButton(kNextButtonBounds,"Next") {
            public void onMouseDown() {
                super.onMouseDown();
            
                String targetPhrase = phrases.currentPhrase();
                benchmarkResults.addResults(textInput.getContents(), targetPhrase);

                if(phrases.nextPhrase()) {
                    
                    textInput.clear(); 
                
                } else{

                    setState(State.FINISHED);
                }
            }
        };

        nextButton.inactiveSettings.fillColor = color( 50,  50,  50); 
        nextButton.inactiveSettings.fontColor = color(255, 255, 255); 
    }

    private void createTextInput() {
        
        textInput = new Textbox(kWatchScreenBounds) {{

            fontColor       = color(255, 255, 255, 255); //white
            backgroundColor = color(  0,   0,   0, 255); //black

            setPadding(20);
        }};

        textInput.enableCursor = true;
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
                {"\b" , "" , ""}, 
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
                {" "  , "" , ""},
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
                    vibrate   = true;
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
                vibrate(50);
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
        float bottomButtonHeight = 150; 
        float bottomBarY      = kWatchScreenBounds.y + kWatchScreenBounds.height - bottomButtonHeight;
        float bottomButtonY   = bottomBarY - bottomButtonHeight;
        
        suggestionButtons.add(new TextInputButton(
            UnicodeSymbol.OpenBox.getString(),
            " ", textInput,
            new Rectangle(kWatchScreenBounds.x, bottomButtonY, bottomButtonWidth, bottomButtonHeight)
        ){
            public void onMouseUp() {
                super.onMouseUp();
                setState(State.IDLE);
            }
        });

        predictedWordButton = new TextInputButton(
            "", 
            "", textInput,
            new Rectangle(kWatchScreenBounds.x, bottomBarY, kWatchScreenBounds.width, bottomButtonHeight)
        ) {
            {    
                activeSettings = new Settings(){{
                    vibrate   = true;
                    fillColor = color(234,  85,  20); //orange
                    fontColor = color(255, 255, 255); //white
                }};

                inactiveSettings = new Settings() {{
                    fillColor = color(  0,   0,   0); //black
                    fontColor = color(211, 211, 211); //light grey
                    wipeText = true;
                }};
            }
        };

        suggestionButtons.add(predictedWordButton);

        suggestionButtons.add(new TextInputButton(
            UnicodeSymbol.LeftArrow.getString(), 
            "\b", textInput,
            new Rectangle(kWatchScreenBounds.x + 2*bottomButtonWidth, bottomButtonY, bottomButtonWidth, bottomButtonHeight)
        ){
            public void onMouseUp() {
                super.onMouseUp();
                setState(State.IDLE);
            }
        });
    }

    private void createWatchGUI() {

        createTextInput();
        
        createCircleButton();

        createKeyboardButtons();

        createSuggestionButtons();
    }

    public void drawDeadzoneCircle() {
        stroke(255, 255, 255);
        strokeWeight(10);
        noFill();
        circle(kKeyboardDeadzone.x, kKeyboardDeadzone.y, kKeyboardDeadzone.radius * 2);
        noStroke();
    }

    private void drawWatchGui() {

        // draw2x3();
        // draw_void();
        // draw_void_no_text_entry();
        // draw_quert();

        if(state.textInputEnabled) {
            textInput.draw();
        }

        if (state == State.KEYBOARD) {
            drawDeadzoneCircle();
        }

        Buttons.draw();

        // TODO: draw text fields
        // TODO: draw cursor
    }

    private void setState(State newState) {

        state = newState;

        switch(newState) {

            case INIT: {

                Buttons.clear();
                
                // Note: Buttons are drawn in sequential order            
                
                Buttons.add(startButton);                
                Buttons.add(nextButton);
                
                for(KeyboardButton keyboardButton : keyboardButtons) {

                    Buttons.add(keyboardButton);

                    for(Button b : keyboardButton.face.buttons) {
                        b.enabled = false;
                        Buttons.add(b);
                    }
                }

                Buttons.add(circleButton);
                Buttons.addAll(suggestionButtons);
            

                // TODO: this is kinda hacky, but adding the circle button deactivates it
                //       and sets state to IDLE, so we override that behvior here. Clean this up!
                setState(State.START);
                return;
            }

            case IDLE: {
                String lastWord = textInput.getLastWord();
                String predictedWord = wordPredictor.predict(lastWord);
                if (textInput.isEndWithSpace()) {
                    predictedWordButton.setInputButton("", "");
                }
                else if (lastWord == "") {
                    predictedWordButton.setInputButton(predictedWord, predictedWord);
                }
                else {
                    predictedWordButton.setInputButton(predictedWord, predictedWord.substring(lastWord.length(), predictedWord.length()) + " ");
                }

            } break;

            case FINISHED: {
                
                benchmarkResults.stop();

            } break;
        }

        nextButton.enabled = state.nextButtonEnabled;
        startButton.enabled = state.startButtonEnabled;

        circleButton.enabled = state.circleButtonEnabled;

        for(Button b : keyboardButtons) b.enabled = state.keyboardButtonsEnabled;
        for(Button b : suggestionButtons) b.enabled = state.suggestionButtonsEnabled;

        if(currentFace != null) {
            for(Button b : currentFace.buttons) b.enabled = state.faceButtonsEnabled;
        }
    }

    public void update() {
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

        switch(state) {

            // TODO: Add restart button!
            case FINISHED: {

                benchmarkResults.draw();

            } break;

            default: {

                drawWatch();

                phrases.draw(
                    "DPI: "   + Math.round(kDPI) + " | " +
                    "TIME: "  + ( int(benchmarkResults.getTotalTimeMS() / 1000) ) + " | " +
                    "State: " + String.valueOf(state)
                );
                
            }
        }
    }
}
