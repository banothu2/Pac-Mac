class Ghost {
  int x;
  int y; 
  int r; 
  int w;
  int type;                 // Red = 0, Pink = 1, Blue = 2, Green = 3
  int prex, prey, prexi, preyi, oprex, oprey, checker; //used so ghost follows a command till it reaches intersection
  int padding; 
  int facing_x, facing_y;
  int startX, startY;
  
  PVector pacman_location, blinky_location, ghost_location, ghost_target, difference1, difference2, difference;
  Ghost(int _type, int _x, int _y, int _r, int _w){
    x = _x;
    y = _y;
    startX = _x;
    startY = _y;
    r = _r;
    w = _w;
    type = _type;
  }
  
  void update(int _x, int _y){
    move(_x, _y);
  }
  
  void reset(){
    x = startX;
    y = startY;
  }
  
  void attack(){
    switch(type){
      case 0: 
        blinky();
        break;
      case 1:
        random_ghost();
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
    pacman_location = new PVector(pacman.x,pacman.y);
    ghost_location  = new PVector(x,y);
    ghost_target    = new PVector(0,0);
    difference      = new PVector(0,0);
    if(pacman_location.equals(ghost_location)){
      pacman.reset();
    }
    // Gets the vector that points from Ghost to Pacman
    //difference      = PVector.sub(pacman_location, ghost_location);
    difference        = PVector.sub(ghost_location, pacman_location);
    
    
    stroke(0, 255, 0);
    line(pacman_location.x*w + (w/2), pacman_location.y*w + (w/2), ghost_location.x*w + (w/2), ghost_location.y*w + (w/2));
    //line(ghost_location.x, ghost_location.y, ghost_location.x + difference.x, ghost_location.y + difference.y);
    noStroke();
    
    oprex=prex;
    oprey=prey;

    // Intersection or box - Ghost gets a new target
    if(map.intersections[y][x] == 3 || map.intersections[y][x] == 0){
      ghost_target = difference;
      ghost_target.normalize();

      // If x component is larger than y, it should move horizontally. 
      if (abs(ghost_target.x) > abs(ghost_target.y)){
        if (ghost_target.x >= 0 && check_left() && oprex!=1){
          prex = -1;
          prey = 0;
          checker=1;
        } else if ( ghost_target.x <= 0 && check_right() && oprex!=-1){
          prex = 1; 
          prey = 0;
          checker=2;
        } 
        else if (ghost_target.y >= 0 && check_up()  && oprey!=1){
          prex = 0;
          prey = -1;
          checker=3;
        } else if (ghost_target.y<=0 && check_down() && oprey!=-1){
          prex = 0;
          prey = 1;
          checker=4;
        }
         else if(check_up() && oprey!=1){
         prex = 0;
         prey = -1;
         checker=5;
         }
         else if(check_down() && oprey!= -1){
         prex = 0;
         prey = 1;
         checker=6;
         }
      } else {
        if (ghost_target.y >= 0 && check_up() && oprey!=1){
          prex = 0;
          prey = -1;
          checker=7;
        } else if (ghost_target.y<=0 && check_down() && oprey!=-1){
          prex = 0;
          prey = 1;
          checker=8;
        }
        else if (ghost_target.x >= 0 && check_left() && oprex!=1){
          prex = -1;
          prey = 0;
          checker=9;
        } else if ( ghost_target.x <= 0 && check_right() && oprex!=-1 ){
          prex = 1; 
          prey = 0;
          checker=10;
        } 
        else if(check_left() && oprex!=1){
          prex = -1;
          prey = 0;
          checker=11;
        }
        else if(check_right() && oprex != -1){
          prex = 1; 
          prey = 0;
          checker=12;
        }
      }
    }
    // 
    if(frameCount%25==1){
      move(prex,prey);

    }
    text("Blinky Direction: ", 75, 800);
    if(prex==1){
      text("right",175,800);
    }
    if(prex==-1){
      text("left",175,800);
    }
    if(prey==1){
      text("down",175,800);
    }
    if(prey==-1){
      text("up", 175,800);
    }
    
    //text(ghost_target.x,200,800);
    //text(ghost_target.y,200,850);
    //text(oprex,250,800);
    //text(oprey,250,850);
    //text(checker, 350, 800);
      facing_x = prex + int(ghost_location.x);
      facing_y = prey + int(ghost_location.y);
  }
      

  void random_ghost(){
    pacman_location = new PVector(pacman.x,pacman.y);
    ghost_location  = new PVector(x,y);
    //print(x, y, "\n");
    if(pacman_location.equals(ghost_location)){
      pacman.reset();
      print("PACMAN AND RANDOM AT SAME LOCATION");
    }
   
     boolean picked_direction = false;
      if(map.intersections[y][x] == 3){
        while(!picked_direction){
          int random_direction = int(random(-0.5, 3.5));
            if (random_direction == 0) {
              prex = 0;
              prey = -1;
              picked_direction = check_up();
            } else if (random_direction == 1) {
              prex = 0;
              prey = 1;
              picked_direction = check_down();
            } else if (random_direction == 2) {
              prex = -1;
              prey = 0;
              picked_direction = check_left();
            } else if (random_direction == 3) {
              prex = 1;
              prey = 0;
              picked_direction = check_right();
            } 
        }
      } else {
  
        //move(facing_x, facing_y);
      }
      // 
      if(frameCount%25==1){
        move(prex,prey);
      }
      text("Pinky Direction: ", 225,800);
      if(prex==1){
        text("right",325,800);
      }
      if(prex==-1){
        text("left",325,800);
      }
      if(prey==1){
        text("down",325,800);
      }
      if(prey==-1){
        text("up",325,800);
      }
      
        facing_x = prex + int(ghost_location.x);
        facing_y = prey + int(ghost_location.y);
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
      text("right",100,850);
    }
    if(prex==-1){
      text("left",100,850);
    }
    if(prey==1){
      text("down",100,850);
    }
    if(prey==-1){
      text("up",100,850);
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
    
    fill(255, 255, 255);
    ellipse(facing_x*w+(w/2), facing_y*w+(w/2), r/2, r/2);
  }
  
  boolean check_right(){
    if(map.intersections[y][x+1] != 1) return true;
    else return false;
  }
  
  boolean check_left(){
    if(map.intersections[y][x-1] != 1) return true;
    else return false;
  }
  
  boolean check_up(){
    if(map.intersections[y-1][x]!=1) return true;
    else return false;
  }
  
  boolean check_down(){
    if(map.intersections[y+1][x]!=1) return true;
    else return false;
  }
}

