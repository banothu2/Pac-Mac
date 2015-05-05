class QLearning{
  float Q[][];
  float alpha;
  float gamma;
  float epsilon1, epsilon2;
  float reward;
  float summed_reward;
  int nstates, state;
  int last_action;
  int ix, iy;
  
  QLearning(){
    nstates = map.nx * map.ny;
    Q = new float[nstates][4];
    alpha = 0.9;
    gamma = 1.0;
    epsilon1 = 0.1;
    epsilon2 = 0.0;
    home();
    resetQ();
  }
  
  void resetQ(){
    //Reset Q Values
    for(int s=0; s<nstates; s++){
      for(int a=0; a<4; a++){
        Q[s][a] = 0.0;
      }
    }
  }
  
  void home(){
    //Reset Q Agent
    ix = 9;
    iy = 8;
    state = ix + map.ny*iy;
    last_action = 4;
    reward = 0.0;
    summed_reward = 0.0;
  }
  
  void step(){
    int s0, s1, a0, a1;
    int fps;
    if(nRLTrials > NTEST)
      fps = 25;
    else
      fps = 1;
    //Reset if dead
    if(pacman.resetPM == true){
      nextTrial();
      pacman.resetPM = false;
    }
    
    if(frameCount%fps==0){
      //Pick and take next action
      s0 = state;
      a0 = pickAction();
      takeAction(a0);
      //Get action following one just taken
      s1 = state;
      a1 = pickAction();    //Get action and prepare to move pacman/qagent
      int ixn = ix;
      int iyn = iy;
      if (a1 == NORTH){
        iyn --;
      }
      if (a1 == SOUTH){
        iyn++;
      }
      if (a1 == EAST){
        ixn++;
      }
      if (a1 == WEST){
        ixn--;
      }
      
      //Get Reward
      float rewardn;
      if(map.level_zero_copy_RL[iy][ix] == 1)
        rewardn = -10; //WALL
      else if (map.level_zero_copy_RL[iy][ix] == 2)
        rewardn = 10; //PELLET
      else
        rewardn = -1; //NOPELLET
        
      for(Ghost g: ghosts){
        if(ixn == g.x && iyn == g.y && nRLTrials > NTEST)
          rewardn = -250; //GHOST
      }
      //Calculate Q Value
      Q[s0][a0] = Q[s0][a0] + alpha * (reward + gamma * Q[s1][a1] - Q[s0][a0]);
    }
  }
  
  int pickAction(){
    //Epislon Greedy action picking
    int action = int(random(4.0)); 
    int imax = 0;
    float max = -999.0;
    float prob = random(1.0);
    if(prob <= (1.0 - epsilon1)){
      for(int i = 0; i < 4; i++){
          if(Q[state][i] >= max){
            max = Q[state][i];
            action = i;
            imax = i;
          }
      }
    }
    else{
      action = int(random(4.0));
    }
    prob = random(1.0);
    if(prob <= (1.0 - epsilon2)){
      int ixn = ix;
      int iyn = iy;
      if (action == NORTH){
        iyn --;
      }
      if (action == SOUTH){
        iyn++;
      }
      if (action == EAST){
        ixn++;
      }
      if (action == WEST){
        ixn--;
      }
      int ixnn;
      int iynn;
      for(Ghost g: ghosts){
        if(ixn == g.x && iyn == g.y && nRLTrials > NTEST){  
          max = -999.0;
          for(int i = 0; i < 4; i++){
            ixnn = ix;
            iynn = iy;
            if (i == NORTH) iynn--;
            if (i == SOUTH) iynn++;
            if (i == EAST) ixnn++;
            if (i == WEST) ixnn--;
            if(Q[state][i] >= max && imax != i && map.level_zero_copy_RL[iynn][ixnn] != 1){
              max = Q[state][i];
              action = i;
            }
          }
        }
      }
    }
    return action;
  }
 
 void takeAction(int action) {
    last_action = action;
    int xold = ix;
    int yold = iy;
    int xmove = 0;
    int ymove = 0;
    //Get action and prepare to move pacman/qagent
    if (action == NORTH){
      iy--;
      ymove = -1;
    }
    if (action == SOUTH){
      iy++;
      ymove = 1;
    }
    if (action == EAST){
      ix++;
      xmove = 1;
    }
    if (action == WEST){
      ix--; 
      xmove = -1;
    }
    
    //Get Reward
    if(map.level_zero_copy_RL[iy][ix] == 1)
      reward = -50; //WALL
    else if (map.level_zero_copy_RL[iy][ix] == 2)
      reward = 50; //PELLET
    else
      reward = -1; //NOPELLET
      
    for(Ghost g: ghosts){
      if(ix == g.x && iy == g.y && nRLTrials > NTEST)
        reward = -75; //GHOST
    }
    summed_reward += reward;
    
    // if pacman/qagent runs into wall, move back
    if (map.level_zero_copy[iy][ix] == 1) {
      ix = xold;
      iy = yold;
      xmove = 0;
      ymove = 0;
    }
    
    //Update state and pacman
    state = ix + map.ny*iy;
    pacman.update(xmove, ymove);
  }   
}

