/*
  Project: Pac-Man 
    Building a Pac-Man playing bot using reinforced learning.
    
  Authors:
    Kirthi Banothu
    Edgar Basto
    Michael 
    
  size: 28 tiles wide x 31 tiles high
    
*/

Map map;

void setup(){
  map = new Map();
  size(700, 900);
}

void draw(){
  background(0);
  map.display();
}




