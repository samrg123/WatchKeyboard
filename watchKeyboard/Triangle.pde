class Triangle {

    public PVector v1;
    public PVector v2;
    public PVector v3;
    
    public Triangle(float x1, float y1, 
                    float x2, float y2, 
                    float x3, float y3) {

        v1 = new PVector(x1, y1);
        v2 = new PVector(x2, y2);
        v3 = new PVector(x3, y3);
    }

    // Returns two times the signed area of the triangle
    public float signedAreadX2(PVector v1, PVector v2, PVector v3) {

        // Note: This is effectively the determinate of a 3x3 matrix:
        //           |v1 1| 
        //      det( |v2 1| ) = area of parallepid = signedAreadX2 
        //           |v3 1| 
                 
        return ((v1.x - v3.x)*(v2.y - v3.y)) - ((v2.x - v3.x)*(v1.y - v3.y));
    }

    public boolean inBounds(PVector p) {
 
        // Note: This works by splitting the triangle v1,v2,v3
        //       into three smaller sub-triangles that share a common
        //       vertex p = (x,y). If p is inside the triangle,
        //       then all three sub-triangles will have the same normal
        //       direction (IE they'll all be negitive or positve signed areas).
        //       But if p moves outside the tringle the normal direction of 
        //       at least 1 sub-triangle with flip. 

        float a1 = signedAreadX2(p, v1, v2);
        float a2 = signedAreadX2(p, v2, v3);
        float a3 = signedAreadX2(p, v3, v1);
 
        return (a1 > 0 && a2 > 0 && a3 > 0) ||
               (a1 < 0 && a2 < 0 && a3 < 0);        
    }

    public boolean inBounds(float x, float y) {
        return inBounds(new PVector(x, y));
    }

}