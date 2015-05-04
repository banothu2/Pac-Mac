
class Queue {
  private Coords first;
  private Coords last;
  private int count;
 
  Queue() {
  }
 
  boolean empty() {
    return count == 0;
  }
 
  void push(Coords c) {
    Coords e = new Coords(c.x, c.y);
    if (this.first == null) {
      this.first = e;
    }
    if (this.last != null) {
      this.last.next = e;
    }
    this.last = e;
    this.count++;
  }
 
  Coords pop() throws ArrayIndexOutOfBoundsException {
    if (count == 0) {
      throw new ArrayIndexOutOfBoundsException("pop on empty queue");
    }
    int x = this.first.x;
    int y = this.first.y;
    this.first = this.first.next;
    this.count--;
    Coords out = new Coords(x, y);
    return out;
  }
}

class Coords {
  int x;
  int y;
  Coords next;
 
  Coords(int _x, int _y) {
    this.x = _x;
    this.y = _y;
  }
}


class ValueAndDirection{
  float val; 
  int direction; 
  // 0 - LEFT, 1 - RIGHT, 2 - UP, 3 - DOWN
  ValueAndDirection(float _val, int _direction){
    this.val = _val;
    this.direction = _direction;
  }
  
}
