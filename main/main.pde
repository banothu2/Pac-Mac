/*
  Project: Pac-Man 
    Building a Pac-Man playing bot using reinforced learning.
    
  Authors:
    Kirthi Banothu
    Edgar Basto
    Michael 
    
  size: 28 tiles wide x 31 tiles high
    
*/

Map map;
//Ghost blinky; 
PacMan pacman;
boolean random_move = false;
void setup(){
  map = new Map();
  pacman = new PacMan();
  //blinky = new Ghost(1);
  size(700, 900);
}

void draw(){
  background(0);
  map.display();
  pacman.display(); 
  //blinky.display();
  
  move_randomly();
  
  
  fill(255);
  text("Score: " + pacman.movement_direction, 0, 800);
}

void move_randomly(){
  if(random_move){
    int x_dir = int(random(-2, 2));
    int y_dir = int(random(-2, 2));
    if(x_dir == 0 || y_dir == 0){
      pacman.update(x_dir, y_dir); 
    } 
    
//    x_dir = int(random(-2, 2));
//    y_dir = int(random(-2, 2));
//    if(x_dir == 0 || y_dir == 0){
//      blinky.update(x_dir, y_dir); 
//    } 
  }
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      pacman.update(0, -1);
    } else if (keyCode == DOWN) {
      pacman.update(0, 1);
    } else if (keyCode == LEFT) {
      pacman.update(-1, 0);
    } else if (keyCode == RIGHT) {
      pacman.update(1, 0);
    } 
  } else if (key == 'p') {
      paused = !paused;
  } else if (key == 'r') {
    random_move = !random_move;
  }
}
