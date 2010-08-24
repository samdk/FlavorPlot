package flavorplot;

import java.util.*;

public class ForceLayoutEngine {
    private Ingredient[] ingredients;
    private Map<String, Map<String, Float>> map;

	private float damping, theta;
	
	public ForceLayoutEngine(Ingredient[] ingredients, Map<String, Map<String, Float>> map){
	    this.ingredients = ingredients;
	    this.map         = map;
	    this.damping     = 100000f;
	    this.theta       = (float) (100*Math.sqrt(ingredients.length));
	}
	
	public Ingredient[] getIngredients() { return this.ingredients; }
	public void setIngredients(Ingredient[] ingredients) { this.ingredients = ingredients; }
	public Map<String, Map<String, Float>> getMap() { return this.map; }
	public void setMap(Map<String, Map<String, Float>> map) { this.map = map; }
	
	public void tick(){	    
	    for(int j = 0; j < ingredients.length-1; j++){
            for(int k = j+1; k < ingredients.length; k++){
                applyForces(ingredients[j], ingredients[k]);
            }
	    }
	    for(Ingredient i : ingredients){
	        i.position.tick();
	        i.position.xv *= 0.999;
	        i.position.yv *= 0.999;
	    }
	    
	    this.damping *= 1.001;
	}
	
	private float strength(Ingredient a, Ingredient b){
	    if(map.get(a.name).containsKey(b.name))
	        return map.get(a.name).get(b.name);
	    return 0f;
	}
	private void applyForces(Ingredient a, Ingredient b){
	    float d = a.position.distanceTo(b.position);
	    if(d < 0.01) d = 0.01f;
	    float dx = a.position.x - b.position.x, dy = a.position.y - b.position.y;
	    float repulsiveForce = 0.01f/(d*d*d), attractiveForce = theta*strength(a,b)*d;
	    float diff = (repulsiveForce - attractiveForce) / damping;
	    a.position.xv += diff*dx; a.position.yv += diff*dy;
	    b.position.xv -= diff*dx; b.position.yv -= diff*dy;
	}
}