
class TextInputButton extends TextboxButton {
    
    protected String inputText;
    protected Textbox inputField;

    public TextInputButton(String buttonText, 
                           String inputText, Textbox inputField,
                           Rectangle bounds) {
    
        super(bounds, buttonText);

        this.inputText = inputText;
        this.inputField = inputField;
    }
    
    public void setInputButton(String buttonText, String inputText) {
        textbox.str = buttonText;
        this.inputText = inputText;
    }

    public void onMouseUp() {
        if(!isActive()) return;

        inputField.append(inputText);
        deactivate();

        if (currentSettings.wipeText) {
            textbox.str = "";
            inputText = "";
        }

    }
}