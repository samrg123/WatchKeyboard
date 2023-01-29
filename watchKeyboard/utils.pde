
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

public void vibrate(int time) {
    Vibrator vibrer = (Vibrator)act.getSystemService(Context.VIBRATOR_SERVICE);
    vibrer.vibrate(time);
}
