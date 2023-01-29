import java.util.Vector;

class Face {

    class KeyButton extends TextInputButton {

        public KeyButton(String keyChar, Textbox textInput, Rectangle bounds) {
            super(keyChar, 
                  keyChar, textInput,
                  bounds
            );

            activeSettings = new Settings() {{
                fillColor = color(234 , 85 , 20); //orange
                fontColor = color(255, 255, 255); //white
            }};

            inactiveSettings = new Settings() {{
                fillColor = color(  0 ,  0 ,  0); //black
                fontColor = color( 58 , 58 , 58); //dark grey
            }};

            // TODO: Replace with verticleAlign Center!
            textbox.setPadding(20);         
        }

        public void onMouseEnter() {
            activate();
        }

        public void onMouseExit() {
            deactivate();
        }        
    };

    public Vector<Button> buttons = new Vector<Button>();

    public Face(Textbox textInput, String[][] chars, Rectangle bounds) {

        int numRows = chars.length;
        float buttonHeight = bounds.height / numRows;

        float yOffset = bounds.y;
        for(String[] row : chars) {

            int numCols = row.length;
            float buttonWidth  = bounds.width / numCols;
            
            float xOffset = bounds.x;
            for(String keyChar : row) {
 
                if(keyChar.length() != 0) {
                    buttons.add(new KeyButton(
                        keyChar, textInput,
                        new Rectangle(xOffset, yOffset, buttonWidth, buttonHeight)
                    ));
                }
 
                xOffset+= buttonWidth;
            }

            yOffset+= buttonHeight;
        }
    }
}
