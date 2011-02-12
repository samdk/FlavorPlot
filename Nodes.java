import java.io.*;
import java.util.*;
import java.net.*;

public class Nodes {
    private final static HashMap<String, INode> ingredients = new HashMap<String, INode>();
    private final static Recipe[] recipes = new Recipe[45307];
    
    static class Recipe extends LinkedList<INode> { }
    
    static class INode {
        LinkedList<Recipe> neighbors;
        String name;
        
        public INode(String n){
            name = n;
            neighbors = new LinkedList<Recipe>();
        }
    }
    
    private static String fan(String[] names){
        StringBuilder out = new StringBuilder();
        
        HashSet<Recipe> seen = new HashSet<Recipe>();
        
        for(String name : names){
            try { 
                INode node = ingredients.get(name);
                for(Recipe r : node.neighbors){
                    if(!seen.contains(r)){
                        seen.add(r);
                
                        for(INode i : r){
                            if(!(i.name.equals("butter")
                              || i.name.equals("water")
                              || i.name.equals("white sugar")
                              || i.name.equals("flour")
                              || i.name.equals("salt")))
                              
                            out.append(i.name + ",");
                        }
                
                        out.append("\t");
                    }
                }
            }catch(Exception e){}
        }
            
        
        return out.toString();
    }
    
    private static void populate() throws Exception{
        Scanner s = new Scanner(new File("round1.csv"));
        while(s.hasNextLine()){
            String[] parts = s.nextLine().split(",");
           
            int i = Integer.parseInt(parts[0]) - 1;
            String name = parts[1];
            
            if(!ingredients.containsKey(name))
                ingredients.put(name, new INode(name));
                
            INode ingr = ingredients.get(name);
            
            if(recipes[i] == null)
                recipes[i] = new Recipe();
            recipes[i].add(ingr);
            
            ingr.neighbors.add(recipes[i]);
        }
    }
    
    public static void main(String[] args) throws Exception{
        populate();
        
        ServerSocket server = new ServerSocket(9929);

        PrintWriter out = null;
        BufferedReader in = null;
        
        while(true){
            Socket client = server.accept();
            String line = null;
            
            out = new PrintWriter(client.getOutputStream(), true);
            in = new BufferedReader(new InputStreamReader(client.getInputStream()));
            
            try{
                while((line = in.readLine()) == null) Thread.sleep(25);
                out.println(fan(line.split("\t")));
                out.flush();
            } catch(Exception e) { System.out.println(e); }
        }
    }
}