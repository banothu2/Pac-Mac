class QLearning{
  float Q[][];
  float alpha;
  float gamma;
  float epsilon;
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
    epsilon = 0.1;
    home();
    resetQ();
  }
  
  void resetQ(){
    for(int s=0; s<nstates; s++){
      for(int a=0; a<4; a++){
        Q[s][a] = 0.0;
      }
    }
  }
  
  void home(){
    ix = 9;
    iy = 8;
    state = ix + map.ny*iy;
    last_action = 4;
    reward = 0.0;
    summed_reward = 0.0;
  }
  
  void step(){
    int s0, s1, a0, a1;
    if(pacman.alive != true){
      //nextTrial();
      pacman.alive = true;
    }
    
  text("ix: " + QAgent.ix, 0, 830);
  text("iy: " + QAgent.iy, 0, 860);
    
    if(frameCount%5==0){
      s0 = state;
      a0 = pickAction();
      takeAction(a0);
      s1 = state;
      a1 = pickAction();
      Q[s0][a0] = Q[s0][a0] + alpha * (reward + gamma * Q[s1][a1] - Q[s0][a0]);
    }
  }
  
  int pickAction(){
    int action = int(random(4.0)); 
    float max = -999.0;
    float prob = random(1.0);
    if(prob <= (1.0 - epsilon)){
      for(int i = 0; i < 4; i++){
        //for(int j = 0; j < nstates; j++){
          if(Q[state][i] >= max){
            max = Q[state][i];
            action = i;
          }
        //}
      }
    }
    else
      action = int(random(4.0));
    return action;
  }
 
 void takeAction(int action) {
    last_action = action;
    int xold = ix;
    int yold = iy;
    int xmove = 0;
    int ymove = 0;
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
    reward = map.level_zero_reward[iy][ix];
    for(Ghost g: ghosts){
      if(ix == g.x && iy == g.y)
        reward = -250;
    }
    summed_reward += reward;
    // if bot runs into wall, move bot back
    if (map.level_zero[iy][ix] == 1) {
      ix = xold;
      iy = yold;
      xmove = 0;
      ymove = 0;
    }
    state = ix + map.ny*iy;
    pacman.update(xmove, ymove);
  } 
  
  
  
  
  
  
  
}

