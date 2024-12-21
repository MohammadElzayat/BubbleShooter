import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Collections;

public class Game {
  int score = 0;
  int level = 0; // Added level variable
  ArrayList<Bubble> bubbles = new ArrayList<Bubble>();
  Shooter shooter = new Shooter();
  boolean awaitingAction = true;
  boolean timerMode = false; 
  boolean hexShift = false;
  color[] nextColors = new color[3];
  int newRow = 0;
  boolean showTut; 
  ArrayList<Integer> colors = new ArrayList<Integer>();
  boolean storedMostRecentScore;
  int poppingStreak = 0;

  // Colors
  color red = color(255, 0, 0);
  color pink = color(247, 15, 181);
  color dBlue = color(0, 0, 255);
  color lBlue = color(0, 255, 255);
  color yellow = color(255, 255, 0);
  color green = color(0, 255, 0);
  color[] allColors = {red, pink, dBlue, lBlue, yellow, green};

  final static float STARTING_X = Bubble.BRADIUS / 2;
  final float ENDING_X = STARTING_X + 700;
  final static float STARTING_Y = Bubble.BRADIUS;
  final float ENDING_Y = height - 100;

  final float endX = (STARTING_X + ENDING_X) / 2;
  final float endY = (STARTING_Y + ENDING_Y) / 2 - 50;
  
  public void updateLevel() {
    if (score < 200) {
      level = 0;
     
    } else if (score < 500) {
      level = 1;
       while(x){
      addThreeRows(1);
         x =false;
      }
    } else if (score < 700) {
      level = 2;
        while(y){
      addThreeRows(2);
         y =false;
      }
    } 
    }
  

  public Game() {
    colors.add(red);
    colors.add(pink);
    colors.add(dBlue);
    colors.add(yellow);
    colors.add(lBlue);
    colors.add(green);

    for (int i = 0; i < 3; i++) {
      nextColors[i] = makeRandomColor(true);
    }

    storedMostRecentScore = false;
  }

  

  public color makeRandomColor(boolean initial) {
    if (initial) return allColors[(int) random(0, 6)];

    colors = new ArrayList<Integer>();
    for (int i = 0; i < bubbles.size(); i++) {
      Bubble b = bubbles.get(i);
      if (colors.size() == 0 || !colors.contains(b.col)) {
        colors.add(b.col);
      }
      if (colors.size() == 6) {
        i = bubbles.size();
      }
    }

    int k = (int) random(0, colors.size());
    return colors.get(k);
  }

  public color cycleColors(boolean initial) {
    color c = nextColors[2];
    nextColors[2] = nextColors[1];
    nextColors[1] = nextColors[0];
    nextColors[0] = makeRandomColor(initial);
    return c;
  }
// Assuming you have a method to initialize the nextColors array
public void addThreeRows(int x) {
    for (int i = 0; i < x; i++) {
        newBubbleRow(true);
    }
}

  public void newBubbleRow(boolean initial) {
    for (int i = 0; i < bubbles.size(); i++) {
      Bubble b = bubbles.get(i);
      b.ycor += Bubble.BRADIUS; // Adjust bubble movement for difficulty if needed
    }

    float p = 0.0;
    if (hexShift) p = Bubble.BRADIUS / 2;

    for (float i = p + STARTING_X + Bubble.BRADIUS / 2; i < ENDING_X; i += Bubble.BRADIUS) {
      bubbles.add(new Bubble(i, STARTING_Y + Bubble.BRADIUS, nextColors[2]));
      cycleColors(initial);
    }
    hexShift = !hexShift;
  }

  void start() {
    theGame = new Game();
    a = (theGame.STARTING_X + theGame.ENDING_X) / 2 + 20;
    b = theGame.ENDING_Y - 200;

    for (int i = 0; i < 10; i++) {
      theGame.newBubbleRow(true);
    }
  }

  public boolean gameOver() {
    if (bubbles.size() == 0) return true;
    for (int i = 0; i < bubbles.size(); i++) {
      if (bubbles.get(i).ycor >= ENDING_Y) {
        return true;
      }
    }
    return false;
  }

  public boolean checkCollision(Bubble shot) {
    if (shot.xcor < STARTING_X + Bubble.BRADIUS || shot.xcor > ENDING_X - Bubble.BRADIUS) return true;
    if (shot.ycor < STARTING_Y + Bubble.BRADIUS || shot.ycor > ENDING_Y - Bubble.BRADIUS) return true;
    for (int i = 0; i < bubbles.size(); i++) {
      if (dist(shot.xcor, shot.ycor, bubbles.get(i).xcor, bubbles.get(i).ycor) < Bubble.BRADIUS) {
        return true;
      }
    }
    return false;
  }

  public void addHighScore() {
    if (score == 0) return;
    try {
      File f = new File("highscores.txt");

      FileWriter w = new FileWriter(f, true);
      w.write(score + "\n");
      w.close();
      storedMostRecentScore = true;

    } catch (IOException e) {
      System.out.println("couldn't do the file thing");
    }
  }

  public int[] getHighScores() {
    int[] k = new int[5];

    try {
      File f = new File("highscores.txt");
      Scanner p = new Scanner(f);
      ArrayList<Integer> allscores = new ArrayList<Integer>();

      while (p.hasNextLine()) {
        String q = p.nextLine();
        if (q.length() > 0) {
          allscores.add(Integer.parseInt(q));
        }
      }

      Collections.sort(allscores);
      Collections.reverse(allscores);

      int z = min(5, allscores.size());

      for (int i = 0; i < z; i++) {
        k[i] = allscores.get(i);
      }

    } catch (FileNotFoundException e) {
      return k;
    }

    return k;
  }
}
