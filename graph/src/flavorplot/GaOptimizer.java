package flavorplot;

import java.util.*;

public class GaOptimizer{
	private static final Random gen = new Random();
	
	private Chromosome[] population;
	private int generation;
	
	public GaOptimizer(Map<String, Map<String, Float>> strengths, int populationSize){
		this.generation = 0;
		this.population = new Chromosome[populationSize];
				
		while(populationSize-->0)
		    population[populationSize] = new Chromosome(strengths);
	    Arrays.sort(population, new Comparator<Chromosome>(){
	       public int compare(Chromosome a, Chromosome b){
	           return a.getFitness() < b.getFitness() ? -1 : 1;
	       } 
	    });
	}
		
	public void run(int generations){
		while(generations-->0){
		    ++generation;
		    population[0] = population[0].mateWith(population[gen.nextInt(population.length)]);
			for(int i = 0; i < population.length-1; i++){
			    if(population[i].getFitness() <= population[i+1].getFitness()) return;
			    Chromosome tmp = population[i];
			    population[i] = population[i+1];
			    population[i+1] = tmp;
			}
		}
	}
	
	public Chromosome[] getPopulation(){ return this.population; }
	public int getPopulationSize(){ return population.length; }
	public int getGeneration(){ return generation; }

	public Chromosome getBest(){
		return population[population.length-1];
	}
}