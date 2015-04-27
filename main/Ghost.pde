class Ghost {
  int x;
  int y; 
  int r; 
  float w;
  int type;                 // Red = 0, Pink = 1, Blue = 2, Green = 3
  int prex, prey; //used so ghost follows a command till it reaches intersection
  Ghost(int _type, int _x, int _y, int _r, float _w){
    x = _x;
    y = _x;
    r = _r;
    w = _w;
    type = _type;
  }
  
  void update(int _x, int _y){
    move(_x, _y);
  }
  
  /*modified by Edgar
  void update( int _type){
    pacman_location= new PVector(pacman.x,pacman.y);
    ghost_location = new PVector(x,y);
    ghost_target= new PVector(0,0);
    PVector difference = new PVector(0,0);
    difference = PVector.sub(ghost_location,pacman_location);
    if(type==1 && map.level_one[x][y]==3 || map.level_one[x][y]==0){
      ghost_target = difference;
      ghost_target.normalize();
      if(abs(ghost_target.x)>abs(ghost_target.y)){
        if(ghost_target.x<0&&map.level_one[x+1][y]!=1){prex=1;prey=0;}
        else if(ghost_target.x>0&&map.level_one[x-1][y]!=1){prex=-1; prey=0;}
        else if(map.level_one[x+1][y]!=1){prex=1;prey=0;}
        else {prex=1;prey=0;}
      }
      else{
        if(ghost_target.y>0&&map.level_one[x][y-1]!=1){prex=0;prey=-1;}
        else if(ghost_target.y<0&&map.level_one[x][y+1]!=1) {prex=0;prey=1;}
        else if(map.level_one[x][y-1]!=1){prex=0;prey=-1;}
        else {prex=0;prey=1;}
      }
    }
  move(prex,prey);  
  }
  }
*/  
//end of modification
//Update 1:in theory modification should guide ghost towards pacman, but move control is not responding as expected. Also need to modify
//nodes in master branch to value 3 at intersections so ghost knows when to turn, already did this in local file but haven't
//upadted master... any suggestions on how to fix the move command, or if my code is wrong?
//Update 2: Working better, need to tweak a few conditional statements, what if pacman_location = ghost_location, speed of ghost, etc. 
//If anyone needs me to update the map let me know, don't want to do it yet because I don't want to create confusion
 
//Yo don't understand this attack code, what's the purpose of the case function?
  void attack(){
    switch(type){
      case 0: 
        blinky();
        break;
      case 1:
        break;
      case 2:
        break;
      case 3: 
        break;
    } 
  }
  
  void blinky(){
    
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
  
  void display(){
    fill(255, 0, 0);
    ellipse(x*w+(w/2), y*w+(w/2), r, r);    
  }
}

