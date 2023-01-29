
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

    public void onMouseUp() {
        if(!isActive()) return;

        // TODO: Replace this with loren's textbox.addChar func
        //       after merge
        // TODO: add excetion for backspace!
        inputField.str+= inputText;

        deactivate();
    }
}