package flavorplot;

import java.util.*;

public class ForceLayoutEngine implements Positionable{
    private String[] names;
    private Map<String, Map<String, Float>> map;
    private Map<String, Point> positions, velocities;

    private static Random gen = new Random();

	private float damping, theta;
	
	public ForceLayoutEngine(Map<String, Map<String, Float>> map){
	    this.map         = map;
	    this.damping     = 1000f;
	    this.theta       = (float) (100000*Math.sqrt(map.size()));
	    this.names       = map.keySet().toArray(new String[]{});
	    this.positions   = randomizedPositions(map);
	    this.velocities  = new HashMap<String, Point>();
	    for(String s : names)
	        this.velocities.put(s, new Point(0f,0f));
	}
	

	public Map<String, Map<String, Float>> getMap() { return this.map; }
	public void setMap(Map<String, Map<String, Float>> map) { this.map = map; }
	public Map<String, Point> getPositions() { return this.positions; }
	public void setPositions(Map<String, Point> positions) { this.positions = positions; }
	
	public void tick(){	    
	    for(int j = 0; j < names.length-1; j++){
            for(int k = j+1; k < names.length; k++){
                applyForces(names[j], names[k]);
            }
	    }
	    for(String i : names){
	        positions.get(i).x = bound(positions.get(i).x + velocities.get(i).x);
	        positions.get(i).y = bound(positions.get(i).y + velocities.get(i).y);

	        //i.position.xv *= 0.999;
	        //i.position.yv *= 0.999;
	    }
	    
	    this.damping *= 1.00001;
	}
	
    public float strength(String a, String b){
        if(map.containsKey(a) && map.get(a) != null && map.get(a).containsKey(b))
            return map.get(a).get(b);
        return 0f;
    }
    
	private void applyForces(String a, String b){
        float d = positions.get(a).distanceTo(positions.get(b)),
              dx = positions.get(a).x - positions.get(b).x,
              dy = positions.get(a).y - positions.get(b).y;
        
	    if(d < 0.01) d = 0.01f;
	    float repulsiveForce  = 0.1f/(d*d),
	          attractiveForce = theta*strength(a,b)*d;
	    
	    float diff = (repulsiveForce - attractiveForce) / damping;
	    velocities.get(a).x = diff * dx; 
	    velocities.get(a).y = diff * dy; 
	    velocities.get(b).x = -diff * dx; 
	    velocities.get(b).y = -diff * dy; 
	}
	
	public Map<String, Point> randomizedPositions(Map<String, Map<String, Float>> map){
	    Map<String, Point> positions = new HashMap<String, Point>();
	    for(String s : map.keySet())
	        positions.put(s, new Point(gen.nextFloat(), gen.nextFloat()));
	    return positions;
	}
	private float bound(float x){
	    if(x < 0) return 0f;
	    if(x > 1) return 1f;
	    return x;
	}
}