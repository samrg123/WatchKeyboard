class Button {

    abstract Bool IsInBounds(float x, float y);

    public void OnHover() {}

    public void OnMouseEnter() {}

    public void OnMouseExit() {}    

    public void OnMouseDown() {}

    public void OnMouseUp() {}

    // TODO(Sam): should we have this event driven instead?
    public void Update() {

        if(IsInBounds(mouseX, mouseY)) {
            
        }


        // if()

        // if(mouse)


        // get mouse X and Y

    }

    abstract public void Draw();

}