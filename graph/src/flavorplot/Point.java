package flavorplot;

public class Point {
    public float x, y;
    public Point(float x, float y){ this.x = x; this.y = y; }
    public Point scaledTo(Point p){ return new Point(x*p.x, y*p.y); }
    public float distanceTo(Point p){
        return (float) Math.sqrt(sq(x-p.x) + sq(y-p.y));
    }
    public String toString(){
        return "(" + x + ", " + y + ")";
    }
        
    private float sq(float k){ return k*k; }
}