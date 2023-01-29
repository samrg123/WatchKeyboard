
import java.util.Vector;
import android.app.Activity;
import android.util.DisplayMetrics;

public Activity kActivity;
public float kDPI;

App app;

void setup() {

    // Init display
    // Note: fullScreen MUST be first line in setup function
    fullScreen();
    orientation(PORTRAIT);

    kActivity = getActivity();
    
    DisplayMetrics displayMetrics = kActivity.getResources().getDisplayMetrics(); 
    kDPI = .5 * (displayMetrics.xdpi + displayMetrics.ydpi);

    app = new App();
}

void draw() {
    app.update();
    app.draw();
}

