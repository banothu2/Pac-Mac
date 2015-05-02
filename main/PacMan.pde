class PacMan {
  int x;
  int y; 
  int r; 
  float w;                      // Cell size (pixels)
  int score;
  int movement_direction = -1;       // -1 = no movement. 0 = up, 1 = down, 2 = left, 3 = right
  boolean moving_one_block = false;
  int transition_x = 0;
  int transition_y = 0;
  PacMan(int _x, int _y) {
    x = _x;
    y = _y; // 23
    r = 20;
    w = 25;
    score = -1;
    consume();
  }

  float get_x(){
    return x;
  }
  
  void update(int _x, int _y) {
    consume();
    move(_x, _y);
  }

  void find_path(){
    
  }

  void move(int _x, int _y) {
    int x_val = _x;
    int y_val = _y;
    float new_x = x + _x;
    float new_y = y + _y;
    if (x == 27 && y == 14 && _x == 1) {
      x = 0;
      y = 14;
    } else if (x == 0 && y == 14 && _x == -1) {
      x = 27;
      y = 14;
    } else if (new_x >= 0 && new_x <= 27 && new_y >= 0 && new_y <=30) {  
      if (map.level_one[y + _y][x + _x] != 1) {
        x = x + _x;
        y = y + _y;
    
        if ( _y == -1 ) { 
          movement_direction = 0;
        }
        if ( _y ==  1 ) {
          movement_direction = 1;
        }
        if ( _x == -1 ) { 
          movement_direction = 2;
        } 
        if ( _x ==  1 ) {
          movement_direction = 3;
        }
      }
    } 
  }

  void consume() {
    if (map.level_one[y][x] == 2) {
      map.level_one[y][x] = 0;
      score = score + 1;
    }
  }

  void display() {
    fill(255, 255, 0);
//    int x_dir = 0;
//    int y_dir = 0;
//    if (moving_one_block) {
//      switch(movement_direction) {
//      case 0: // UP
//        transition_y = transition_y - 1;
//        y_dir = -1;
//        break;
//      case 1: // DOWN
//        transition_y = transition_y + 1;
//        y_dir = 1;
//        break;
//      case 2: // LEFT
//        transition_x = transition_x + -1;
//        x_dir = -1;
//        break;
//      case 3: // RIGHT
//        transition_x = transition_x +  1;
//        x_dir = 1;
//        break;
//      default: 
//        break;
//      }
//      if( map.level_one[y + 2*y_dir][x + ] == 1 ){
//        moving_one_block = false;
//      }
//    }
//    if (moving_one_block == false) {
//      x = x+ (transition_x/25);
//      y = y+ (transition_y/25);
//      transition_x = 0;
//      transition_y = 0;
//      movement_direction = -1;
//    }
    ellipse(x*w+(w/2) + transition_x, y*w+(w/2) + transition_y, r, r);
  }
  
  void reset(){
    x=13;
    y=23;
  }
  
}  

