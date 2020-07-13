class Vector{
  float[] start;
  float[] end;
  float x, y;
  float[][] directions = {  {0, 1},
                            {1, 0},
                            {0, -1},
                            {-1, 0},
                            {-1, -1},
                            {-1, 1},
                            {1, 1},
                            {1, -1}  };
  //No gradient at this point in development
  
  Vector(float[] start_, float[] end_){
    this.start = start_;
    this.end = end_;
    //Needs this.end == null exception
    this.x = end[0] - start[0];
    this.y = end[1] - start[1];

  }
  
  void update() {
    x = end[0] - start[0];
    y = end[1] - start[1];
  }
  
  void randDir(float offset) {
    //i calculation formula has not been added yet
    int i = 0;
    this.end[0] = this.start[0] + directions[i][0];
    this.end[1] = this.start[1] + directions[i][1];
    this.update();
  }
  
}
