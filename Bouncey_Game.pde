int gameScreen = 0;
float ballX, ballY;
int ballSize = 20;
int ballColor = color(65, 68, 135);
int racketBounceRate = 20;
int wallSpeed = 5;
int wallInterval = 1000;
int minGapHeight = 200;
int maxGapHeight = 300;
int wallWidth = 80;
float gravity = 1;
float ballSpeedVert = 0;
float airFriction = 0.0001;
float friction = 0.1;
color racketColor = color(46, 48, 92);
color wallColors = color(0);
float racketWidth = 100;
float racketHeight = 10;
float ballSpeedHorizon = 10;
float lastAddTime = 0;
int maxHealth = 100;
float health = 100;
float healthDecrease = 1;
int healthBarWidth = 60;
int score = 0;
int maxScore = -1;
String topscore;

ArrayList<int[]> walls = new ArrayList<int[]>();

void setup() {
  size(500, 500);
  ballX = width/4;
  ballY = height/5;
  String[] list;
  
  if (loadStrings("highscore.txt") == null){
    topscore=str(maxScore);
    list = split(topscore, ' ');
    saveStrings("highscore.txt", list);
  }
  else{
    topscore = loadStrings("highscore.txt")[0];
    maxScore = Integer.parseInt(loadStrings("highscore.txt")[0]);
    list = split(topscore, ' ');
  }
}

void draw(){
  if (gameScreen == 0){
    initGameScreen();
  }
  else if (gameScreen == 1){
    gameScreen();
    applyGravity();
    keepInScreen();
    applyHorizontalSpeed();
  }
  else if (gameScreen == 2){
    gameOverScreen();
  }
}

void initGameScreen(){
  background(46, 48, 92);
  textAlign(CENTER);
  textSize(40);
  text("Click to Start!", height /2, width /2);
}
void gameScreen(){
  background(255);
  wallHandler();
  drawBall();
  drawRacket();
  watchRacketBounce();
  wallAdder();
  drawHealthBar();
}

void gameOverScreen() {
  if (score > maxScore){
    maxScore = score;
    topscore=str(maxScore);
    String[] list = split(topscore, ' ');
    saveStrings("highscore.txt", list);
  }
  background(46, 48, 92);
  textAlign(CENTER);
  fill(255);
  textSize(40);
  text("Game Over", height/2, width/2 - 20);
  textSize(15);
  text("Click to Restart", height/2, width/2 + 10);
  textSize(20);
  text("Score: "+ score, height/2, width/2 + 40);
  textSize(15);
  text("Max Score: "+ topscore, height/2, width/2 + 70);
}

void drawBall(){
  fill(ballColor);
  ellipse(ballX,ballY,ballSize,ballSize);
}

public void mousePressed(){
  if (gameScreen == 0){
    startGame();
  }
  if (gameScreen==2){
    restart();
  }
}

void startGame(){
  gameScreen = 1;
}

void applyGravity(){
  ballSpeedVert += gravity;
  ballY+= ballSpeedVert;
  ballSpeedVert -= (ballSpeedVert * airFriction);
}

void makeBounceBottom(float surface){
  ballY = surface - (ballSize/2);
  ballSpeedVert*=-1;
  ballSpeedVert -= (ballSpeedVert * friction);
}
void makeBounceTop(float surface){
  ballY = surface + (ballSize/2);
  ballSpeedVert*=-1;
  ballSpeedVert -= (ballSpeedVert * friction);
}

void keepInScreen(){
  if (ballY+(ballSize/2) > height){
    makeBounceBottom(height);
  }
  if (ballY-(ballSize/2) < 0){
    makeBounceTop(0);
  }
  if(ballX-(ballSize/2) < 0){
    makeBounceLeft(0);
  }
  if(ballX+(ballSize/2) > width){
    makeBounceRight(width);
  }
}

void drawRacket(){
  fill(racketColor);
  rectMode(CENTER);
  rect(mouseX, mouseY, racketWidth, racketHeight);
}

void watchRacketBounce(){
  float overhead = mouseY - pmouseY;
  if ((ballX+(ballSize/2) > mouseX-(racketWidth/2)) && (ballX-(ballSize/2) < mouseX+(racketWidth/2))){
    if (dist(ballX,ballY,ballX,mouseY) <= (ballSize/2)+abs(overhead)){
      makeBounceBottom(mouseY);
      if (overhead < 0){
        ballY+= overhead;
        ballSpeedVert+=overhead;
      }
    }
  }
  if ((ballX+(ballSize/2) > mouseX-(racketWidth/2)) && (ballX-(ballSize/2) < mouseX+(racketWidth/2))){
    if (dist(ballX, ballY, ballX, mouseY)<=(ballSize/2)+abs(overhead)){
      ballSpeedHorizon = (ballX - mouseX)/5;
    }
  }
}

void applyHorizontalSpeed(){
  ballX+=ballSpeedHorizon;
  ballSpeedHorizon -= (ballSpeedHorizon*airFriction);
}
void makeBounceLeft(float surface){
  ballX = surface +(ballSize/2);
  ballSpeedHorizon *= -1;
  ballSpeedHorizon -= (ballSpeedHorizon*friction);
}
void makeBounceRight(float surface){
  ballX = surface -(ballSize/2);
  ballSpeedHorizon *= -1;
  ballSpeedHorizon -= (ballSpeedHorizon*friction);
}
    
void wallAdder() {
  if (millis()-lastAddTime > wallInterval) {
    int randHeight = round(random(minGapHeight, maxGapHeight));
    int randY = round(random(0, height-randHeight));
    // {gapWallX, gapWallY, gapWallWidth, gapWallHeight}
    int[] randWall = {width, randY, wallWidth, randHeight, 0}; 
    walls.add(randWall);
    lastAddTime = millis();
  }
}
void wallHandler() {
  for (int i = 0; i < walls.size(); i++) {
    wallRemover(i);
    wallMover(i);
    wallDrawer(i);
    watchWallCollision(i);
  }
}
void wallDrawer(int index) {
  int[] wall = walls.get(index);
  // get gap wall settings 
  int gapWallX = wall[0];
  int gapWallY = wall[1];
  int gapWallWidth = wall[2];
  int gapWallHeight = wall[3];
  // draw actual walls
  rectMode(CORNER);
  fill(wallColors);
  rect(gapWallX, 0, gapWallWidth, gapWallY);
  rect(gapWallX, gapWallY+gapWallHeight, gapWallWidth, height-(gapWallY+gapWallHeight));
}
void wallMover(int index) {
  int[] wall = walls.get(index);
  wall[0] -= wallSpeed;
}
void wallRemover(int index) {
  int[] wall = walls.get(index);
  if (wall[0]+wall[2] <= 0) {
    walls.remove(index);
  }
}

void watchWallCollision(int index) {
  int[] wall = walls.get(index);
  // get gap wall settings 
  int gapWallX = wall[0];
  int gapWallY = wall[1];
  int gapWallWidth = wall[2];
  int gapWallHeight = wall[3];
  int wallScored = wall[4];
  int wallTopX = gapWallX;
  int wallTopY = 0;
  int wallTopWidth = gapWallWidth;
  int wallTopHeight = gapWallY;
  int wallBottomX = gapWallX;
  int wallBottomY = gapWallY+gapWallHeight;
  int wallBottomWidth = gapWallWidth;
  int wallBottomHeight = height-(gapWallY+gapWallHeight);if (ballX > gapWallX+(gapWallWidth/2) && wallScored==0) {
    wallScored=1;
    wall[4]=1;
    score();
  }

  if (
    (ballX+(ballSize/2)>wallTopX) &&
    (ballX-(ballSize/2)<wallTopX+wallTopWidth) &&
    (ballY+(ballSize/2)>wallTopY) &&
    (ballY-(ballSize/2)<wallTopY+wallTopHeight)
    ) {
      decreaseHealth();
  }
  
  if (
    (ballX+(ballSize/2)>wallBottomX) &&
    (ballX-(ballSize/2)<wallBottomX+wallBottomWidth) &&
    (ballY+(ballSize/2)>wallBottomY) &&
    (ballY-(ballSize/2)<wallBottomY+wallBottomHeight)
    ) {
      decreaseHealth();
  }
}

void score(){
  score++;
}

void restart() {
  score = 0;
  ballSpeedHorizon = 10;
  health = maxHealth;
  ballX=width/4;
  ballY=height/5;
  lastAddTime = 0;
  walls.clear();
  gameScreen = 1;
  
}

void printScore(){
  textAlign(CENTER);
  fill(0);
  textSize(30); 
  text(score, height/2, 50);
}

void drawHealthBar() {
  // Make it borderless:
  noStroke();
  fill(236, 240, 241);
  rectMode(CORNER);
  rect(ballX-(healthBarWidth/2), ballY - 30, healthBarWidth, 5);
  if (health > 60) {
    fill(46, 204, 113);
  } else if (health > 30) {
    fill(230, 126, 34);
  } else {
    fill(231, 76, 60);
  }
  rectMode(CORNER);
  rect(ballX-(healthBarWidth/2), ballY - 30, healthBarWidth*(health/maxHealth), 5);
}
void decreaseHealth(){
  health -= healthDecrease;
  if (health <= 0){
    gameScreen = 2;
  }
}
