 /**
 * LightShow
 * Software to control a 10x10 array of ColorKinetics
 * iColor Flex MX RGB LEDs.
 *
 * @author Mark Slee <mcslee@gmail.com> 2010
 * @author Florian Jourda <florian.jourda@gmail.com> 2011 
 */
 
// Variables to change depending on the run environment 
boolean dmxAvailable = true;

// Dimensions for drawing the devices
int width = 600;
int height = 800;
int margin = 30;
int usableWidth = width - 2 * margin;
int usableHeight = height - 2 * margin;
int LEDWallSize = usableWidth;

// Input
DeviceKinect kinect;

// Output
DMXOutput dmxOutput;
DeviceRGBLaser leftLaser;
DeviceRGBLaser rightLaser;
DeviceLEDWall ledWall;

/**
 * To exit after shutting down all DMX devices
 */
void exit() {
  super.exit();
  // needs to be after super.exit or a last draw will appear after
  // and overwrite the reset
  dmxOutput.reset();
}




import processing.opengl.*;


public final int WIDTH = 9;
public final int HEIGHT = 9;
public final int AUTO_ROTATE_TIME = 90000;

private int cMode = RGB;

private int elapsedMs;
private int rotateMs;

private boolean showFrameRate = false;
private boolean showBpm = true;
private boolean showLeds = true;
private boolean showMidi = false;
private boolean autoRotate = true;
private boolean running = true;
private boolean paused = false;
private boolean sendKeyReleased = false;

private float masterBrightness = 1.0;
private float masterFade = 1.0;
private float masterRate = 1.0;

private ProgramFactory programFactory;
private Program program;

void debugBool(String prefix, boolean on) {
  println(prefix + (on ? "ON" : "OFF"));
}

void setup() {
  // 1. Drawing
  //create window for the drawing (needs to be first statement)
  size(width, height, P2D);
  colorMode(RGB, 255);
  
  println("Setup");
  
   // 2. Input
  kinect = new DeviceKinect(this);
  kinect.setup();
  
  // 3. Output
  // 3.a Setup DMX driver used by all the devices in the universe (defined in DMXDevice.pde)  
  // hack: test if the Serial is working before to avoid null pointer exception, since
  // the DMX library doesn't do it 
  //println(Serial.list());// should display "COM4"
  dmxOutput = new DMXOutput(this);
  dmxOutput.setup();
  
  // 3.b Setup of the DMX devices
  ledWall = new DeviceLEDWall(DeviceDMX.firstDMXAddress);
  ledWall.setup();
  leftLaser = new DeviceRGBLaser(ledWall.nextDMXAddress());
  rightLaser = new DeviceRGBLaser(leftLaser.nextDMXAddress());
  
  // 4. Initialize the first program
  //frameRate(20);
  //textFont(createFont("Arial", 48));
  this.elapsedMs = millis();
  programFactory = new ProgramFactory(this);
  program = programFactory.getProgram();
}

/**
 * Wrapper around Processing's native colorMode().
 * We need to know what color mode the program uses
 * to properly initialize the LED simulation.
 */
void myColorMode(int mode) {
  this.cMode = mode;
  switch (mode) {
  case RGB:
    colorMode(RGB, 255, 255, 255);
    break;
  case HSB:
    colorMode(HSB, 360, 100, 100);
    break;
  default:
    println("INVALID COLOR MODE: " + mode);
    exit();
  }
}


// Toggles for program operation
void keyPressed() {
  int myKey = key;
  switch (keyCode) {
  case ESC: myKey = 'Q'; break;
  case LEFT: myKey = '['; break;
  case RIGHT: myKey = ']'; break;
  }
  switch (myKey) {
  case '[':
    this.program = this.programFactory.prevProgram();
    this.autoRotate = false;
    break;
  case ']':
    this.program = this.programFactory.nextProgram();
    this.autoRotate = false;
    break;
  case 't':
  case 'T':
    this.program = new ProgramTest();
    break;
  case 'f':
  case 'F':
    this.showFrameRate = !this.showFrameRate;
    this.debugBool("FRAMERATE: ", this.showFrameRate);
    break;
  case 'a':
  case 'A':
    println("PROGRAM: <<Auto Rotate Enabled>>");
    this.rotateMs = 0;
    this.autoRotate = true;
    break;
  case 'b':
  case 'B':
    this.showBpm = !this.showBpm;
    break;
  case 'l':
  case 'L':
    this.showLeds = !this.showLeds;
    this.debugBool("LED-SIM: ", this.showLeds);
    break;
  case 'm':
  case 'M':
    this.showMidi = !this.showMidi;
    this.debugBool("MIDI: Debug ", this.showMidi);
    break;
  case 'p':
  case 'P':
    this.paused = !this.paused;
    break;
  case 'q':
  case 'Q':
    exit();
    break;
  default:
    this.sendKeyReleased = true;
    this.program.onKeyPressed();
    break;
  }
}

void keyReleased() {
  if (this.sendKeyReleased) {
    this.sendKeyReleased = false;
    this.program.onKeyReleased();
  }
}

/**
 * Processing's core runtime loop. Invoked at the desired
 * frameRate. This loop calculates how much time has actually
 * passed and instructs the program to run.
 */
void draw() { 
  // Calculate the change in time that has occurred
  int nowMs = millis();

  int deltaMs = (int) (this.masterRate * (nowMs - this.elapsedMs));
  this.elapsedMs = nowMs;
  
  if (!this.running) {
    return;
  }

  // Check the program auto-rotation timer
  if (this.autoRotate) {
    this.rotateMs += deltaMs;
    if (this.rotateMs > AUTO_ROTATE_TIME) {
      this.rotateMs = 0;
      this.program = this.programFactory.nextProgram();
    } else if (this.rotateMs > AUTO_ROTATE_TIME - 2000) {
      this.masterFade = (AUTO_ROTATE_TIME - this.rotateMs) / 2000.0;
    } else if (this.rotateMs < 2000) {
      this.masterFade = this.rotateMs / 2000.0;
    }
  } else {
    this.masterFade = 1.0;
  }

  // Run the currently selected program
  if (!this.paused) {
    program.go(deltaMs);
  }

  if (showBpm) {
    fill(#FF0000);
    text("" + round(bpm*100)/100.0, 10, 380);
  }

  // Debug information if desired
  if (this.showFrameRate && (frameCount % 10 == 0)) {
    println("FPS: " +  frameRate);
  }
}
