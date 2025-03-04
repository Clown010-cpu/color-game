import processing.sound.*;

SoundFile music, successSound, failureSound;

color lightBlue = #ADD8E6; 
color white = #FFFFFF;     
color green = #3EF702;    
color red = #FF0307;       


String[] words = {"RED", "BLUE", "GREEN", "YELLOW", "BLACK", "PURPLE", "ORANGE"};
color[] colors = {#FF0307, #0365FF, #3EF702, #FBFF1A, #0A0A0A, #800080, #FFA500};

String currentWord;
color currentColor;
color textColor; 

boolean isMatch; 

int score = 0;
int timer = 30;
int lastTime;

String currentMode = "intro";

void setup() {
  size(800, 600);
  textAlign(CENTER, CENTER);
  textSize(32);
  

  music = new SoundFile(this, sketchPath("MUSIC.mp3"));
  successSound = new SoundFile(this, sketchPath("SUCCESS.wav"));
  failureSound = new SoundFile(this, sketchPath("FAILURE.wav"));

  music.loop();
  generateNewQuestion();
}

void draw() {
  if (currentMode.equals("intro")) {
    showIntro();
  } else if (currentMode.equals("game")) {
    showGame();
  } else if (currentMode.equals("gameOver")) {
    showGameOver();
  }
}

void showIntro() {
  background(lightBlue);
  fill(red);
  textSize(48);
  text("Welcome to the Colour Game!", width / 2, height / 3);
  textSize(24);
  fill(white);
  text("Click anywhere to start", width / 2, height / 2);

  if (mousePressed) {
    currentMode = "game";
    lastTime = millis();
  }
}

void showGame() {
  int elapsedTime = (millis() - lastTime) / 1000;
  timer = max(0, 30 - elapsedTime); 

  background(white);
  
 
  fill(lightBlue);
  rect(0, 0, width / 2, height);  
  fill(white);
  rect(width / 2, 0, width / 2, height);  

 
  fill(textColor);
  textSize(64);
  text(currentWord, width / 2, height / 3);


  fill(green);
  textSize(36);
  text("MATCH", width / 4, height - 50);

 
  fill(red);
  textSize(36);
  text("NOT MATCH", width * 3 / 4, height - 50);


  fill(#050505);
  textSize(24);
  text("Score: " + score, width / 2, 50);
  text("Time: " + timer, width - 100, 50);

  if (timer == 0) {
    currentMode = "gameOver";
    music.stop();
  }
}

void showGameOver() {
  background(lightBlue);
  fill(red);
  textSize(48);
  text("Game Over!", width / 2, height / 3);
  textSize(32);
  fill(white);
  text("Final Score: " + score, width / 2, height / 2);
  textSize(24);
  text("Click anywhere to restart", width / 2, height * 2 / 3);

  if (mousePressed) {
    resetGame();
  }
}

void generateNewQuestion() {
  int wordIndex = int(random(words.length));
  currentWord = words[wordIndex];


  boolean forceMatch = random(1) < 0.6;
  if (forceMatch) {
    currentColor = colors[wordIndex];  
    isMatch = true;
  } else {
    int colorIndex;
    do {
      colorIndex = int(random(colors.length));
    } while (colorIndex == wordIndex);  
    currentColor = colors[colorIndex];
    isMatch = false;
  }


  if (currentColor == white || currentColor == lightBlue || currentColor == #FBFF1A) {
    textColor = #0A0A0A; 
  } else {
    textColor = currentColor;
  }
}

void mousePressed() {
  if (currentMode.equals("intro") || currentMode.equals("gameOver")) {
    currentMode = "game";
    resetGame();
  } else if (currentMode.equals("game")) {
    checkAnswer();
  }
}

void checkAnswer() {
  boolean clickedMatch = (mouseX < width / 2);
  boolean clickedNotMatch = (mouseX >= width / 2);

  if ((clickedMatch && isMatch) || (clickedNotMatch && !isMatch)) {
    score += 10;
    playSuccess();
  } else {
    playFailure();
  }
  generateNewQuestion();
}

void resetGame() {
  score = 0;
  timer = 30;
  lastTime = millis();
  music.loop();
  generateNewQuestion();
}

void playSuccess() {
  successSound.play();
}

void playFailure() {
  failureSound.play();
}
