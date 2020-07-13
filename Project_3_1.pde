import controlP5.*;

ControlP5 control;

//Universal Plane Dimensions
int d = 30;

//Terrain
Plane t1, t2, t3;
Plane[] Terrain = {t1, t2, t3};
Plane terrain;

//Water
Plane w1, w2, w3;
Plane[] Water = {w1, w2, w3};
Plane water;

//Animation Setup - Clocks
float w1XC, w1YC, w2XC, w2YC, w3XC, w3YC;
float[] Clocks = {w1XC, w1YC, w2XC, w2YC, w3XC, w3YC};
//TickSpeeds
float w1XT, w1YT, w2XT, w2YT, w3XT, w3YT;
float[] tickSpeed;

//UI Setup
//Terrain Layers: HR = Height Range, NI = Noise Increment
int t1HR = 0;
float t1NI = 0.01;
int t2HR = 0;
float t2NI = 0.01;
int t3HR = 0;
float t3NI = 0.01;

//Water Layers: HR = Height Range, NI = Noise Increment
int w1HR = 0;
float w1NI = 0.01;
int w2HR = 0;
float w2NI = 0.01;
int w3HR = 0;
float w3NI = 0.01;

//View Options
int yTranslate;
int zTranslate;
float yRotation;

int camView = 0;

Button view1, view2, view3;
CheckBox tLayers, wLayers, StrokeVis;
Slider terrainR, terrainG, terrainB, terrainAlpha, yTSlider, zTSlider, yRSlider;

//Noise Seed
float nS = 0;
Textfield nSInput;
Button nSButton;

void setup() {
  control = new ControlP5(this);
  size(600, 800, P3D);
  
  //Display Planes Setup
  terrain = new Plane(d, d, width/(d-1));
  water = new Plane(d, d, width/(d-1));
  
  //UI setup
  //Terrain
  //Layer1
  control.addSlider("t1HR")
                .setPosition(10, 10)
                .setRange(0, 300);
  control.addSlider("t1NI")
                .setPosition(10, 20)
                .setRange(0.001, 0.05);
  //Layer2
  control.addSlider("t2HR")
                .setPosition(10, 40)
                .setRange(0, 100);
  control.addSlider("t2NI")
                .setPosition(10, 50)
                .setRange(0.01, 0.5);
  //Layer3
  control.addSlider("t3HR")
                .setPosition(10, 70)
                .setRange(0, 50);
  control.addSlider("t3NI")
                .setPosition(10, 80)
                .setRange(0.01, 0.7);        
  //Toggle Layers
  tLayers = control.addCheckBox("tLayers")
                .setPosition(10, 100)
                .setColorForeground(color(120))
                .setColorActive(color(255))
                .setColorLabel(color(255))
                .setSize(10, 10)
                .setItemsPerRow(1)
                .setSpacingRow(10)
                .addItem("t 1", 1)
                .addItem("t 2", 2)
                .addItem("t 3", 3);
                
  //Layer 1 defaults as being active
  tLayers.activate(0);
                
  //Display Options
  //Camera Views
  view1 = control.addButton("Default")
                       .setPosition(width - 110, 80)
                       .setSize(53, 10);
  view2 = control.addButton("Rotation")
                       .setPosition(width - 110, 100)
                       .setSize(53, 10);
  view3 = control.addButton("BirdsEye")
                       .setPosition(width - 110, 120)
                       .setSize(53, 10);
  
  //Grid Dimensions
  control.addSlider("d")
                .setRange(25, 300)
                .setPosition(10, 160);
                
  //Y, Z Translation - controls how close, high the Map looks on the screen
  yTranslate = width;
  yTSlider = control.addSlider("yTranslate")
                .setRange(0, 2*height)
                .setPosition(width - 270, 10);
  zTranslate = width;
  zTSlider = control.addSlider("zTranslate")
                .setRange(0, 500)
                .setPosition(width - 270, 30)
                .setValue(200);
  
  //Y Rotation - controlls viewing angle
  yRSlider = control.addSlider("yRotation")
                .setPosition(width - 270, 50)
                .setRange(0, 2*PI);
   
  //Noise Selection
  nSInput = control.addTextfield("nSInput")
                .setSize(100, 15)
                .setPosition(10, 180)
                .setInputFilter(ControlP5.FLOAT);;
  nSButton = control.addButton("Seed")
                .setSize(100, 20)
                .setPosition(10, 195);
  
  //User Customization
  //Terrain Color, Alpha
  terrainR = control.addSlider("R")
                  .setPosition(width - 110, 10)
                  .setRange(0, 255)
                  .setValue(30);
  terrainG = control.addSlider("G")
                  .setPosition(width - 110, 20)
                  .setRange(0, 255)
                  .setValue(180);
  terrainB = control.addSlider("B")
                  .setPosition(width - 110, 30)
                  .setRange(0, 255)
                  .setValue(110);
  terrainAlpha = control.addSlider("α")
                  .setPosition(width - 110, 40)
                  .setRange(0, 255)
                  .setValue(255);
                  
                
  StrokeVis = control.addCheckBox("StrokeVis")
                .setPosition(width - 110, 60)
                .setColorForeground(color(120))
                .setColorActive(color(255))
                .setColorLabel(color(255))
                .setSize(10, 10)
                .addItem("NoStroke", 0);
                
                
  //Water Settings
  //Layer1
  control.addSlider("w1HR")
                .setPosition(150, 10)
                .setRange(0, 300);
  control.addSlider("w1NI")
                .setPosition(150, 20)
                .setRange(0.001, 0.05);
  
  //Wave 'Speed', w1XT = Wave 1 X Tick
  control.addSlider("w1XT")
                .setPosition(150, 30)
                .setSize(49, 9)
                .setRange(-0.01, 0.01);
  control.addSlider("w1YT")
                .setPosition(200, 30)
                .setSize(49, 9)
                .setRange(-0.01, 0.01);
  //Layer2
  control.addSlider("w2HR")
                .setPosition(150, 40)
                .setRange(0, 100);
  control.addSlider("w2NI")
                .setPosition(150, 50)
                .setRange(0.01, 0.5);
                
  control.addSlider("w2XT")
                .setPosition(150, 60)
                .setSize(49, 9)
                .setRange(-0.01, 0.01);
  control.addSlider("w2YT")
                .setPosition(200, 60)
                .setSize(49, 9)
                .setRange(-0.01, 0.01);
  //Layer3
  control.addSlider("w3HR")
                .setPosition(150, 70)
                .setRange(0, 50);
  control.addSlider("w3NI")
                .setPosition(150, 80)
                .setRange(0.01, 0.7);
  
  control.addSlider("w3XT")
                .setPosition(150, 90)
                .setSize(49, 9)
                .setRange(-0.01, 0.01);
  control.addSlider("w3YT")
                .setPosition(200, 90)
                .setSize(49, 9)
                .setRange(-0.01, 0.01);
                
  //Toggle Layers
  wLayers = control.addCheckBox("wLayers")
                .setPosition(150, 100)
                .setColorForeground(color(120))
                .setColorActive(color(255))
                .setColorLabel(color(255))
                .setSize(10, 10)
                .setItemsPerRow(1)
                .setSpacingRow(10)
                .addItem("w 1", 1)
                .addItem("w 2", 2)
                .addItem("w 3", 3);
                
}

void draw() {
  //Stage Setup
  background(color(30, 60, 120));
  tickSpeed = new float[]{w1XT, w1YT, w2XT, w2YT, w3XT, w3YT};
  
  //Lighting Setup
  ambientLight(200, 200, 200);
  directionalLight(100, 100, 100, -1, 1, 1);
  
  //Terrain/Water Calibrations
  terrainSetup();
  waterSetup();
  
  //Display Terrain
  pushMatrix();
  
  //Applies Camera Settings
  cameraView();
  
  //Display function
  color wColor = color(30, 180, 240, 200);
  displayPlane(Water, water, wLayers, wColor);
  color tColor = color(terrainR.getValue(), terrainG.getValue(), terrainB.getValue(), terrainAlpha.getValue());
  displayPlane(Terrain, terrain, tLayers, tColor);
  
  popMatrix();
}

void terrainSetup() {
  //Terrain Layer Creation
  Terrain[0] = new Plane(d, d, width/(d-1));
  Terrain[1] = new Plane(d, d, width/(d-1));
  Terrain[2] = new Plane(d, d, width/(d-1));
  
  //Terrain Noise Mapping - TEMP
  Terrain[0].mapNoise(-t1HR/2, t1HR/2, nS, nS, t1NI);
  Terrain[1].mapNoise(-t2HR, t2HR, nS + 1, nS + 1, t2NI);
  Terrain[2].mapNoise(-t3HR, t3HR, nS + 2, nS + 2, t3NI);
}

void waterSetup() {
  //Water Layer Creation
  Water[0] = new Plane(d, d, width/(d-1));
  Water[1] = new Plane(d, d, width/(d-1));
  Water[2] = new Plane(d, d, width/(d-1));
  
  //Water IDLE TEMP
  //Water[0].mapNoise(0, w1HR, nS, nS, w1NI);
  //Water[1].mapNoise(-w2HR, w2HR, nS + 1, nS + 1, w2NI);
  //Water[2].mapNoise(-w3HR, w3HR, nS + 2, nS + 2, w3NI);
  
  //Water Animation - TEMP
  Water[0].animate(true, w1HR, true, -w1HR/2, w1HR/2, nS + 2, nS + 2, w1NI, 0, 1);
  Water[1].animate(true, w2HR, true, -w2HR, w2HR, nS + 2, nS + 2, w2NI,  2, 3);
  Water[2].animate(true, w3HR, true, -w3HR, w3HR, nS + 2, nS + 2, w3NI,  4, 5);
}


//Checkbox Layering of Planes
void displayPlane(Plane[] P, Plane p, CheckBox layers, color col) {
  //Used to hide if no layers are active
  boolean visible = false;
  
  //Layers Planes
  p = new Plane(d, d, width/(d-1));
  for (int i = 0; i < layers.getArrayValue().length; i++) {
    int n = (int)layers.getArrayValue()[i];
    if (n==1) {
      visible = true;
      p.layer(P[i]);
    }
  }
  //Checks NoStroke checkbox, if activated removes stroke
  stroke(0);
  if (StrokeVis.getArrayValue()[0] == 1) {
    noStroke();
  }
  if (visible == true) {
    //Displays Terrain
    p.display(col);
    //Add 'Screens'
    p.screen(0, false);
    p.screen(0, true);
    p.screen(p.cols - 1, false);
    p.screen(p.rows - 1, true);
  }
}


//Set the new input as the seed - TERRAIN
void Seed() {
  nS = float(nSInput.getText());
}







//Camera Views
void cameraView() {
  //Default View
  if (camView == 0){
    //Show Transformation Sliders
    yRSlider.hide();
    yTSlider.show();
    zTSlider.show();
    
    //XRotation (Default)
    translate(0, height);
    rotateX(PI/3);
    translate(0, -yTranslate, zTranslate);
  
  //Birds Eye View
  } else if (camView == 1) {
    //Change Lighting to Front Facing
    directionalLight(100, 100, 100, -1, 1, -1);
    
    //Hide Transformation Sliders
    yRSlider.hide();
    yTSlider.hide();
    zTSlider.show();
    
    float yTranslate = height - (terrain.rows * terrain.scale);
    float xTranslate = (width - (terrain.cols * terrain.scale)) / 2;
    translate(xTranslate, yTranslate, map(zTranslate, 0, width, -width, width));
    
  //Rotation View
  } else {
    //Show Transformation Sliders
    yRSlider.show();
    yTSlider.show();
    zTSlider.show();
    
    //YRotation (Custom)
    int depth = yTranslate - (width/2);
    float terrainWidth = terrain.cols*terrain.scale;
    translate(terrainWidth/2, 0, -depth);
    rotateY(yRotation);
    translate(-terrainWidth/2, 0, depth);
    
    //XRotation (Default)
    translate(0, height);
    rotateX(PI/2);
    translate(0, -yTranslate, zTranslate);
  }
}

//Camera Buttons
void Default() {
  camView = 0;
}
void Rotation() {
  camView = 2;
}
void BirdsEye() {
  camView = 1;
}
