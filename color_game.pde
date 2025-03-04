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
int roundTime = 3;  // ⏳ Each question lasts 3 seconds
int timerStart;

float circleSize;  // Used for timer visualization

String currentMode = "intro";

void setup() {
  size(800, 600);
  textAlign(CENTER, CENTER);
  textSize(32);
  
  // 🎵 Load Sounds
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
    timerStart = millis();
  }
}

void showGame() {
  background(white);
  
  fill(lightBlue);
  rect(0, 0, width / 2, height);  
  fill(white);
  rect(width / 2, 0, width / 2, height);  

  // 🎨 Display Word
  fill(textColor);
  textSize(64);
  text(currentWord, width / 2, height / 3);

  // 🟢 "MATCH" Label
  fill(green);
  textSize(36);
  text("MATCH", width / 4, height - 50);

  // 🔴 "NOT MATCH" Label
  fill(red);
  textSize(36);
  text("NOT MATCH", width * 3 / 4, height - 50);

  // ⏳ Timer Visualization (Expanding Circle)
  float elapsedTime = (millis() - timerStart) / 1000.0;
  float remainingTime = max(0, roundTime - elapsedTime);
  circleSize = map(remainingTime, 0, roundTime, 200, 0);

  fill(red, 150);
  noStroke();
  ellipse(width / 2, height / 2, circleSize, circleSize);

  // 🏆 Score & Timer
  fill(#050505);
  textSize(24);
  text("Score: " + score, width / 2, 50);

  if (remainingTime <= 0) {
    generateNewQuestion();  // Move to next round if time runs out
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

  // 🎯 True 50/50 Chance for Match & Not Match
  boolean forceMatch = random(1) < 0.5;
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

  // ✅ Fix visibility: Light colors use black text
  if (currentColor == white || currentColor == lightBlue || currentColor == #FBFF1A) {
    textColor = #0A0A0A;
  } else {
    textColor = currentColor;
  }

  // 🔄 Restart Timer & Animation
  timerStart = millis();
  circleSize = 200;
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
  timerStart = millis();
  music.loop();
  generateNewQuestion();
}

void playSuccess() {
  successSound.play();
}

void playFailure() {
  failureSound.play();
}
