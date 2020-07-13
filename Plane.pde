class Plane {
  int cols, rows;
  float scale;
  float[][] grid;
  boolean animated = false;
  
  Plane(int cols_, int rows_, float scale_) {
    this.cols = cols_;
    this.rows = rows_;
    this.scale = scale_;
    this.grid = new float[cols][rows];
  }
  
  void genGrid() {
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        grid[x][y] = 0;
      }
    }
  }
  
  void mapNoise(float minZ, float maxZ, float XOff, float YOff, float inc) {
    float xOff = XOff;
    for (int x = 0; x < cols; x++) {
      float yOff = YOff;
      for (int y = 0; y < rows; y++) {
        grid[x][y] = map(Noise(xOff, yOff), 0, 1, minZ, maxZ);
        yOff += inc;
      }
      xOff += inc;
    }
  }
  
  //Temporary Animate function
  void animate(boolean sin, int sinRange, boolean noise, float minZ, float maxZ, float XOff, float YOff, float inc, int xClock, int yClock) {
    
    Clocks[xClock] += tickSpeed[xClock];
    Clocks[yClock] += tickSpeed[yClock];

    if (sin == true) {
      for (int x = 0; x < cols; x++) {
        for (int y = 0; y < rows; y++) {
          grid[x][y] += sin((x + y) + Clocks[xClock]*5)*sinRange;
        }
      }
    }
    
    if (noise == true) {
      mapNoise(minZ, maxZ, XOff + Clocks[xClock], YOff + Clocks[yClock], inc);
    }
  }
  
  void layer(Plane plane2) {
    if (this.cols != plane2.cols || this.rows != plane2.rows) {
      return;
    }
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        grid[x][y] += plane2.grid[x][y];
      }
    }
  }
  
  void screen(int j, boolean axis) {
    float scl = this.scale;
    noStroke();
    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < cols; i++) {
       if (axis == true) {
         vertex(i*scl, j*scl, grid[i][j]);
         //vertex(i*scl, j*scl, 150);
         vertex(i*scl, j*scl, -100);
       } else {
         vertex(j*scl, i*scl, grid[j][i]);
         //vertex(j*scl, i*scl, 150);
         vertex(j*scl, i*scl, -100);
       }
    }
    endShape();
  }
  
  void display(color col) {
    fill(col);
    float scl = this.scale;
    for (int x = 0; x < this.cols - 1; x++) {
      beginShape(TRIANGLE_STRIP);
      for (int y = 0; y < this.rows; y++) {
         vertex(x*scl, y*scl, grid[x][y]);
         vertex((x+1)*scl, y*scl, grid[x+1][y]);
      }
      endShape();
    }
  }
}
