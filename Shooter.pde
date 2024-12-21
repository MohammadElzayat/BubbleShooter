public class Shooter {
  float xSpeed = 1.0;
  float ySpeed = 1.0;
  final static float SPEED = 15.0; 
  Bubble shot;
  float aimX, aimY;
  public Shooter() {
  
  }
  
  public void shoot(Bubble bub, float xDest, float yDest) {
    shot = bub;
    aimX = xDest;
    aimY = yDest;
    float k = calculateK();
    xSpeed = SPEED*k*(aimX - shot.xcor);
    ySpeed = SPEED*k*(aimY - shot.ycor);
  }
  
  public float calculateK() {
    float absV = dist(shot.xcor, shot.ycor, aimX, aimY);
    float j = 1/absV;
    return j;
  }
  

}
