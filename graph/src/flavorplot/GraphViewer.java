package flavorplot;

import javax.swing.*;
import java.awt.*;
import java.awt.geom.*;
import java.util.*;

public class GraphViewer extends JFrame {
    protected Visualizer viz;
    public GraphViewer(GaOptimizer ga){
        add(viz = new Visualizer(ga));
        setSize(1000, 850);
        setTitle("Graph Layer-Outer");
        setDefaultCloseOperation(EXIT_ON_CLOSE);
		setVisible(true);
    }
    
    static class Visualizer extends JPanel {
        private GaOptimizer ga;
        
        public Visualizer(GaOptimizer ga){
            this.ga = ga;
        }
        
        public void paintComponent(Graphics g){		
			super.paintComponent(g);
			Graphics2D g2d = (Graphics2D) g;
			g2d.setColor(Color.black);
			
			Chromosome chr = ga.getBest();
			Map<String, Point> positions = chr.getPositions();
			for(Map.Entry<String, Point> e : positions.entrySet()){
			    Point p = e.getValue().scaledTo(new Point(900f, 750f));
			    //System.out.println(i);
			    
			    g2d.setColor(Color.black);
			    g2d.fill(new Ellipse2D.Double(p.x+50, p.y+50, 10, 10));
			    
			    //g2d.drawString(e.getKey(), p.x+50, p.y+50);

			    for(Map.Entry<String, Point> f : positions.entrySet()){
			        if(e.getKey().compareTo(f.getKey()) > 0){
			            if(chr.strength(e.getKey(),f.getKey()) > 0){
			                g2d.setColor(new Color(1-chr.strength(e.getKey(), f.getKey()),
			                                       1-chr.strength(e.getKey(), f.getKey()),
			                                       1-chr.strength(e.getKey(), f.getKey())));
			                Point q = f.getValue().scaledTo(new Point(900f, 750f));
			                g2d.drawLine((int) p.x+55, (int) p.y+55, (int) q.x + 55, (int) q.y + 55);
			            }
			        }
			    }
			}
        }
    }
}