class KeyButton extends Button {

    protected String key = "";
    protected Rectangle rect;
    protected boolean typed = false;

    public KeyButton(Rectangle rect, String key) {

        this.rect = rect;

        this.key = key;
        this.typed = false;

        activeSettings = new Settings() {{
            fillColor = color(234,  85,  20); //orange
            fontColor = color(255, 255, 255); //white
        }};

        inactiveSettings = new Settings() {{
            fillColor = color(  0,   0,   0); //black
            fontColor = color( 58,  58,  58); //dark grey
        }};

        textbox = new Textbox(rect) {{

            str = key;

            wordwrap = true;
            alignment = CENTER;
            //verticalAlignment = CENTER;

            fontSize = 20 * displayDensity;
            
            backgroundColor = color(0,0,0,0); //transparent
            
            setPadding(20);
        }};
    }

    public void setKey(String key) {
        this.key = key;
        textbox.str = key;
    }

    private void typeLetter() {
        this.typed = true;
    }

    public boolean inBounds(float x, float y) {        
        return rect.inBounds(x, y);
    }

    public void draw() {
        applySettings();
        rect(rect.x, rect.y, rect.width, rect.height);
        super.draw();
    }

    public void onMouseDown() {}

    public void onMouseUp() {
        deactivate();
        typeLetter();

    }

    public void onMouseEnter() {
        activate();
    }

    public void onMouseExit()  {
        deactivate();
    }

}

class Face {

    private String[][] config = {
        {
            " ", " ", "T",
            " ", " ", "R",
            "Q", "W", "E"
        },
        {
            "Y", " ", " ",
            "U", " ", " ",
            "I", "O", "P"
        },
        {
            " ", "A", "S",
            " ", " ", "D",
            " ", "G", "F"
        },
        {
            "H", "J", " ",
            "backspace", " ", " ",
            "K", "L", " "
        },
        {
            " ", "Z", "X",
            " ", " ", "C",
            " ", " ", "V"
        },
        {
            "N", "M", " ",
            "B", " ", " ",
            "space", " ", " "
        },
    };

    public Vector<Button> buttons = new Vector<Button>(9);
    //public boolean enabled = false;

    public Face(Rectangle bounds) {
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                buttons.add(new KeyButton(
                    new Rectangle(
                        bounds.x + (bounds.width / 3) * i,
                        bounds.y + (bounds.height / 3) * j,
                        bounds.width / 3,
                        bounds.height / 3
                    ),
                    " "
                ));
                buttons.get(i * 3 + j).enabled = false;
            }
        }
    }

    public String checkTyped() {
        for (int i = 0; i < 9; i++) {
            if (((KeyButton)buttons.get(i)).typed) {
                ((KeyButton)buttons.get(i)).typed = false;
                return ((KeyButton)buttons.get(i)).key;
            }
        }
        return "";
    }

    public void draw(int face_id) {
        //if (this.enabled) {
            for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 3; j++) {
                    String key = config[face_id][i * 3 + j];
                    ((KeyButton)buttons.get(j * 3 + i)).setKey(key);
                    //buttons[i].draw();
                }
            }
        //}
    }
 

}
