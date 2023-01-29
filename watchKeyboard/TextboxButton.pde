
class TextboxButton extends Button {

    public TextboxButton(Rectangle bounds, String str) {
        textbox = new Textbox(bounds);
        textbox.str = str;
        textbox.alignment = CENTER;
    }

    public void setBounds(Rectangle bounds) {
        textbox.set(bounds);
    }
    public boolean inBounds(float x, float y) {
        return textbox.inBounds(x, y);
    }

    public void applySettings() {
        
        super.applySettings();

        if(currentSettings == null) return;

        textbox.backgroundColor = currentSettings.fillColor;
    }
};