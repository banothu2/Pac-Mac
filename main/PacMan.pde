class PacMan {
  int x;
  int y; 
  int r; 
  int w;                      // Cell size (pixels)
  int score;
  int movement_direction = -1;       // -1 = no movement. 0 = up, 1 = down, 2 = left, 3 = right
  boolean moving_one_block = false;
  int transition_x = 0;
  int transition_y = 0;
  boolean alive;
  int[][] PacMap;
  int reset_x; 
  int reset_y;
  PVector Pacman_target, difference,pacman_location,ghost_location;
  int prex, prey;
  Ghost temp;
  int pellets_right, pellets_left, pellets_up, pellets_down;

  int max_depth_for_search = 6;
  int[][] memo = {
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
             };
  int ghost_penalty = -30;
  int pellet_reward = 3;
  int empty_square_reward = 4;

  PacMan(int _x, int _y, int _w) {
    x = _x;
    y = _y; // 23
    r = 20;
    w = _w;
    score = -1;
    alive = true;
    consume();
    reset_x = _x;
    reset_y = _y;
    PacMap = map.level_zero_copy;
  }


  float get_x() {
    return x;
  }

  void update(int _x, int _y) {
    consume();
    move(_x, _y);
  }

  void find_path() {
    for (int i = 0; i < map.ny; i++) {
      for (int j = 0; j < map.nx; j++) {
        int val =  map.level_one[j][i];
        PacMap[j][i] = val;
      }
    }
    
    int i = 0;
    for (Ghost g : ghosts) {
      PacMap[g.y][g.x] = -10;
      if(i < NGHOSTS - 1){
        BFS_ghost(PacMap, g);
      } else {
        BFS_p_n_g(PacMap, x, y, g);
      }
      i++;
    } 
    if(frameCount%10==0){
      memo[y][x] = 1;
      ValueAndDirection best_dir = new ValueAndDirection(0, 0);
      best_dir = pick_direction(x, y, 0, 0);
      memo[y][x] = 0;
      //print("Best direction val, and direction: ", best_dir.val, best_dir.direction, "\n");
      
      /*
      print("Best value: ", best_dir.val);
      switch(best_dir.direction){
        case 0: 
          print(" LEFT \n");
          break;
        case 1:
          print(" RIGHT \n");
          break;
        case 2:
          print(" UP \n");
          break; 
        case 3: 
          print(" DOWN \n");
          break;  
      }
      */
      int x_val = 0;
      int y_val = 0;
      switch(best_dir.direction){
        case 0: 
          update(-1, 0);
          break;
        case 1:
          update( 1, 0);
          break;
        case 2:
          update(0, -1);
          break; 
        case 3: 
          update(0,  1);
          break;  
      }
    }
    
    //paused = !paused;
    //BFS_p_n_g(PacMap, x, y, ghosts);
    //BFS_pacman(PacMap, x, y);
    // Find where the Ghosts are in the map and mark it 

    // Find where pac man is in the map and mark it
    display_pacmap();
  }
  
  ValueAndDirection pick_direction(int _x, int _y, int _prev, int _depth){
     // Need to try all 4 directions 
     // Need to return best value and direction pair.    

     float[] cardinals = {0, 0, 0, 0};
     // LEFT - grid[v.y][v.x-1]
     if(_depth < 5){
       if( (PacMap[_y][_x-1] == pellet_reward || PacMap[_y][_x-1] == ghost_penalty || PacMap[_y][_x-1] == empty_square_reward) && memo[_y][_x-1] == 0 ){
           memo[_y][_x-1] = 1;
           _depth = _depth + 1;
           ValueAndDirection recurse = new ValueAndDirection(0, 0);
           recurse = pick_direction(_x-1, _y, PacMap[_y][_x-1], _depth);
           if(PacMap[_y][_x-1] == empty_square_reward){
             cardinals[0] = 1 + (recurse.val)*(1.0/(_depth*_depth));
           } else {
             cardinals[0] = PacMap[_y][_x-1] + (recurse.val)*(1.0/(_depth*_depth));
           }
           //PacMap[_y][_x-1] = -10;
           //print(PacMap[_y][_x-1], _depth, _y, _x-1, cardinals[0], "\n");
            memo[_y][_x-1] = 0;
       }
       
       // RIGHT - grid[v.y][v.x+1]
       if( (PacMap[_y][_x+1] == pellet_reward || PacMap[_y][_x+1] == ghost_penalty || PacMap[_y][_x+1] == empty_square_reward) && memo[_y][_x+1] == 0 ){
           memo[_y][_x+1] = 1; // Mark as traveled.
           _depth = _depth + 1;
           ValueAndDirection recurse = new ValueAndDirection(0, 0);
           recurse = pick_direction(_x+1, _y, PacMap[_y][_x+1], _depth);
          if(PacMap[_y][_x+1] == empty_square_reward){
             cardinals[1] = 1 + (recurse.val)*(1.0/(_depth*_depth));
           } else {
             cardinals[1] = PacMap[_y][_x+1] + (recurse.val)*(1.0/(_depth*_depth));
           }
           //PacMap[_y][_x+1] = -10;
           memo[_y][_x+1] = 0;
       }
       // TOP - grid[v.y-1][v.x]
      if( (PacMap[_y-1][_x] == pellet_reward || PacMap[_y-1][_x] == ghost_penalty || PacMap[_y-1][_x] == 4) && memo[_y-1][_x] == 0 ){
           memo[_y-1][_x] = 1; // Mark as traveled.
           _depth = _depth + 1;
           ValueAndDirection recurse = new ValueAndDirection(0, 0);
           recurse = pick_direction(_x, _y-1, PacMap[_y-1][_x], _depth);
           if(PacMap[_y-1][_x] == empty_square_reward){
             cardinals[2] = 1 + (recurse.val)*(1.0/(_depth*_depth));
           } else {
             cardinals[2] = PacMap[_y-1][_x] + (recurse.val)*(1.0/(_depth*_depth));
           }
           //PacMap[_y-1][_x] = -10;
           memo[_y-1][_x] = 0;
       }
       // BOTTOM - grid[v.y+1][v.x]
      if( (PacMap[_y+1][_x] == pellet_reward || PacMap[_y+1][_x] == ghost_penalty || PacMap[_y+1][_x] == empty_square_reward) && memo[_y+1][_x] == 0 ){
           memo[_y+1][_x] = 1; // Mark as traveled.
           _depth = _depth + 1;
           ValueAndDirection recurse = new ValueAndDirection(0, 0);
           recurse = pick_direction(_x, _y+1, PacMap[_y+1][_x], _depth);
           if(PacMap[_y+1][_x] == empty_square_reward){
             cardinals[3] = 1 + (recurse.val)*(1.0/(_depth*_depth));
           } else {
             cardinals[3] = PacMap[_y+1][_x] + (recurse.val)*(1.0/(_depth*_depth));
           }
           //PacMap[_y-1][_x] = -10;
           memo[_y+1][_x] = 0;
       }
     }
     
     //print(cardinals[0], cardinals[1], _depth, "\n");
     
     float max = cardinals[0]; 
     int dir = 0;
     for(int i = 1; i < 4; i++){
       if(cardinals[i] > max){
         max = cardinals[i];
         dir = i;  
       }
     }
     ValueAndDirection ret = new ValueAndDirection(max, dir);
 
     return ret;
     // RIGHT - grid[v.y][v.x+1]
     
     // TOP - grid[v.y-1][v.x]
     
     // BOTTOM - grid[v.y+1][v.x]
     
     
     // Map for values - PacMap 
     // ValueAndDirection ret = new ValueAndDirection(0, 0);
     // 0 - LEFT, 1 - RIGHT, 2 - UP, 3 - Down  
  }
  
  void BFS_p_n_g(int [][] grid, int _x, int _y, Ghost g){
    boolean death = false;
    Queue pac_q = new Queue();
    Queue ghost_one_q = new Queue();
    
    Coords c = new Coords(_x, _y);
    Coords g_c = new Coords(g.x,g.y);
    
    pac_q.push(c);
    ghost_one_q.push(g_c);
    grid[g_c.y][g_c.x] = ghost_penalty;
    // Label v as discovered 
    //grid[y][x] = ;
    int levels = 0;
    while(!pac_q.empty() && !ghost_one_q.empty() && levels < 4*6 && !death){
      levels = levels + 1;

      Coords v = pac_q.pop();
      Coords gv = ghost_one_q.pop();
      // Right 
      Coords n = new Coords(0, 0);
      Coords n2 = new Coords(0, 0);
      
      
      switch(grid[v.y][v.x+1]){
        case 0: 
          n.y = v.y;
          n.x = v.x+1;
          pac_q.push(n);
          grid[v.y][v.x+1] = empty_square_reward;
          break;
        case 1: 
          break;
        case 2:
          n.y = v.y;
          n.x = v.x+1;
          pac_q.push(n);
          grid[v.y][v.x+1] = pellet_reward;
          break;
        case -10:
          death = true;
          break;
          
      }
      // Left
      switch(grid[v.y][v.x-1]){
        case 0: 
          n.y = v.y;
          n.x = v.x-1;
          pac_q.push(n);
          grid[v.y][v.x-1] = empty_square_reward;
          break;
        case 1: 
          break;
        case 2:
          n.y = v.y;
          n.x = v.x-1;
          pac_q.push(n);
          grid[v.y][v.x-1] = pellet_reward;
          break;
        case -10:
          death = true;
          break;
      }
      // Top
      switch(grid[v.y-1][v.x]){
        case 0: 
          n.y = v.y-1;
          n.x = v.x;
          pac_q.push(n);
          grid[v.y-1][v.x] = empty_square_reward;
          break;
        case 1: 
          break;
        case 2:
          n.y = v.y-1;
          n.x = v.x;
          pac_q.push(n);
          grid[v.y-1][v.x] = pellet_reward;
          break;
        case -10:
          death = true;
          break;
      }
      // Bottom
      switch(grid[v.y+1][v.x]){
        case 0: 
          n.y = v.y+1;
          n.x = v.x;
          pac_q.push(n);
          grid[v.y+1][v.x] = empty_square_reward;
          break;
        case 1: 
          break;
        case 2:
          n.y = v.y+1;
          n.x = v.x;
          pac_q.push(n);
          grid[v.y+1][v.x] = pellet_reward;
          break;
        case -10:
          death = true;
          break;
      }
      
      
      if(levels < 4*4){
        // Top 
        switch(grid[gv.y][gv.x+1]){
          case 0: 
            n.y = gv.y;
            n.x = gv.x+1;
            ghost_one_q.push(n);
            grid[gv.y][gv.x+1] = ghost_penalty;
            break;
          case 1: 
            break;
          case 2:
            n.y = gv.y;
            n.x = gv.x+1;
            ghost_one_q.push(n);
            grid[gv.y][gv.x+1] = ghost_penalty;
            break;
          case -30: 
            n.y = gv.y;
            n.x = gv.x+1;
            ghost_one_q.push(n);
            grid[gv.y][gv.x+1] = ghost_penalty;
            break;
        }
        // Left
        switch(grid[gv.y][gv.x-1]){
          case 0: 
            n.y = gv.y;
            n.x = gv.x-1;
            ghost_one_q.push(n);
            grid[gv.y][gv.x-1] = ghost_penalty;
            break;
          case 1: 
            break;
          case 2:
            n.y = gv.y;
            n.x = gv.x-1;
            ghost_one_q.push(n);
            grid[gv.y][gv.x-1] = ghost_penalty;
            break;
          case -30: 
            n.y = gv.y;
            n.x = gv.x-1;
            ghost_one_q.push(n);
            grid[gv.y][gv.x-1] = ghost_penalty;
            break;
        }
        // Top
        switch(grid[gv.y-1][gv.x]){
          case 0: 
            n.y = gv.y-1;
            n.x = gv.x;
            ghost_one_q.push(n);
            grid[gv.y-1][gv.x] = ghost_penalty;
            break;
          case 1: 
            break;
          case 2:
            n.y = gv.y-1;
            n.x = gv.x;
            ghost_one_q.push(n);
            grid[gv.y-1][gv.x] = ghost_penalty;
            break;
          case -30: 
            n.y = gv.y-1;
            n.x = gv.x;
            ghost_one_q.push(n);
            grid[gv.y-1][gv.x] = ghost_penalty;
            break;
        }
        // Bottom
        switch(grid[gv.y+1][gv.x]){
          case 0: 
            n.y = gv.y+1;
            n.x = gv.x;
            ghost_one_q.push(n);
            grid[gv.y+1][gv.x] = ghost_penalty;
            break;
          case 1: 
            break;
          case 2:
            n.y = gv.y+1;
            n.x = gv.x;
            ghost_one_q.push(n);
            grid[gv.y+1][gv.x] = ghost_penalty;
            break;
          case -30: 
            n.y = gv.y+1;
            n.x = gv.x;
            ghost_one_q.push(n);
            grid[gv.y+1][gv.x] = ghost_penalty;
            break;
        }
      }
    }
    
  }
  
  void BFS_ghost(int [][] grid, Ghost g){
    boolean death = false;
    Queue ghost_one_q = new Queue();
    Coords g_c = new Coords(g.x,g.y);
    ghost_one_q.push(g_c);
    grid[g_c.y][g_c.x] = ghost_penalty;
    int levels = 0;
    while(!ghost_one_q.empty() && levels < 4*4 && !death){
      levels = levels + 1;
      Coords gv = ghost_one_q.pop();
      Coords n = new Coords(0, 0);      
      
      if(levels < 4*4){
        // Top 
        switch(grid[gv.y][gv.x+1]){
          case 0: 
            n.y = gv.y;
            n.x = gv.x+1;
            ghost_one_q.push(n);
            grid[gv.y][gv.x+1] = ghost_penalty;
            break;
          case 1: 
            break;
          case 2:
            n.y = gv.y;
            n.x = gv.x+1;
            ghost_one_q.push(n);
            grid[gv.y][gv.x+1] = ghost_penalty;
            break;
          case -30: 
            n.y = gv.y;
            n.x = gv.x+1;
            ghost_one_q.push(n);
            grid[gv.y][gv.x+1] = ghost_penalty;
            break;
        }
        // Left
        switch(grid[gv.y][gv.x-1]){
          case 0: 
            n.y = gv.y;
            n.x = gv.x-1;
            ghost_one_q.push(n);
            grid[gv.y][gv.x-1] = ghost_penalty;
            break;
          case 1: 
            break;
          case 2:
            n.y = gv.y;
            n.x = gv.x-1;
            ghost_one_q.push(n);
            grid[gv.y][gv.x-1] = ghost_penalty;
            break;
          case -30: 
            n.y = gv.y;
            n.x = gv.x-1;
            ghost_one_q.push(n);
            grid[gv.y][gv.x-1] = ghost_penalty;
            break;
        }
        // Top
        switch(grid[gv.y-1][gv.x]){
          case 0: 
            n.y = gv.y-1;
            n.x = gv.x;
            ghost_one_q.push(n);
            grid[gv.y-1][gv.x] = ghost_penalty;
            break;
          case 1: 
            break;
          case 2:
            n.y = gv.y-1;
            n.x = gv.x;
            ghost_one_q.push(n);
            grid[gv.y-1][gv.x] = ghost_penalty;
            break;
          case -30: 
            n.y = gv.y-1;
            n.x = gv.x;
            ghost_one_q.push(n);
            grid[gv.y-1][gv.x] = ghost_penalty;
            break;
        }
        // Bottom
        switch(grid[gv.y+1][gv.x]){
          case 0: 
            n.y = gv.y+1;
            n.x = gv.x;
            ghost_one_q.push(n);
            grid[gv.y+1][gv.x] = ghost_penalty;
            break;
          case 1: 
            break;
          case 2:
            n.y = gv.y+1;
            n.x = gv.x;
            ghost_one_q.push(n);
            grid[gv.y+1][gv.x] = ghost_penalty;
            break;
          case -30: 
            n.y = gv.y+1;
            n.x = gv.x;
            ghost_one_q.push(n);
            grid[gv.y+1][gv.x] = ghost_penalty;
            break;
        }
      }
    }
    
  }
  /*
  void BFS_pacman(int [][] grid, int _x, int _y){
    Queue q = new Queue();
    Coords c = new Coords(_x, _y);
    q.push(c);
    // Label v as discovered 
    //grid[y][x] = ;
    int levels = 0;
    while(!q.empty() && levels < 5){
      Coords v = q.pop();
      // Right 
      print(v.x, v.y, "\n");
      Coords n = new Coords(0, 0);
      switch(grid[v.y][v.x+1]){
        case 0: 
          n.y = v.y;
          n.x = v.x+1;
          q.push(n);
          grid[v.y][v.x+1] = 0;
          break;
        case 1: 
          break;
        case 2:
          n.y = v.y;
          n.x = v.x+1;
          q.push(n);
          grid[v.y][v.x+1] = 3;
          break;
          
      }
      // Left
      switch(grid[v.y][v.x-1]){
        case 0: 
          n.y = v.y;
          n.x = v.x-1;
          q.push(n);
          grid[v.y][v.x-1] = 0;
          break;
        case 1: 
          break;
        case 2:
          n.y = v.y;
          n.x = v.x-1;
          q.push(n);
          grid[v.y][v.x-1] = 3;
          break;
      }
      // Top
      switch(grid[v.y-1][v.x]){
        case 0: 
          n.y = v.y-1;
          n.x = v.x;
          q.push(n);
          grid[v.y-1][v.x] = 0;
          break;
        case 1: 
          break;
        case 2:
          n.y = v.y-1;
          n.x = v.x;
          q.push(n);
          grid[v.y-1][v.x] = 3;
          break;
      }
      // Bottom
      switch(grid[v.y+1][v.x]){
        case 0: 
          n.y = v.y+1;
          n.x = v.x;
          q.push(n);
          grid[v.y+1][v.x] = 0;
          break;
        case 1: 
          break;
        case 2:
          n.y = v.y+1;
          n.x = v.x;
          q.push(n);
          grid[v.y+1][v.x] = 3;
          break;
      }
      
      
      levels = levels + 1;
    }
    
  }

  */
  
  void display_pacmap() {
    // Render the level
    int map_rows = map.level_zero.length;    // Number of rows
    int map_columns = map.level_zero[0].length; 
    int offset_x = map_columns*w + 10;
    int offset_y = 0;

    for (int i = 0; i < map.ny; i++) {
      for (int j = 0; j < map.nx; j++) {
        //print(i, j);

        switch(PacMap[j][i]) {
        case 1: 
          fill(100, 150, 250);
          rect(offset_x + i*w, offset_y + j*w, w, w); 
          break;
        case 2: 
          fill(255, 255, 0);
          ellipse(offset_x +i*w+(w/2), offset_y + j*w+(w/2), w/4, w/4);
          break;
        case -30: 
          fill(0, 0, 255);
          ellipse(offset_x +i*w+(w/2), offset_y + j*w +(w/2), w/2, w/2);
          break;
        case 3: 
          fill(0, 255, 0);
          ellipse(offset_x + i*w+(w/2), offset_y + j*w+(w/2), w/2, w/2);
          break;   
        }
      }
    }
  }

  
  void solve(Ghost temp){
     consume();
      for(int i=1;i<5;i++){
     if( (x+i) < map.nx && map.level_zero[y][x+i]==2){
         pellets_right += map.level_zero[y][x+i];
     }
     if(x-i>map.nx && map.level_zero[y][x-i]==2){
       pellets_left += map.level_zero[y][x-i];
     }
     if(y-i<map.ny && map.level_zero[y-i][x]==2){
       pellets_up += map.level_zero[y-i][x];
     }
    if(y+i>map.ny && map.level_zero[y-i][x]==2){
       pellets_down += map.level_zero[y+i][x];
    }
    }

     pacman_location = new PVector(x,y);
     ghost_location = new PVector(temp.x,temp.y);
     difference = PVector.sub(pacman_location, ghost_location);
     Pacman_target= new PVector(-difference.x,-difference.y);
     if(difference.mag()<10){
     if (abs(Pacman_target.x) > abs(Pacman_target.y)){
        if (Pacman_target.x >= 0 && check_left()){
          prex = -1;
          prey = 0;
        } else if ( Pacman_target.x <= 0 && check_right()){
          prex = 1; 
          prey = 0;
        } 
        else if (Pacman_target.y >= 0 && check_up() ){
          prex = 0;
          prey = -1;
        } else if (Pacman_target.y<=0 && check_down() ){
          prex = 0;
          prey = 1;
        }
         else if(check_up() ){
         prex = 0;
         prey = -1;
         }
         else if(check_down()){
         prex = 0;
         prey = 1;
         }
      } else {
        if (Pacman_target.y >= 0 && check_up()){
          prex = 0;
          prey = -1;
        } else if (Pacman_target.y<=0 && check_down()){
          prex = 0;
          prey = 1;
        }
        else if (Pacman_target.x >= 0 && check_left()){
          prex = -1;
          prey = 0;
        } else if ( Pacman_target.x <= 0 && check_right() ){
          prex = 1; 
          prey = 0;
        } 
        else if(check_left()){
          prex = -1;
          prey = 0;
        }
        else if(check_right()){
          prex = 1; 
          prey = 0;
        }
      }}
 else{
    if(pellets_right>pellets_left&&pellets_right>pellets_down&&pellets_right>pellets_up){
          prex = 1; 
          prey = 0;  
    }
        if(pellets_left>pellets_right&&pellets_left>pellets_down&&pellets_left>pellets_up){
          prex = -1; 
          prey = 0;  
    }
        if(pellets_up>pellets_left&&pellets_up>pellets_down&&pellets_up>pellets_right){
          prex = 0; 
          prey = -1;  
    }
    if(pellets_down>pellets_left&&pellets_down>pellets_right&&pellets_down>pellets_up){
          prex = 0; 
          prey = 1;  
    }
 }
    if(frameCount%25==0){
      move(prex,prey);
    }
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
    text("PacMan x: " + x, 0, 830);
    text("PacMan y: " + y, 0, 860);
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


  void reset() {
    //for (Ghost g : ghosts) {
      //print("Pacman's location: ", x, y, " Ghost's location: ", g.x, g.y);
    //}
    alive = false;
    x = reset_x;
    y = reset_y;
    int[][] level_zero_reset = {
           {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
           {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
           {1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1},
           {1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1},
           {1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1},
           {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
           {1, 2, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1},
           {1, 2, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1},
           {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1},
           {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
             };
    //map.level_one = level_zero_reset;

    
    alive = false;
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

