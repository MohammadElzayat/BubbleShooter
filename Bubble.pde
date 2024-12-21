public class Bubble {
  color col;
  Bubble[] adjacents = new Bubble[6];
  float xcor, ycor;
  final static float BRADIUS = 30;
  float explodeRadius = BRADIUS;
  boolean marked = false;
  
  public Bubble(float x, float y, color colla) {
    xcor = x;
    ycor = y;
    col = colla;
  }
  
  public void evaluateAdjacents(ArrayList<Bubble> bubbles) {
    for (int i = 0; i < bubbles.size(); i++) {
      Bubble b = bubbles.get(i);
      
      
      
      if (b.ycor == ycor - BRADIUS && b.xcor == xcor + BRADIUS/2) {
        if (b.col == col) {
          adjacents[0] = b;
        } else {
           adjacents[0] = null;
        }
        
      }
      
      if (b.ycor == ycor - BRADIUS && b.xcor == xcor - BRADIUS/2) {
        if (b.col == col) {
          adjacents[1] = b;
        } else {
           adjacents[1] = null;
        }
        
      }
        
        if (b.ycor == ycor + BRADIUS && b.xcor == xcor + BRADIUS/2) {
        if (b.col == col) {
          adjacents[2] = b;
        } else {
           adjacents[2] = null;
        }
        
        }
        
        if (b.ycor == ycor + BRADIUS && b.xcor == xcor - BRADIUS/2) {
        if (b.col == col) {
          adjacents[3] = b;
        } else {
           adjacents[3] = null;
        }
        
        }
        
        if (b.xcor == xcor - BRADIUS && b.ycor == ycor) {
        if (b.col == col) {
          adjacents[4] = b;
        } else {
           adjacents[4] = null;
        }
        
        }
        
        if (b.xcor == xcor + BRADIUS && b.ycor == ycor) {
        if (b.col == col) {
          adjacents[5] = b;
        } else {
           adjacents[5] = null;
        }
        
        }
        
    
    }
    // loop through adjacent bubbles and add them to the array if they are the same color
  }
  
  public int evaluateCollision(ArrayList<Bubble> allBubbles) {
    ArrayList popList = new ArrayList<Bubble>();
    colHelp(col, popList);
    if (popList.size() < 3) return 0;
    for (int i = 0; i < allBubbles.size(); i++) {
      if (popList.contains(allBubbles.get(i))) {
        allBubbles.get(i).explode();
        allBubbles.remove(i);
        i--;
      }
    }
    return popList.size();
  }
  
  public void colHelp(color seek, ArrayList<Bubble> popList) {
    if (marked) return;
    popList.add(this);
    marked = true;
    for (int i = 0; i < adjacents.length; i++) {
      if (adjacents[i] != null) {
        adjacents[i].colHelp(seek, popList);
      }
    }
  }
 
  
  public void snapToGrid() {
    float yR = ycor/BRADIUS;
    int roundedY = round(yR);
    ycor = BRADIUS * roundedY;
    
    boolean checkForShift =  ((ycor - theGame.STARTING_Y) / BRADIUS) % 2 == 0;
    
    float p = 0.0;
    if (theGame.hexShift == checkForShift) p = BRADIUS/2;
    
    float xR = (xcor-p)/BRADIUS;
    
    int roundedX = round(xR);
    
    xcor = BRADIUS * roundedX+p;
    
    // to be written
  }
  
  public void explode() {
    for (int i = 0; i < 50; i++) {
      explodeRadius *= 1.01;
      this.display();
    }
  }
  
  public void display() {
    fill(col);
    strokeWeight(1);
    ellipse(xcor, ycor, explodeRadius, explodeRadius);
    fill(255);
    strokeWeight(0);
    ellipse(xcor-(explodeRadius/4), ycor-(explodeRadius/4), (explodeRadius/5), (explodeRadius/5));
  }
}
