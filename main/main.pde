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
PacMan pacman;
int NGHOSTS = 2;
ArrayList<Ghost> ghosts = new ArrayList<Ghost>(NGHOSTS);

boolean random_move = false;
void setup(){
  map = new Map();
  pacman = new PacMan(9, 8);
  setup_bots();


  size(700, 900);
}

void setup_bots(){
  int[] ghost_xs = {1, 6};
  int[] ghost_ys = {1, 1};
  for(int i = 0; i < NGHOSTS; i++){
    Ghost g = new Ghost(0, ghost_xs[i], ghost_ys[i], 20, 25);
    ghosts.add(g);
  }
}

void draw(){
  background(0);
  stroke(0);
  map.display();
  pacman.display(); 
  pacman.find_path();
  for(Ghost g: ghosts){  
    g.display();
    g.attack();
  }  
  move_randomly();
  
  text("Score: " + pacman.score, 0, 800);
}

void move_randomly(){
  if(random_move){
    int x_dir = int(random(-2, 2));
    int y_dir = int(random(-2, 2));
    if(x_dir == 0 || y_dir == 0){
      pacman.update(x_dir, y_dir); 
    } 
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
