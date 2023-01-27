
float clamp(float value, float min, float max) {
    if(value > min) return Math.min(max, value);
    return min;
}

float midpoint(float x1, float x2) {
    return .5*(x2-x1) + x1;
}