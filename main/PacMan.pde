class PacMan {
  int x;
  int y; 
  int r = 20; 
  int w;                      
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

  int last_direction = 0; 
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
  int death_penalty = -1000;
  int wall_penalty = -1000;
  int bfs_pacman_foresight = 10;
  int bfs_ghost_foresight = 10;
  
  PacMan(int _x, int _y, int _w) {
    x = _x;
    y = _y; // 23
    w = _w;
    score = -1;
    alive = true;
    consume();
    reset_x = _x;
    reset_y = _y;
    PacMap = map.level_zero_copy;
  }
  
  void update(int _x, int _y) {
    consume();
    move(_x, _y);
  }

  void find_path() {
    // Copy values from current map over to pacmap 
    for (int i = 0; i < map.ny; i++) {
      for (int j = 0; j < map.nx; j++) {
        int val =  map.level_one[j][i];
        PacMap[j][i] = val;
      }
    }
    
    // Perform BFS algo to find scope paths for Pacman and Ghosts 
    int i = 0;
    for (Ghost g : ghosts) {
      // Set current ghost location to penalty
      PacMap[g.y][g.x] = ghost_penalty;
      // For all but the last ghost, create their BFS stuff seperately 
      if(i < NGHOSTS - 1){
        BFS_ghost(PacMap, g);
      } else {
        BFS_p_n_g(PacMap, x, y, g);
      }
      i++;
    } 
    
    // Update at every 25th cycle. 
    if(frameCount % 25 == 0){
      
      memo[y][x] = 1;
      ValueAndDirection best_dir = new ValueAndDirection(0, 0);
      best_dir = pick_direction(x, y, 0, 0);
      memo[y][x] = 0;
      
      //print("Best value: ", best_dir.val);
      /*
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
          update(-1,  0);
          break;
        case 1:
          update( 1,  0);
          break;
        case 2:
          update( 0, -1);
          break; 
        case 3: 
          update( 0,  1);
          break;  
      }
    }
    
    // Find where pac man is in the map and mark it
    display_pacmap();
  }
  
  ValueAndDirection pick_direction(int _x, int _y, int _prev, int _depth){
    // Need to try all 4 directions 
    // Need to return best value and direction pair.    
    int num_directions = 4;
    float[] cardinals = {wall_penalty, wall_penalty, wall_penalty, wall_penalty};
    // LEFT - grid[v.y][v.x-1]
    int[] x_mods = {-1, 1, 0, 0};
    int[] y_mods = {0, 0, -1, 1};
    //if(_depth < 5){
      for(int i = 0; i < num_directions; i++){
        if( (PacMap[_y + y_mods[i]][_x + x_mods[i]] == pellet_reward || PacMap[_y + y_mods[i]][_x + x_mods[i]] == ghost_penalty || PacMap[_y + y_mods[i]][_x + x_mods[i]] == empty_square_reward) && memo[_y + y_mods[i]][_x + x_mods[i]] == 0 ){
          // Mark as seen   
          memo[_y + y_mods[i]][_x + x_mods[i]] = 1;
          _depth = _depth + 1;
          ValueAndDirection recurse = new ValueAndDirection(0, 0);
          recurse = pick_direction(_x + x_mods[i], _y + y_mods[i], PacMap[_y + y_mods[i]][_x + x_mods[i]], _depth);
          if(PacMap[_y+y_mods[i]][_x+x_mods[i]] == empty_square_reward){
            cardinals[i] = 1 + (recurse.val)*(1.0/(_depth*_depth));
          } else {
            cardinals[i] = PacMap[_y + y_mods[i]][_x + x_mods[i]] + (recurse.val)*(1.0/(_depth*_depth));
          }
          // Unmark spot
          memo[_y + y_mods[i]][_x + x_mods[i]] = 0;
        }
      }
    //}
     
    float max = cardinals[last_direction]; 
    int dir = last_direction;
    for(int i = 1; i < 4; i++){
      if(cardinals[i] > max){
        max = cardinals[i];
        dir = i;  
      }
    }
    ValueAndDirection ret = new ValueAndDirection(max, dir);
    return ret;
  }
  
  void BFS_p_n_g(int [][] grid, int _x, int _y, Ghost g){
    int num_directions = 4;

    boolean death = false;
    Queue pac_q = new Queue();
    Queue ghost_one_q = new Queue();
    
    Coords c = new Coords(_x, _y);
    Coords g_c = new Coords(g.x,g.y);
    
    pac_q.push(c);
    ghost_one_q.push(g_c);
    grid[g_c.y][g_c.x] = death_penalty;
    int levels = 0;
    
    
    while(!pac_q.empty() && !ghost_one_q.empty() && (levels < bfs_pacman_foresight + score) && !death){
      levels = levels + 1;

      Coords v = pac_q.pop();
      Coords n = new Coords(0, 0);
      
      int[] x_mods = {1, -1, 0, 0};
      int[] y_mods = {0, 0, -1, 1};
      
      for(int i = 0; i < num_directions; i++){
        n.y = v.y+y_mods[i];
        n.x = v.x+x_mods[i];
        switch(grid[v.y+y_mods[i]][v.x+x_mods[i]]){
          case 0: 
            pac_q.push(n);
            grid[v.y+y_mods[i]][v.x+x_mods[i]] = empty_square_reward;
            break;
          case 1: 
            break;
          case 2:
            pac_q.push(n);
            grid[v.y+y_mods[i]][v.x+x_mods[i]] = pellet_reward;
            break;
          case -10:
            //death = true;
            break;
        }     
      }
      
      Coords gv = ghost_one_q.pop();
      Coords n2 = new Coords(0, 0);
      if(levels < bfs_ghost_foresight){
        for(int i = 0; i < num_directions; i++){
          n2.y = gv.y+y_mods[i];
          n2.x = gv.x+x_mods[i];
          switch(grid[gv.y+y_mods[i]][gv.x+x_mods[i]]){
            case 0: 
              ghost_one_q.push(n2);
              grid[gv.y+y_mods[i]][gv.x+x_mods[i]] = ghost_penalty;
              break;
            case 1: 
              break;
            case 2:
              ghost_one_q.push(n2);
              grid[gv.y+y_mods[i]][gv.x+x_mods[i]] = ghost_penalty;
              break;
            case -30: 
              ghost_one_q.push(n2);
              grid[gv.y+y_mods[i]][gv.x+x_mods[i]] = ghost_penalty;
              break;
          }
        }
      }
    }
    
  }
  
  void BFS_ghost(int [][] grid, Ghost g){
    int num_directions = 4;
    boolean death = false;
    Queue ghost_one_q = new Queue();
    Coords g_c = new Coords(g.x,g.y);
    ghost_one_q.push(g_c);
    grid[g_c.y][g_c.x] = death_penalty;
    //grid[g_c.y][g_c.x] = ghost_penalty;
    int levels = 0;
    int[] x_mods = {1, -1, 0, 0};
    int[] y_mods = {0, 0, -1, 1};
    while(!ghost_one_q.empty() && levels < bfs_ghost_foresight && !death){
      levels = levels + 1;
      Coords gv = ghost_one_q.pop();
      Coords n = new Coords(0, 0);      
      
      for(int i = 0; i < num_directions; i++){
        n.y = gv.y+y_mods[i];
        n.x = gv.x+x_mods[i];
        if(!(n.y == pacman.y && n.x == pacman.x)){
          switch(grid[gv.y+y_mods[i]][gv.x+x_mods[i]]){
            case 0: 
              ghost_one_q.push(n);
              grid[gv.y+y_mods[i]][gv.x+x_mods[i]] = ghost_penalty;
              break;
            case 1: 
              break;
            case 2:
              ghost_one_q.push(n);
              grid[gv.y+y_mods[i]][gv.x+x_mods[i]] = ghost_penalty;
              break;
            case -30: 
              ghost_one_q.push(n);
              grid[gv.y+y_mods[i]][gv.x+x_mods[i]] = ghost_penalty;
              break;
          }
        }
      }
    }
    
  }
  
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
          stroke(0, 255, 0);
          rect(offset_x + i*w, offset_y + j*w, w, w);
          noStroke(); 
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
        case -1000:
          fill(255, 255, 255);
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
    if(frameCount % 25 == 0){
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
    ellipse(x*w+(w/2) + transition_x, y*w+(w/2) + transition_y, r, r);
  }


  void reset() {
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
    map.level_one = level_zero_reset;
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

