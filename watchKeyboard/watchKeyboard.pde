
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
            halfWidth  - halfWatchScreen, halfHeight - halfWatchScreen,
            halfWidth  + halfWatchScreen, halfHeight + halfWatchScreen
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

        float overscan = 100;
        
        Rectangle triangleButtonBounds = new Rectangle(
            kWatchScreenBounds.x1 - overscan, kWatchScreenBounds.y1, 
            kWatchScreenBounds.x2 + overscan, kWatchScreenBounds.y2 
        );

        PVector triangleButtonCenter = triangleButtonBounds.center();

        Buttons.add(new TriangleButton() {
            {
                vertices = new Triangle(
                    triangleButtonBounds.x1, triangleButtonBounds.y1,
                    triangleButtonCenter.x,  triangleButtonBounds.y1,
                    triangleButtonCenter.x,  triangleButtonCenter.y
                );
            }

            // TODO: Move this stuff into Button.... resuse code for circle button
            private final color kActiveFillColor   = color(234, 85, 20); //orange
            private final color kInactiveFillColor = color(0, 0, 0);     //black 
            
            private final color kActiveTextColor   = color(255, 255, 255); //white 
            private final color kInactiveTextColor = color( 58,  58,  58); //dark grey 

            // TODO: Move this into textbox?
            private String text = "QWERT";
            private color textColor = kInactiveTextColor;

            private void activate() {
                fillColor = kActiveFillColor;
                textColor = kActiveTextColor;
            }

            private void deactivate() {
                fillColor = kInactiveFillColor;
                textColor = kInactiveTextColor;                
            }            

            public void onMouseDown() {
                activate();
            }

            public void onMouseEnter() {
                activate();
            }

            public void onMouseUp() {
                deactivate();
            }

            public void onMouseExit() {
                deactivate();

            }
        });

        Buttons.add(new CircleButton() {
                
            private final PVector kDefaultPosition = new PVector(.5*width, .5*height);
            private final color kActiveColor = color(46, 167, 224); //blue
            private final color kInactiveColor = color(160, 160, 160); //grey

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

            private void activate() {
                fillColor = kActiveColor;
                radius = kActiveRadius;
                moveToMouse();
            }

            private void deactivate() {
                fillColor = kInactiveColor;
                radius = kInactiveRadius;
                center.set(kDefaultPosition);
            }

            public void onMouseDown() {
                activate();
            }

            public void onMouseUp() {
                deactivate();
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
        });

        // TODO: add text fields
        // TODO: add buttons
    }

    private void drawWatchGui() {

        // draw2x3();
        // draw_void();
        // draw_void_no_text_entry();
        // draw_quert();

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
