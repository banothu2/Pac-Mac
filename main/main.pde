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
<<<<<<< HEAD
int w = 25;

boolean human_model = false;

boolean vector_model = false;

=======
int w = 50;
boolean showQ = false;
>>>>>>> origin/master
boolean random_move = false;
boolean rLearningMode = false;

void setup(){
  map = new Map(w);
  pacman = new PacMan(9, 8, w);
  setup_bots();
<<<<<<< HEAD
  size(700, 900);
=======
  QAgent = new QLearning();
  size(1400, 900);
>>>>>>> origin/master
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
<<<<<<< HEAD

  

  int i=0;
  for(Ghost g: ghosts){
    if(i==0&&vector_model){
    pacman.solve(g);}
    i++;
  }
  
  text("Score: " + pacman.score, 25, 800);
=======
>>>>>>> origin/master
  //if(frameCount%25==0){
  if(rLearningMode == false){
    step_game();
    
    pacman.find_path();
  }
  else{
    QAgent.step();
  }
  display_info();
}

void nextTrial(){
  last_trial_reward = QAgent.summed_reward;
  QAgent.home();
  pacman.reset();
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
<<<<<<< HEAD
  } else if(key== 'v'){
     vector_model=true;
     human_model=false;
=======
  } else if (key == 'l') {
    pacman.x = QAgent.ix;
    pacman.y = QAgent.iy;
    rLearningMode = !rLearningMode;
  } else if (key == 'q') {
    showQ = !showQ;
>>>>>>> origin/master
  }
}
