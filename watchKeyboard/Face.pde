import java.util.Vector;

class Face {

    public String getDisplayChar(String key) {
        String displayedChar = key;
        switch (displayedChar) {
            case " ":
                displayedChar = UnicodeSymbol.OpenBox.getString();
                break;
            case "\b":
                displayedChar = UnicodeSymbol.LeftArrow.getString();
                break;
            default:
                
                break;
        }
        return displayedChar;
    }

    class KeyButton extends TextInputButton {

        public KeyButton(String keyChar, Textbox textInput, Rectangle bounds) {
            super(getDisplayChar(keyChar),
                  keyChar.toLowerCase(), textInput,
                  bounds
            );         
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
