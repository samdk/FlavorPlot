import java.util.*;
import java.io.*;
import flavorplot.*;

import au.com.bytecode.opencsv.CSVReader;

public class Runner {
    public static void main(String[] args) throws Exception{
        CSVReader csv = new CSVReader(new FileReader("/Users/eli/repos/flavorplot/data/out/allrecipes.csv"));
        Random r = new Random();
        
        String[] line;
        Map<String, Map<String, Float>> map = new HashMap<String, Map<String, Float>>();
        while((line = csv.readNext()) != null){
            if(map.size() < 20){
                if(!map.containsKey(line[0])) map.put(line[0], new HashMap<String, Float>());
                if(!map.containsKey(line[1])) map.put(line[1], new HashMap<String, Float>());
                map.get(line[0]).put(line[1], Float.parseFloat(line[2]));
                map.get(line[1]).put(line[0], Float.parseFloat(line[2]));
            }
        }
        
        for(Map.Entry<String, Map<String, Float>> m : map.entrySet()){
            
            int sum = 0;
            for(Map.Entry<String, Float> n : m.getValue().entrySet())
                sum += n.getValue();
            
            for(Map.Entry<String, Float> n : m.getValue().entrySet()){
                int sum2 = 0;
                if(map.containsKey(n))
                    for(Map.Entry<String, Float> k : map.get(n).entrySet())
                        sum2 += k.getValue();
                m.getValue().put(n.getKey(), n.getValue()/(sum + sum2));
                System.out.println(m.getKey() + " -> " + n.getKey() + " = " + n.getValue());
            }
        }
   
        GaOptimizer ga = new GaOptimizer(map, 500);
        GraphViewer gv = new GraphViewer(ga);
        
        for(int i = 0; i < 1000000; i++){
            ga.run(10000);
            System.out.println(ga.getBest().getFitness());
            gv.repaint();
        }
    }
}