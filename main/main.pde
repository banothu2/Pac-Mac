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

int EAST = 0, SOUTH = 1, WEST = 2, NORTH = 3;
boolean random_move = false;

int game_mode = -1;
/*
  Game mode values: 
   -1  : No Model 
    0  : Learning Mode 
    1  : Human Mode 
    2  : Vector Mode 
*/

// General game variables
int w = 50;                           // Width of all elements in game
int game_width = 1400;
int game_height = 900;
int pacman_start_x = 9;
int pacman_start_y = 8;

// Variables for Qlearning model 
int ntrials;
float last_trial_reward;
boolean showQ = false;
<<<<<<< HEAD
boolean random_move = false;
boolean rLearningMode = false;
int deaths = 0;
int oldX, oldY;
=======

>>>>>>> a506dcc19f94bb0b55f5b4c3c005070e27cc23c1

void setup(){
  map = new Map(w);
  pacman = new PacMan(pacman_start_x, pacman_start_y, w);
  setup_bots();
  size(700, 900);
  QAgent = new QLearning();
  size(game_width, game_height);
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
}

void draw(){
  background(0);
  stroke(0);
  map.display();
  pacman.display(); 
  for(Ghost g: ghosts){  
    g.display();
  }  
<<<<<<< HEAD
  //if(frameCount%25==0){
  if(rLearningMode == false){
    step_game();
    
    pacman.find_path();
  }
  else{
    step_game();
    QAgent.step();
=======
  
  // Toggles between the various PacMan Playing models 
  switch(game_mode){
    case -1:
      break;
    case 0: 
      QAgent.step();
      break;
    case 1: 
      step_game();
      pacman.find_path();
      break;
    case 2: 
      //pacman.solve();
      break;
    default: 
      game_mode = -1;
      break;
      
  /*
  int i=0;
  for(Ghost g: ghosts){
    if(i==0&&vector_model){
    pacman.solve(g);}
    i++;
>>>>>>> a506dcc19f94bb0b55f5b4c3c005070e27cc23c1
  }
  */
  text("Score: " + pacman.score, 25, 800);

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
  if(game_mode == 0)
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
<<<<<<< HEAD
=======
  } else if (key == 's') {
    step_game();
  } else if(key== 'v'){
     vector_model=true;
     human_model=false;
>>>>>>> origin/master
  } else if (key == 'l') {
<<<<<<< HEAD
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
=======
    pacman.x = QAgent.ix;
    pacman.y = QAgent.iy;
    game_mode = 0; 
  } else if (key == 'h') {
    game_mode = 1;
  } else if (key == 'v') {
    game_mode = 2;
  } else if (key == 'i') {
    game_mode = -1;
>>>>>>> a506dcc19f94bb0b55f5b4c3c005070e27cc23c1
  } else if (key == 'q') {
    showQ = !showQ;
  }
}
