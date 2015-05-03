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
      if(i == 0){
        BFS_p_n_g(PacMap, x, y, g);
      }
      i++;
    } 
    

    //BFS_p_n_g(PacMap, x, y, ghosts);
    //BFS_pacman(PacMap, x, y);
    // Find where the Ghosts are in the map and mark it 

    // Find where pac man is in the map and mark it
    display_pacmap();
  }
  
  void BFS_p_n_g(int [][] grid, int _x, int _y, Ghost g){
    boolean death = false;
    Queue pac_q = new Queue();
    Queue ghost_one_q = new Queue();
    
    Coords c = new Coords(_x, _y);
    Coords g_c = new Coords(g.x,g.y);
    
    pac_q.push(c);
    ghost_one_q.push(g_c);
    // Label v as discovered 
    //grid[y][x] = ;
    int levels = 0;
    while(!pac_q.empty() && !ghost_one_q.empty() && levels < 4*4 && !death){
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
          grid[v.y][v.x+1] = 0;
          break;
        case 1: 
          break;
        case 2:
          n.y = v.y;
          n.x = v.x+1;
          pac_q.push(n);
          grid[v.y][v.x+1] = 3;
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
          grid[v.y][v.x-1] = 0;
          break;
        case 1: 
          break;
        case 2:
          n.y = v.y;
          n.x = v.x-1;
          pac_q.push(n);
          grid[v.y][v.x-1] = 3;
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
          grid[v.y-1][v.x] = 0;
          break;
        case 1: 
          break;
        case 2:
          n.y = v.y-1;
          n.x = v.x;
          pac_q.push(n);
          grid[v.y-1][v.x] = 3;
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
          grid[v.y+1][v.x] = 0;
          break;
        case 1: 
          break;
        case 2:
          n.y = v.y+1;
          n.x = v.x;
          pac_q.push(n);
          grid[v.y+1][v.x] = 3;
          break;
        case -10:
          death = true;
          break;
      }
      
      
      
      // Top 
      switch(grid[gv.y][gv.x+1]){
        case 0: 
          n.y = gv.y;
          n.x = gv.x+1;
          ghost_one_q.push(n);
          grid[gv.y][gv.x+1] = 0;
          break;
        case 1: 
          break;
        case 2:
          n.y = gv.y;
          n.x = gv.x+1;
          ghost_one_q.push(n);
          grid[gv.y][gv.x+1] = -10;
          break;
          
      }
      // Left
      switch(grid[gv.y][gv.x-1]){
        case 0: 
          n.y = gv.y;
          n.x = gv.x-1;
          ghost_one_q.push(n);
          grid[gv.y][gv.x-1] = 0;
          break;
        case 1: 
          break;
        case 2:
          n.y = gv.y;
          n.x = gv.x-1;
          ghost_one_q.push(n);
          grid[gv.y][gv.x-1] = -10;
          break;
      }
      // Top
      switch(grid[gv.y-1][gv.x]){
        case 0: 
          n.y = gv.y-1;
          n.x = gv.x;
          ghost_one_q.push(n);
          grid[gv.y-1][gv.x] = 0;
          break;
        case 1: 
          break;
        case 2:
          n.y = gv.y-1;
          n.x = gv.x;
          ghost_one_q.push(n);
          grid[gv.y-1][gv.x] = -10;
          break;
      }
      // Bottom
      switch(grid[gv.y+1][gv.x]){
        case 0: 
          n.y = gv.y+1;
          n.x = gv.x;
          ghost_one_q.push(n);
          grid[gv.y+1][gv.x] = 0;
          break;
        case 1: 
          break;
        case 2:
          n.y = gv.y+1;
          n.x = gv.x;
          ghost_one_q.push(n);
          grid[gv.y+1][gv.x] = -10;
          break;
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
    int offset_x = map_rows*w;
    int offset_y = map_columns*w;

    for (int i = 0; i < map.ny; i++) {
      for (int j = 0; j < map.nx; j++) {
        //print(i, j);

        switch(PacMap[j][i]) {
        case 1: 
          fill(100, 150, 250);
          ;
          rect(offset_x + i*w, offset_y + j*w, w, w); 
          break;
        case 2: 
          fill(255, 255, 0);
          ellipse(offset_x +i*w+(w/2), offset_y + j*w+(w/2), w/4, w/4);
          break;
        case -10: 
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
}  

