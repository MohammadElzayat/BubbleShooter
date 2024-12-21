// Global Variables
Game theGame;
float a, b; // Coordinates of the base of the shooter
int begin;
int duration = 10;
int time = 10;
boolean gameStarted = false; // Tracks whether the game has started
boolean showHelp = false; // Tracks whether the Help page is displayed
PImage img,bg; // Image for tutorial or background
boolean x =true;
boolean y =true;
void setup() {
  size(1000, 850);
  img = loadImage("Tutorial.png"); // Load optional tutorial image
  bg = loadImage("background.jpg");
  
  theGame = new Game();
}

void draw() {
  if (showHelp) {
    drawHelpPage(); // Show the help page if requested
  } else if (!gameStarted) {
    drawMainPage(); // Show the main menu
  } else {
    playGame(); // Run the game
  }
}

// Main Menu
void drawMainPage() {
  image(bg,0,0);
  bg.resize(1000, 850); // Resize the image to 200x150 pixels

  textAlign(CENTER, CENTER);
  textSize(50);
  text("Welcome to Bubble Shooter", width / 2, height / 2 - 100);

  // Draw Start Game button
  fill(0, 200, 0);
  rect(width / 2 - 100, height / 2, 200, 50, 10); // Rounded rectangle
  fill(255);
  textSize(20);
  text("Start Game", width / 2, height / 2 + 25);

  // Draw Help button
  fill(0, 200, 200);
  rect(width / 2 - 100, height / 2 + 80, 200, 50, 10); // Rounded rectangle
  fill(255);
  textSize(20);
  text("Guidelines", width / 2, height / 2 + 105);
}

// Help Page
void drawHelpPage() {
    image(img,0,0);
    img.resize(1000, 850);

 
// Positioned in the center with padding

  // Draw Close button
  fill(200, 0, 0);
  rect(width - 150, height - 100, 120, 50, 10); // Rounded rectangle
  fill(255);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("Close", width - 90, height - 75);
}

// Game Logic
void playGame() {
  background(155, 190, 240);

  // Draw the game board
  fill(157, 200, 255);
  rect(theGame.STARTING_X, theGame.STARTING_Y, theGame.ENDING_X, theGame.ENDING_Y);

  // Update level dynamically
  theGame.updateLevel();

  // Display score and level in the top-right corner
  fill(255); // White text
  textSize(20);
  textAlign(RIGHT, TOP);
  text("Score: " + theGame.score, width - 10, 10); // Position at top-right corner
  text("Level: " + theGame.level, width - 10, 40); // Position below the score

  // Reset button
  fill(0, 200, 0);
  ellipse(825, 250, 60, 60);
  fill(255);
  textAlign(CENTER);
  text("RESET", 825, 255);

  // Help button during the game
  fill(0, 200, 200);
  ellipse(875, 300, 60, 60);
  fill(255);
  text("HELP", 875, 305);

  // Mode button
  fill(200, 0, 0);
  ellipse(900, 230, 60, 60);
  fill(255);
  text(theGame.timerMode ? "REGULAR" : "TIMER", 900, 235);

  if (theGame.gameOver()) {
    endGame();
  } else {
    for (int i = 0; i < theGame.bubbles.size(); i++) {
      theGame.bubbles.get(i).display();
      theGame.bubbles.get(i).evaluateAdjacents(theGame.bubbles);
      theGame.bubbles.get(i).marked = false;
    }

    strokeWeight(4);
    float bigR = dist(mouseX, mouseY, a, b);
    float littleR = 140.0; // Shooter length adjustment

    float mY = mouseY;
    if (mY > b) {
      mY = b;
    }

    float h = a + (mouseX - a) * (littleR / bigR);
    float k = b + (mY - b) * (littleR / bigR);

    line(a, b, h, k);

    if (theGame.awaitingAction) {
      Bubble base = new Bubble(a, b, theGame.nextColors[2]);
      base.display();
    } else {
      Bubble fired = theGame.shooter.shot;
      fired.display();
      if (!theGame.checkCollision(fired)) {
        fired.xcor += theGame.shooter.xSpeed;
        fired.ycor += theGame.shooter.ySpeed;
      } else {
        fired.snapToGrid();
        theGame.bubbles.add(fired);
        fired.evaluateAdjacents(theGame.bubbles);
        int pts = fired.evaluateCollision(theGame.bubbles);
        if (pts == 0) {
          theGame.newRow++;
          theGame.poppingStreak = 0;
        } else {
          theGame.poppingStreak++;
        }

        if (theGame.poppingStreak == 5) {
          theGame.score += 100 * pts;
          theGame.poppingStreak = 0;
        } else {
          theGame.score += 10 * pts;
        }

        if (theGame.newRow == 10) {
          theGame.newBubbleRow(false);
          theGame.newRow = 0;
        }
        theGame.awaitingAction = true;
      }
    }

    Bubble nextNext = new Bubble(theGame.STARTING_X + 100, theGame.ENDING_Y + 50, theGame.nextColors[0]);
    Bubble next = new Bubble(theGame.STARTING_X + 200, theGame.ENDING_Y + 50, theGame.nextColors[1]);
    nextNext.display();
    next.display();
  }

  if (theGame.showTut) {
    image(img, 500, 375, width / 2 - 50, height / 2);
  }

  if (theGame.timerMode) {
    fill(255, 250, 130);
    if (time > 0) {
      time = duration - (millis() - begin) / 1000;
      text(time, 830, 100);
    } else if (time <= 0) {
      endGame();
    }
  }
}

void place() {
    for (int i = 0; i < 3; i++) {
        theGame.cycleColors(true);
    }
    theGame.bubbles = new ArrayList<Bubble>();
    theGame.storedMostRecentScore = false;
    theGame.score = 0;
    a = (theGame.STARTING_X + theGame.ENDING_X) / 2 + 20;
    b = theGame.ENDING_Y - Bubble.BRADIUS;

    for (int i = 0; i < 10; i++) {
        theGame.newBubbleRow(true);
    }

    if (theGame.timerMode) {
        begin = millis();
        time = 60;
    }
  }

void endGame() {
  theGame.bubbles = new ArrayList<Bubble>();
  theGame.nextColors = new int[3];
  fill(157, 200, 255);
  rect(theGame.STARTING_X, theGame.STARTING_Y, theGame.ENDING_X, theGame.ENDING_Y);
  fill(0);
  textSize(30);
  textAlign(CENTER);
  text("GAME OVER", theGame.endX, theGame.endY);
  if (!theGame.storedMostRecentScore) theGame.addHighScore();
  text("YOU SCORED " + theGame.score, theGame.endX, theGame.endY + 40);
  int[] scores = theGame.getHighScores();
  text("HIGH SCORES:", theGame.endX, theGame.endY + 70);
  for (int i = 0; i < scores.length; i++) {
    int sco = scores[i];
    text(sco, theGame.endX, theGame.endY + 100 + i * 30);
  }
}

void mousePressed() {
  if (showHelp) {
    // Handle Close button on the Help page
    if (mouseX > width - 150 && mouseX < width - 30 && mouseY > height - 100 && mouseY < height - 50) {
      showHelp = false; // Close Help page
    }
  } else if (!gameStarted) {
    // Handle Start Game button
    if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 &&
        mouseY > height / 2 && mouseY < height / 2 + 50) {
      gameStarted = true;
      place();
    }

    // Handle Help button
    if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 &&
        mouseY > height / 2 + 80 && mouseY < height / 2 + 130) {
      showHelp = true; // Show Help page
    }
  } else {
    // Existing game logic for mousePressed
    if (dist(mouseX, mouseY, 825, 250) <= 30) place();
    if (dist(mouseX, mouseY, 875, 300) <= 30) theGame.showTut = true;
    if (theGame.showTut && mouseY > 360 && mouseY < 420) theGame.showTut = false;

    if (theGame.gameOver()) return;

    if (dist(mouseX, mouseY, 900, 230) <= 30) {
      theGame.timerMode = !theGame.timerMode;
      place();
      if (theGame.timerMode) {
        begin = millis();
        time = 60;
        duration = 60;
      }
    }

    if (mouseX < theGame.STARTING_X || mouseX > theGame.ENDING_X || mouseY < theGame.STARTING_Y || mouseY > theGame.ENDING_Y) return;

    if (!theGame.awaitingAction) return;
    if (mouseY < b && mouseY < theGame.ENDING_Y && mouseX < theGame.ENDING_X) {
      theGame.shooter.shoot(new Bubble(a, b, theGame.cycleColors(false)), mouseX, mouseY);
    } else {
      theGame.shooter.shoot(new Bubble(a, b, theGame.cycleColors(false)), mouseX, b);
    }
    theGame.awaitingAction = false;
  }
}
