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
QLearning QAgent;
int NGHOSTS = 2;
ArrayList<Ghost> ghosts = new ArrayList<Ghost>(NGHOSTS);
int ntrials;
float last_trial_reward;
int EAST = 0, SOUTH = 1, WEST = 2, NORTH = 3;
int w = 50;
boolean showQ = false;
boolean random_move = false;
boolean rLearningMode = false;
int deaths = 0;
int oldX, oldY;

void setup(){
  map = new Map(w);
  pacman = new PacMan(9, 8, w);
  setup_bots();
  QAgent = new QLearning();
  size(1400, 900);
  for(Ghost g: ghosts){  
    g.attack();
  }  
}

void setup_bots(){
  int[] ghost_xs = {1, 6, 12};
  int[] ghost_ys = {1, 1, 1};
  for(int i = 0; i < NGHOSTS; i++){
    Ghost g = new Ghost(i, ghost_xs[i], ghost_ys[i], 20, w);
    ghosts.add(g);
  }
  
  /*
  Ghost g = new Ghost(0, ghost_xs[0], ghost_ys[0], 20, 25);
  ghosts.add(g);
  Ghost g1 = new Ghost(1, ghost_xs[1], ghost_ys[1], 20, 25);
  ghosts.add(g1);
  Ghost g2 = new Ghost(1, ghost_xs[2], ghost_ys[2], 20, 25);
  ghosts.add(g2);
  */
}

void draw(){
  background(0);
  stroke(0);
  map.display();
  pacman.display(); 
  for(Ghost g: ghosts){  
    g.display();
  }  
  //if(frameCount%25==0){
  if(rLearningMode == false){
    step_game();
    
    pacman.find_path();
  }
  else{
    step_game();
    QAgent.step();
  }
  display_info();
}

void nextTrial(){
  deaths++;
  last_trial_reward = QAgent.summed_reward;
  QAgent.home();
  pacman.reset();
  for(Ghost g: ghosts){  
    g.reset();
  }  
}

void next_move(){
    pacman.find_path();
    step_game();  
}

void step_game(){
  for(Ghost g: ghosts){  
    g.attack();
  }  
  //move_randomly();
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

void display_info(){
  text("Score: " + pacman.score, 0, 800);
  if(rLearningMode == true)
    text("Reinforcement Learning Mode On", 0, 780);
  else
    text("Reinforcement Learning Mode Off", 0, 780);
  text("Deaths: " + deaths, 250, 780);
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
  } else if (key == 's') {
    step_game();
  } else if (key == 'l') {
    if(rLearningMode == false){
      map.level_one = map.level_zero_copy_RL;
      oldX = pacman.x;
      oldY = pacman.y;
      pacman.x = QAgent.ix;
      pacman.y = QAgent.iy;
    }
    else{
      map.level_one = map.level_zero;
      pacman.x = oldX;
      pacman.y = oldY;
    }
    rLearningMode = !rLearningMode;
  } else if (key == 'q') {
    showQ = !showQ;
  }
}
