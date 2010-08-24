package flavorplot;

import java.util.*;

public class Chromosome{
	private static final Random gen = new Random();
	private static final float IDEAL_MAX = 0.3f;
	
	private int generation;
	private float crossoverRate, mutatorChance, fitness;
	private boolean fitnessCached;
	
	private Map<String, Map<String, Float>> map;
	private Map<String, Point> positions;
	
	public Chromosome(Map<String, Map<String, Float>> map){
	    this.fitness        = 0f;
		this.crossoverRate  = gen.nextFloat();
		this.mutatorChance  = 0.2f;
		this.generation     = 1;
		this.map            = map;
		this.fitnessCached  = false;
		this.positions      = randomizedPositions(map);
	}
	
	public Map<String, Point> randomizedPositions(Map<String, Map<String, Float>> map){
	    Map<String, Point> positions = new HashMap<String, Point>();
	    for(String s : map.keySet())
	        positions.put(s, new Point(gen.nextFloat(), gen.nextFloat()));
	    return positions;
	}
	
	public Chromosome(Map<String, Map<String, Float>> map, Map<String, Point> positions){
	    this(map);
	    this.positions = positions;
	}

	public Map<String, Point> getPositions() { return this.positions; }
	public void setPositions(Map<String, Point> positions) { this.positions = positions; }
	
	public float getCrossoverRate(){ return crossoverRate; }
	public float getMutatorChance(){ return mutatorChance; }
			
    public float getFitness(){
        if(fitnessCached) return fitness;
        fitnessCached = true;
        fitness = 0f;
        int crosses = 0, goodLines = 0;
        float idealDistance = 1 / (float)Math.sqrt(map.size());
        float minDistance = idealDistance;
        for(String i : map.keySet())
            for(String j : map.keySet()){
                if(map.get(i).containsKey(j)){
                    float str = strength(i,j);
                    for(String k : map.keySet()){
                        for(String l : map.get(k).keySet())
                            if(i != l && i != k && k.compareTo(l) > 0)
                                if(isIntersecting(positions.get(i), positions.get(j), positions.get(k), positions.get(l)))
                                    crosses++;//fitness -= 1;//str;
                                else if(positions.get(i).distanceTo(positions.get(j)) > minDistance)
                                    goodLines++;//fitness += 1;//str;
                                else{
                                    goodLines++;
                                    crosses++;
                                }
                    }
                }else{
                    fitness += positions.get(i).distanceTo(positions.get(j));
                }
            }
        fitness *= goodLines / (crosses + (float) goodLines);
        return fitness;
    }
    
    public boolean isIntersecting(Point i, Point j, Point k, Point l){
        float c1 = i.x*j.y - i.y*j.x,
              c2 = k.x*l.y - k.y*l.x;
        
        float det = (i.x-j.x) * (k.y-l.y) - (i.y-j.y) * (k.x-l.x);
        if(det == 0) return false;

        float x = (c1*(k.x-l.x) - c2*(i.x-j.x))/det,
              y = (c1*(k.y-l.y) - c2*(i.y-j.y))/det; 
              
        return !((i.x > x && j.x > x) ||
                 (i.x < x && j.x < x) ||
                 (i.y > y && j.y > y) ||
                 (i.y < y && j.y < y) ||
                 (k.x > x && l.x > x) ||
                 (k.x < x && l.x < x) ||
                 (k.y > y && l.y > y) ||
                 (k.y < y && l.y < y));
     }
    
    public float strength(String a, String b){
        if(map.containsKey(a) && map.get(a) != null && map.get(a).containsKey(b))
            return map.get(a).get(b);
        return 0f;
    }
	
	public Chromosome mateWith(Chromosome c){
		double meanCrossover = (c.crossoverRate + crossoverRate)/2.0;
		
		if(gen.nextDouble() <= meanCrossover)
		    return crossWith(c);
		else
		    return mutate();
	}
	
	public Chromosome crossWith(Chromosome c){
	    Map<String, Point> childMap = new HashMap<String, Point>();

	    for(String i : map.keySet())
	        if(gen.nextBoolean())
	            childMap.put(i, positions.get(i));
	        else
	            childMap.put(i, c.positions.get(i));
	    
	    Chromosome child = new Chromosome(map, childMap);
	    child.generation = generation + 1;
	    float meanCrossover = (crossoverRate + c.crossoverRate)/2f;
	    boolean better = child.getFitness() > (getFitness() + c.getFitness())/2;
	    child.crossoverRate = bound(meanCrossover + (better ? 1 : -1) * gen.nextFloat()/Math.sqrt(this.generation));
	    
        return child;
	}
	
	public Chromosome mutate(){
	    Map<String, Point> childMap = new HashMap<String, Point>();

	    for(String i : map.keySet())
	        if(gen.nextFloat() < mutatorChance)
	            childMap.put(i, new Point(gen.nextFloat(),gen.nextFloat()));
	        else
	            childMap.put(i, positions.get(i));
	    
	    Chromosome child = new Chromosome(map, childMap);
	    child.generation = generation + 1;
	    boolean better = child.getFitness() > getFitness();
	    child.crossoverRate = bound(crossoverRate + (better ? 1 : -1) * gen.nextFloat()/Math.sqrt(this.generation));
	    return child;
	}
	
	private float bound(double d){
		if(d <= 0.01) return 0.25f;
		if(d >= 0.99) return 0.75f;
		return (float) d;
	}
	
	private float sq(float x) { return x * x; }
}
