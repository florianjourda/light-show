/**
 * This class represents a hand with its x,y,z position that was
 * detected by the kinect
 */

import SimpleOpenNI.*;

String lastGesture = "";

class DeviceKinect {
  
  // library connecting to the kinect. If it is not avalaible,
  // we need to generate mock kinect data
  SimpleOpenNI simpleOpenNI;
  
  // used for lookup in 
  Map<String, KinectHand> handsById;
  // used for iteration for draw() in onUpdateHands
  Collection<KinectHand> hands;
  
  KinectHand leftHand;
  KinectHand rightHand;
  
  DeviceKinect(PApplet pApplet) {  
    this.handsById = new HashMap<String, KinectHand>();
    this.hands = this.handsById.values();
         
    boolean kinectShouldBeConnected = false;//
    if (kinectShouldBeConnected)
    {
      // Set up the kinect
      try { 
        this.simpleOpenNI = new SimpleOpenNI(pApplet);
      } catch(UnsatisfiedLinkError e) {
        // if the kinect is not connected
        println("Kinect not available");
      }
    }
  }
  
  void setup() {
    if (this.simpleOpenNI != null)
    {
      this.simpleOpenNI.setMirror(true);
      
      // enable depthMap generation
      this.simpleOpenNI.enableDepth();
      // enable ir generation
      this.simpleOpenNI.enableRGB();
      size(context.depthWidth() + context.rgbWidth() + 10, context.rgbHeight()); 
      
      // enable hands + gesture generation
      this.simpleOpenNI.enableGesture();
      this.simpleOpenNI.enableHands();
      
      // add focus gestures  / here i do have some problems on the mac, i only recognize raiseHand ? Maybe cpu performance ?
      this.simpleOpenNI.addGesture("Wave");
      this.simpleOpenNI.addGesture("Click");
      this.simpleOpenNI.addGesture("RaiseHand");
      
      // set how smooth the hand capturing should be
      //this.simpleOpenNI.setSmoothingHands(.5);
    } else {
      this.leftHand = new KinectHand(1, new PVector());
      this.rightHand = new KinectHand(2, new PVector());
    }
  }
  
  void update() {
    // ask new kinect input data to the kinect library
    if (this.simpleOpenNI != null) {
      this.simpleOpenNI.update();
    } else {
        
    }
  }
   
  /**
   * Draw graphics showing where the hands are
   */  
  void draw() {
    //needs to be after ledWall.draw()
    for (Iterator iter = this.hands.iterator(); iter.hasNext();) {
      KinectHand kinectHand = (KinectHand) iter.next();
      kinectHand.draw(ledWall.centerX, ledWall.centerY);
    }
   //image(context.depthImage(),0,0);
  }
}

class KinectHand
{
  int id;
  PVector pos;
  
  KinectHand(int id, PVector pos) {
    this.id = id;
    this.pos = pos;
    println("New " + this);
    
    kinect.handsById.put(Integer.toString(this.id), this);
    kinect.hands = kinect.handsById.values();
    println(kinect.handsById);
    
    // @TODO(florian): really track hands
    if (kinect.leftHand == null) {
      println("Found left hand");
      kinect.leftHand = this;
    } else if (kinect.rightHand == null) {
      println("Found right hand");
      kinect.rightHand = this;
    }
  }
   
  void destroy() {
    println("Destroyed " + this);
    
    kinect.handsById.remove(Integer.toString(this.id));
    kinect.hands = kinect.handsById.values();
    println(kinect.handsById);
    
    // @TODO(florian): really track hands
    if (kinect.leftHand == this) {
      println("Lost left hand");
      kinect.leftHand = null;
    } else if (kinect.rightHand == this){
      println("Lost right hand");
      kinect.rightHand = null;
    }
  }
  
  String toString() {
    return "KinectHand with id " + this.id + " and pos " + this.pos;  
  }
  
  /**
   * Draw graphics
   */
  void draw(int centerX, int centerY) {
    //println("Draw " + this);
    stroke(255);
    fill(50);
    int diameter = 10;
    ellipse(centerX + this.pos.x, centerY - this.pos.y, diameter, diameter); 
  }
}

/******************/
/* Hand events    */
/******************/
void onCreateHands(int handId, PVector pos, float time)
{
  //println("onCreateHands - handId: " + handId + ", pos: " + pos + ", time:" + time);
  KinectHand kinectHand = new KinectHand(handId, pos);
}

void onUpdateHands(int handId, PVector pos, float time)
{
  //println("onUpdateHandsCb - handId: " + handId + ", pos: " + pos + ", time:" + time);
  KinectHand kinectHand = kinect.handsById.get(Integer.toString(handId));
  kinectHand.pos = pos;
}

void onDestroyHands(int handId, float time)
{
  //println("onDestroyHandsCb - handId: " + handId + ", time:" + time);
  KinectHand kinectHand = kinect.handsById.get(Integer.toString(handId));
  kinectHand.destroy();
  
  kinect.simpleOpenNI.addGesture(lastGesture);
}

/******************/
/* Gesture events */
/******************/
void onRecognizeGesture(String strGesture, PVector idPos, PVector endPos)
{
  //println("onRecognizeGesture - strGesture: " + strGesture + ", idPos: " + idPos + ", endPos:" + endPos);
  
  lastGesture = strGesture;
  kinect.simpleOpenNI.removeGesture(strGesture);
  kinect.simpleOpenNI.startTrackingHands(endPos);
}

void onProgressGesture(String strGesture, PVector pos, float progress)
{
  //println("onProgressGesture - strGesture: " + strGesture + ", pos: " + pos + ", progress:" + progress);
}

/******************/
/* Mouse events   */
/******************/

boolean movingLeftHand = true;

/**
 * Mouse handlers for mock kinect
 */
void mouseMoved() {
  // don't need to mock if kinect is connected
  if (kinect.simpleOpenNI != null) return;
  
  KinectHand hand = movingLeftHand ? kinect.leftHand : kinect.rightHand;
  
  // use mouse position to mock the hand position
  hand.pos.x = mouseX - ledWall.centerX;
  hand.pos.y = -(mouseY - ledWall.centerY);
}

void mousePressed() {
  movingLeftHand = ! movingLeftHand;
}
