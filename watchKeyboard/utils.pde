
float clamp(float value, float min, float max) {
    if(value > min) return Math.min(max, value);
    return min;
}