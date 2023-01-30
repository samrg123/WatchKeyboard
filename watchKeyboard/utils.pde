import android.os.Vibrator;
import android.content.Context;

// TODO: Add Color Enum

enum UnicodeSymbol {
    OpenBox("\u2423"),
    Ellipses("\u2026"),
    LeftArrow("\u2190"),
    VerticalBar("\u007C");
    
    private final String kStr; 

    private UnicodeSymbol(String str) {
        kStr = str;
    }

    public String getString() {
        return kStr;
    }
} 

float clamp(float value, float min, float max) {
    if(value > min) return Math.min(max, value);
    return min;
}

float midpoint(float x1, float x2) {
    return .5*(x2-x1) + x1;
}

float distance(float x1, float y1, float x2, float y2) {
    return sqrt(sq(x2-x1) + sq(y2-y1));
}

void vibrate(int time) {
    Vibrator vibrer = (Vibrator)kActivity.getSystemService(Context.VIBRATOR_SERVICE);
    vibrer.vibrate(time);
}

double sigmoid(double x) {
    return 1 / (1 + Math.exp(-x));
}
