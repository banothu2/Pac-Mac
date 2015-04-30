class Ghost {
  int x;
  int y; 
  int r; 
  int w;
  int type;                 // Red = 0, Pink = 1, Blue = 2, Green = 3
  int prex, prey; //used so ghost follows a command till it reaches intersection
  int padding; 
  Ghost(int _type, int _x, int _y, int _r, int _w){
    x = _x;
    y = _y;
    r = _r;
    w = _w;
    type = _type;
  }
  
  void update(int _x, int _y){
    move(_x, _y);
  }
  
  void attack(){
    switch(type){
      case 0: 
        blinky();
        break;
      case 1:
        pinky();
        break;
      case 2:
        break;
      case 3: 
        break;
    } 
  }
  
  /*void blinky(){
    PVector pacman_location, ghost_location, ghost_target, difference;
    pacman_location = new PVector(pacman.x,pacman.y);
    ghost_location  = new PVector(x,y);
    ghost_target    = new PVector(0,0);
    difference      = new PVector(0,0);
    
    difference      = PVector.sub(ghost_location, pacman_location);
    
    if(type == 1 && map.intersections[x][y] == 3 || map.intersections[x][y] == 0){
      ghost_target = difference;
      ghost_target.normalize();
      if (abs(ghost_target.x) > abs(ghost_target.y)){
        if (ghost_target.x<0 && map.intersections[x+1][y]!=1 ){
          prex=1;prey=0;
        } else if ( ghost_target.x>0 && map.intersections[x-1][y]!=1 ){
          prex=-1; prey=0;
        } else if ( map.intersections[x+1][y]!=1 ){
          prex=1;prey=0;
        } else {
          prex=1;prey=0;
        }
      }
      else{
        if (ghost_target.y>0 && map.intersections[x][y-1]!=1){
          prex=0;
          prey=-1;
        } else if (ghost_target.y<0 && map.intersections[x][y+1]!=1){
          prex=0;
          prey=1;
        } else if (map.intersections[x][y-1]!=1){
          prex=0;
          prey=-1;
        } else {
          prex=0;
          prey=1;
        }
      }
    }
    move(prex,prey);  
  }*/

  void blinky(){
    PVector pacman_location, ghost_location, ghost_target, difference;
    pacman_location = new PVector(pacman.x,pacman.y);
    ghost_location  = new PVector(x,y);
    ghost_target    = new PVector(0,0);
    difference      = new PVector(0,0);
    if(pacman_location.equals(ghost_location)){pacman.reset();}
    // Gets the vector that points from Ghost to Pacman
    //difference      = PVector.sub(pacman_location, ghost_location);
    difference        = PVector.sub(ghost_location, pacman_location);
    
    
    stroke(0, 255, 0);
    line(pacman_location.x*w + (w/2), pacman_location.y*w + (w/2), ghost_location.x*w + (w/2), ghost_location.y*w + (w/2));
    //line(ghost_location.x, ghost_location.y, ghost_location.x + difference.x, ghost_location.y + difference.y);
    noStroke();

    // Intersection or box - Ghost gets a new target
    if(map.intersections[y][x] == 3 || map.intersections[y][x] == 0){
      ghost_target = difference;
      ghost_target.normalize();
      // If x component is larger than y, it should move horizontally. 
      if (abs(ghost_target.x) > abs(ghost_target.y)){
        if (ghost_target.x > 0 && map.intersections[y][x-1] != 1 ){
          prex = -1;
          prey = 0;
        } else if ( ghost_target.x < 0 && map.intersections[y][x+1] != 1 ){
          prex = 1; 
          prey = 0;
        } 
        else if (ghost_target.y > 0 && map.intersections[y-1][x]!=1){
          prex = 0;
          prey = -1;
        } else if (ghost_target.y<0 && map.intersections[y+1][x]!=1){
          prex = 0;
          prey = 1;
        }
      } else {
        if (ghost_target.y > 0 && map.intersections[y-1][x]!=1){
          prex = 0;
          prey = -1;
        } else if (ghost_target.y<0 && map.intersections[y+1][x]!=1){
          prex = 0;
          prey = 1;
        }
        else if (ghost_target.x > 0 && map.intersections[y][x-1] != 1 ){
          prex = -1;
          prey = 0;
        } else if ( ghost_target.x < 0 && map.intersections[y][x+1] != 1 ){
          prex = 1; 
          prey = 0;
        } 
      }
    }
    if(frameCount % 25 == 0){
      move(prex,prey); 
    }
    if(prex==1){
      text("right",100,800);
    }
    if(prex==-1){
      text("left",100,800);
    }
    if(prex==0){
      text(0,100,800);
    }
    if(prey==1){
      text("down",100,850);
    }
    if(prey==-1){
      text("up",100,850);
    }
    if(prey==0){
      text(0,100,850);
    }
  }
      
  void pinky(){
    PVector pacman_location, ghost_location, ghost_target, difference;
    pacman_location = new PVector(pacman.x,pacman.y);
    ghost_location  = new PVector(x,y);
       
    switch (pacman.movement_direction){
      case 0:
        if(map.intersections[pacman.x][pacman.y - 1] == 1)
          ghost_target = new PVector(pacman.x, pacman.y);
        else if(map.intersections[pacman.x][pacman.y - 2] == 1)
          ghost_target = new PVector(pacman.x, pacman.y - 1);
        else if(map.intersections[pacman.x][pacman.y - 3] == 1)
          ghost_target = new PVector(pacman.x, pacman.y - 2);
        else if(map.intersections[pacman.x][pacman.y - 4] == 1)
          ghost_target = new PVector(pacman.x, pacman.y - 3);
        else
          ghost_target = new PVector(pacman.x, pacman.y - 4);
        break;
      case 1:
        if(map.intersections[pacman.x][pacman.y + 1] == 1)
          ghost_target = new PVector(pacman.x, pacman.y);
        else if(map.intersections[pacman.x][pacman.y + 2] == 1)
          ghost_target = new PVector(pacman.x, pacman.y + 1);
        else if(map.intersections[pacman.x][pacman.y + 3] == 1)
          ghost_target = new PVector(pacman.x, pacman.y + 2);
        else if(map.intersections[pacman.x][pacman.y + 4] == 1)
          ghost_target = new PVector(pacman.x, pacman.y + 3);
        else
          ghost_target = new PVector(pacman.x, pacman.y + 4);
        break;
      case 2:
        if(map.intersections[pacman.x - 1][pacman.y] == 1)
          ghost_target = new PVector(pacman.x, pacman.y);
        else if(map.intersections[pacman.x - 2][pacman.y] == 1)
          ghost_target = new PVector(pacman.x - 1, pacman.y - 1);
        else if(map.intersections[pacman.x - 3][pacman.y] == 1)
          ghost_target = new PVector(pacman.x - 2, pacman.y);
        else if(map.intersections[pacman.x - 4][pacman.y] == 1)
          ghost_target = new PVector(pacman.x - 3, pacman.y);
        else
          ghost_target = new PVector(pacman.x - 4, pacman.y);
        break;
      case 3:
        if(map.intersections[pacman.x + 1][pacman.y] == 1)
          ghost_target = new PVector(pacman.x, pacman.y);
        else if(map.intersections[pacman.x + 2][pacman.y] == 1)
          ghost_target = new PVector(pacman.x + 1, pacman.y);
        else if(map.intersections[pacman.x + 3][pacman.y] == 1)
          ghost_target = new PVector(pacman.x + 2, pacman.y);
        else if(map.intersections[pacman.x + 4][pacman.y] == 1)
          ghost_target = new PVector(pacman.x + 3, pacman.y);
        else
          ghost_target = new PVector(pacman.x + 4, pacman.y);
        break;
      default:
        ghost_target = new PVector(pacman.x, pacman.y);
        break;
    }
    
      // Intersection or box - Ghost gets a new target
     // Intersection or box - Ghost gets a new target
    if(map.intersections[y][x] == 3 || map.intersections[y][x] == 0){
      // If x component is larger than y, it should move horizontally.
     ghost_target =  PVector.sub(ghost_location, ghost_target);
      if (abs(ghost_target.x) > abs(ghost_target.y)){
        if (ghost_target.x > 0 && map.intersections[y][x-1] != 1 
            && map.intersections[y][x-1] != 0){
          prex = -1;
          prey = 0;
        } else if ( ghost_target.x < 0 && map.intersections[y][x+1] != 1 
             && map.intersections[y][x+1] != 0){
          prex = 1; 
          prey = 0;
        } 
        else if (ghost_target.y > 0 && map.intersections[y-1][x]!=1
             && map.intersections[y-1][x] != 0){
          prex = 0;
          prey = -1;
        } else if (ghost_target.y<0 && map.intersections[y+1][x]!=1
            && map.intersections[y+1][x] != 0){
          prex = 0;
          prey = 1;
        }
      } else {
        if (ghost_target.y > 0 && map.intersections[y-1][x] != 1
            && map.intersections[y-1][x] != 0){
          prex = 0;
          prey = -1;
        } else if (ghost_target.y<0 && map.intersections[y+1][x] != 1
            && map.intersections[y+1][x] != 0){
          prex = 0;
          prey = 1;
        }
        else if (ghost_target.x > 0 && map.intersections[y][x-1] != 1
           && map.intersections[y][x-1] != 0){
          prex = -1;
          prey = 0;
        } else if ( ghost_target.x < 0 && map.intersections[y][x+1] != 1
           && map.intersections[y][x+1] != 0){
          prex = 1; 
          prey = 0;
        } 
      }
    }
    
    
    stroke(0, 255, 0);
    line(ghost_target.x*w + (w/2), ghost_target.y*w + (w/2), ghost_location.x*w + (w/2), ghost_location.y*w + (w/2));
    //line(ghost_location.x, ghost_location.y, ghost_location.x + difference.x, ghost_location.y + difference.y);
    noStroke();
    
    
    if(frameCount % 25 == 0){
      move(prex,prey);  
    }
    
    if(prex==1){
      text("right",100,800);
    }
    if(prex==-1){
      text("left",100,800);
    }
    if(prex==0){
      text(0,100,800);
    }
    if(prey==1){
      text("down",100,850);
    }
    if(prey==-1){
      text("up",100,850);
    }
    if(prey==0){
      text(0,100,850);
    }
  }
/*

  void blinky(){
    PVector pacman_location, ghost_location, ghost_target, difference;
    pacman_location = new PVector(pacman.x,pacman.y);
    ghost_location  = new PVector(x,y);
    ghost_target    = new PVector(0,0);
    difference      = new PVector(0,0);
    // Gets the vector that points from Ghost to Pacman
    difference      = PVector.sub(pacman_location, ghost_location);
    
    if(map.intersections[y][x] == 3 || map.intersections[y][x] == 0){
      ghost_target = difference;
      ghost_target.normalize();
      if (abs(ghost_target.x) > abs(ghost_target.y)){
        if (ghost_target.x < 0 && map.intersections[y+1][x]!=1 ){
          prex=1;prey=0;
        } else if ( ghost_target.x>0 && map.intersections[y-1][x]!=1 ){
          prex=-1; prey=0;
        } else if ( map.intersections[y+1][x]!=1 ){
          prex=1;prey=0;
        } else {
          prex=1;prey=0;
        }
      }
    }
    move(prex,prey);  
  }*/
      
      
  void move(int _x, int _y){
    int new_x = x + _x;
    int new_y = y + _y;
    //Tunnel
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
    if(type == 0)
      fill(255, 0, 0);
    else if(type == 1)
      fill(250, 150, 150);
    ellipse(x*w+(w/2), y*w+(w/2), r, r);    
  }
}

