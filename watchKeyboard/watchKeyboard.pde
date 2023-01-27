
// Note: This is dumb, but processing wraps our App code in a
//       wrapper "watchKeyboard" class so we can't have nested classes/enums
enum State {
    INIT,
    RUNNING,
    FINISHED,       
};

class App {

    private PImage watch;
    private PFont font;

    private State state;
    private Phrases phrases;
    private BenchmarkResults benchmarkResults;
        
    private final int kDPIofYourDeviceScreen = 570;
    private final int kWatchScreenSize = 138;
    private final float kWatchPixelScale = float(kDPIofYourDeviceScreen)/kWatchScreenSize;

    private final Rectangle kWatchScreenBounds;

    public App() {
        
        // Init kWatchScreenBounds
        float halfWidth = .5 * width;
        float halfHeight = .5 * height;
        float halfWatchScreen = .5 * kWatchPixelScale*kWatchScreenSize;
        kWatchScreenBounds = new Rectangle(
            halfWidth  - halfWatchScreen, halfWidth  + halfWatchScreen,
            halfHeight - halfWatchScreen, halfHeight + halfWatchScreen
        );

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
        state = State.INIT;
        createWatchGUI();
    }

    private void createWatchGUI() {

        Buttons.add(
            new CircleButton() {
                
                private final PVector kDefaultPosition = new PVector(.5*width, .5*height);
                private final color kActiveColor = color(0, 255, 0, 100);
                private final color kInactiveColor = color(255, 0, 0, 100);

                private final float kActiveRadius = 150;
                private final float kInactiveRadius = 100;

                {
                    center = new PVector(kDefaultPosition.x, kDefaultPosition.y);
                    radius = kInactiveRadius;
                    fillColor = kInactiveColor;
                }

                private void moveToMouse() {
                    center.x = clamp(mouseX, kWatchScreenBounds.x1, kWatchScreenBounds.x2);
                    center.y = clamp(mouseY, kWatchScreenBounds.y1, kWatchScreenBounds.y2);
                }

                private void activateButton() {
                    fillColor = kActiveColor;
                    radius = kActiveRadius;
                    moveToMouse();
                }

                private void deactivateButton() {
                    fillColor = kInactiveColor;
                    radius = kInactiveRadius;
                    center.set(kDefaultPosition);
                }

                public void onMouseDown() {
                    activateButton();
                }

                public void onMouseUp() {
                    deactivateButton();
                }

                public void onMouseEnter() {
                    activateButton();
                }

                public void onMouseExit() {

                    if(kWatchScreenBounds.inBounds(mouseX, mouseY)) {
                        
                        //Note: This can happen on fast movements
                        moveToMouse();

                    } else {
                        deactivateButton();
                    }
                }
                
                public void onMouseDrag() {
                    moveToMouse();
                }
            }
        );

        // TODO: add text fields
        // TODO: add buttons
    }

    private void drawWatchGui() {

        Buttons.draw();
        // TODO: draw text fields
        // TODO: draw cursor

    }

    public void update() {

        if(state == State.INIT) {
            benchmarkResults.startTime = millis();
            state = State.RUNNING;
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
        phrases.draw();
    }
}

App app;

void setup() {

    // Init display
    // Note: fullScreen MUST be first line in setup function
    fullScreen();
    orientation(PORTRAIT);

    app = new App();
}

void draw() {
    app.update();
    app.draw();
}
