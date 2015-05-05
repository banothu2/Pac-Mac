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
int NTEST = 0;
ArrayList<Ghost> ghosts = new ArrayList<Ghost>(NGHOSTS);
int deaths[] = {0,0,0};
float[][] value_right;
float[][] value_left;
float[][] value_up;
float[][] value_down;

int EAST = 0, SOUTH = 1, WEST = 2, NORTH = 3;
boolean random_move = false;

boolean random_move_ghost=false;

int game_mode = -1;
int a=1000;
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
int nRLTrials = 0;
int ntrials=0;
float last_trial_reward;
boolean showQ = false;
int oldX = 9;
int oldY = 8;

void setup(){
  map = new Map(w);
  pacman = new PacMan(pacman_start_x, pacman_start_y, w);
  setup_bots();
  size(700, 900);
  QAgent = new QLearning();
  size(game_width, game_height);
  value_right= new float[a][a];
  value_left= new float[a][a];
  value_down= new float[a][a];
  value_up= new float[a][a];
  for(Ghost g: ghosts){  
    g.attack();
  }  
  for(int i=0;i<1000;i++){
    for(int j=0;j<1000;j++){
    value_right[i][j]=0;
    value_left[i][j]=0;
    value_down[i][j]=0;
    value_up[i][j]=0;
  }
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
    if(game_mode == 0){
      if(nRLTrials > NTEST)
        g.display();
    }
    else
      g.display();
  }  
  //if(frameCount%1000==0){random_move_ghost= !random_move_ghost;}
  // Toggles between the various PacMan Playing models 
  switch(game_mode){
    case -1:
      break;
    case 0: 
      if(nRLTrials > NTEST)
        step_game();
      QAgent.step();
      break;
    case 1: 
      step_game();
      pacman.find_path();
      break;
    case 2: 
      step_game();
      pacman.solve();
      break;
    default: 
      game_mode = -1;
      break;
  }
  /*
  int i=0;
  for(Ghost g: ghosts){
    if(i==0&&vector_model){
    pacman.solve(g);}
    i++;
  }
  */
  display_info();
}

void nextTrial(){
  nRLTrials++;
  if(pacman.alive != true)
    deaths[game_mode]++;
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
  if(game_mode == 0){
    text("Reinforcement Learning Mode On", 0, 780);
    if(nRLTrials > NTEST)
      text("Ghosts ON", 250, 780);
    else
      text("Ghosts OFF", 250, 780);
  }
  else
    text("Reinforcement Learning Mode Off", 0, 780);
  if(game_mode != -1)
    text("Deaths: " + deaths[game_mode], 350, 780);
  text("l: switch to reinforcement learning mode", 600, 800);
  text("h: switch to smart mode (avoid prey and get closest pellet", 600, 820);
  text("v: switch to vector mode", 600, 840);
  text("p: pause/run", 600, 860);
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
  } else if (key == 'l' && game_mode != 0) {
    map.level_one = map.level_zero_copy_RL;
    oldX = pacman.x;
    oldY = pacman.y;
    pacman.x = QAgent.ix;
    pacman.y = QAgent.iy;
    game_mode = 0;
  } else if (key == 'h' & game_mode != 1) {
    game_mode = 1;
    map.level_one = map.level_zero;
    pacman.x = oldX;
    pacman.y = oldY;
  } else if (key == 'v' && game_mode != 2) {
    game_mode = 2;
  } else if (key == 'i') {
    game_mode = -1;
  } else if (key == 'q') {
    showQ = !showQ;
  }
}
