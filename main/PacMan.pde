class PacMan {
  int x;
  int y; 
  int r; 
  float w;                      // Cell size (pixels)
  int score;
  PacMan(){
    x = 13;
    y = 23;
    r = 20;
    w = 25;
    score = -1;
    consume();
  }
  
  void update(int _x, int _y){
    move(_x, _y);
    consume();
  }
 
  void move(int _x, int _y){
    int new_x = x + _x;
    int new_y = y + _y;
      if(x == 27 && y == 14 && _x == 1){
        x = 0;
        y = 14;
      } else if (x == 0 && y == 14 && _x == -1){
        x = 27;
        y = 14;
      } else if(new_x >= 0 && new_x <= 27 && new_y >= 0 && new_y <=30){  
      if(map.level_one[y + _y][x + _x] != 1){
        x = x + _x;
        y = y + _y;
      }
    }    
  }
  
  void consume(){
    if(map.level_one[y][x] == 2){
      map.level_one[y][x] = 0;
      score = score + 1;
    }
  }
  
  void display(){
    fill(255, 255, 0);
    ellipse(x*w+(w/2), y*w+(w/2), r, r);    
  }
}  
