class Textbox extends Rectangle {

    // TODO: Add optional cursor?

    public float fontSize = 14*displayDensity;
    public float lineSpacing = 0;

    public int alignment = LEFT;
    public int verticalAlignment = TOP;

    public boolean wordwrap = true;
    public String truncatedSymbol = "\u2026"; //ellipses

    public color fontColor = color(0, 0, 0, 255); //black
    public color backgroundColor = color(255, 255, 255, 255); //white

    public float paddingTop    = 0;
    public float paddingBottom = 0;
    public float paddingLeft   = 0;
    public float paddingRight  = 0;

    protected String str = "";

    public Textbox(Rectangle r) {
        super(r.x, r.y, r.width, r.height);
    }

    public Textbox(float x, float y, float width, float height) {
        super(x, y, width, height);
    }

    public void setPadding(float padding) {
        paddingTop    = padding;
        paddingBottom = padding;
        paddingLeft   = padding;
        paddingRight  = padding;
    }

    // Returns the maximum length substring of str that is no longer than maxWidth 
    public String getSubstr(String str, float maxWidth) {

        // TODO: Make this a loop instead of recursion ... prefer to split on space, ect.

        if(maxWidth <= 0) return "";

        int strLength = str.length();
        if(strLength == 0) return str;

        float lineWidth = textWidth(str);
        if(lineWidth <= maxWidth) return str;

        // Try to fit left half of string 
        int pivotIndex = strLength/2;
        String leftStr = getSubstr(str.substring(0, pivotIndex), maxWidth);
        
        // Had to truncate the left half of string, just return the result
        if(leftStr.length() < pivotIndex) return leftStr;
        
        // left half of string fits, try to fit remaining n-1 chars
        float leftWidth = textWidth(leftStr);
        return leftStr + getSubstr(str.substring(pivotIndex, strLength-1), maxWidth - leftWidth);
    }

    public String getTruncatedLine(String str) {

        float maxWidth = width - paddingRight;

        String line = getSubstr(str, maxWidth);
        if(line.length() == str.length()) return line;
        
        float truncatedSymbolWidth = textWidth(truncatedSymbol);
        return getSubstr(str, maxWidth - truncatedSymbolWidth) + truncatedSymbol;        
    }

    // draws text to Textbox using alignmentment.
    // Note: xOffset and yOffset are relative to textbox upper left corner
    public void textAligned(String str, float xOffset, float yOffset) {

        textAlign(LEFT, TOP);

        float xCoord = x + xOffset;
        switch(alignment) {
            
            case CENTER: {
                float strWidth = textWidth(str);
                xCoord+= (width - strWidth)/2; 
            } break;

            case RIGHT: {
                float strWidth = textWidth(str);
                xCoord+= width - strWidth - paddingRight;
            } break;

            // Note: Default to left aligned
            default: {
                xCoord+= paddingLeft;
            } break;	
        }

        float yCoord = y + yOffset;
        switch(verticalAlignment) {
         
            case CENTER: 
            case BOTTOM: {

                // TODO: implement this if we need it.
                //       non-top verticalAlignment would force us to word-wrap
                //       differently (IE with two passes) and searching every 
                //       char in string for newlines.  
                assert(false);
            } break;

            // NOTE: default to top aligned
            default: {
                yCoord+= paddingTop;
            } break;
        }
        
        text(str, xCoord, yCoord);
    }

    public void textAligned(String str) { textAligned(str, 0, 0); }

    public void setString(String str) { this.str = str; }

    public void removeChar() { 
        if(str.length() == 0) return;
        str = str.substring(0, str.length()-1); 
    }

    public void addChar(char c) { 

        if(c == '\b') removeChar();
        else str+= c; 
    }

    public void append(String s) {
        
        int sLength = s.length();
        for(int i = 0; i < sLength; ++i) {
            addChar(s.charAt(i));
        }
    }

    public void draw() {

        if(alpha(backgroundColor) != 0) {
            fill(backgroundColor);
            rect(x, y, width, height);
        }

        fill(fontColor);
        textSize(fontSize);
        textLeading(lineSpacing);
        
        if(!wordwrap) {
            textAligned(getTruncatedLine(str));
            return;
        }

        // wrap text.
        // Note: We always print at least 1 symbol even if it overflows
        float yOffset = 0;
        float xOffset = 0;
        float yStride = fontSize + lineSpacing;
        
        float maxWidth = width - (paddingLeft + paddingRight);
        float maxHeight = height - (paddingTop + paddingBottom);
        float maxYOffset = maxHeight - yStride;

        int strIndex = 0;
        int strLength = str.length();
        while(strIndex < strLength) {

            String remainingStr = str.substring(strIndex);

            // Truncate last line if we run out of height
            float nextYOffset = yOffset + yStride; 
            if(nextYOffset > maxYOffset) {
                textAligned(getTruncatedLine(remainingStr), xOffset, yOffset);
                break;
            }
            
            // Wrap lines
            String line = getSubstr(remainingStr, maxWidth);
            int lineLength = line.length();
            if(lineLength > 0) {

                textAligned(line, xOffset, yOffset);
                strIndex+= lineLength;

            } else  {

                // Failed to fit even a single char 
                textAligned(truncatedSymbol, xOffset, yOffset);
                strIndex++;
            }

            yOffset+= yStride;
        }
    }
}