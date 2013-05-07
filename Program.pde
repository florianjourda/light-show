/**
 * BPM and Flash management
 */
private float bpm = 120;
private int bpmDuration = 500;
  
private float firstTap = 0;
private float lastTap = 0;
private int numTaps = 0;

protected Click click;
protected int beat = -1;

private int bpmToDuration(float bpm) {
  return (int) (60000 / bpm);
}
  
private float durationToBpm(int durationMs) {
  return 60000 / (float) durationMs;
}
 

/**
 * This is the main class for a light show program. The interface
 * is quite simple. Essentially, your Program runs
 */
abstract class Program {
  
  private ArrayList modulators = new ArrayList();

  private boolean flashOn = false;    
  private String name; 
  private boolean use2DArray;// yes for Florian Jourda's programs, no for Mark Slee's
  protected LinearEnvelope flash = new LinearEnvelope(0, 100, 1000);
  
  /**
   * Every program's constructor should call super() with
   * these two parameters. cMode is either RGB (255/255/255)
   * or HSB (360/100/100)
   */
  protected Program(String name, int cMode, boolean use2DArray) {
    println("PROGRAM: " + name);
    this.name = name;
    this.use2DArray = use2DArray;
    
    myColorMode(cMode);
    addModulator(flash.setValue(0));
    this.resetColors();
    
    // default values
    leftLaser.mode = SOUNDACTIVE;
    rightLaser.mode = SOUNDACTIVE;
  }
  
  /**
   * Constructor for Mark Slee's program that use 1D array
   */
  protected Program(String name, int cMode) {
    this(name, cMode, false);
  }
 
  /**
   * Adds a Modulator to the program. These will always
   * be automatically incremented prior to execution of the
   * Program's run() method.
   */
  final protected Modulator addModulator(Modulator m) {
    this.modulators.add(m);
    return m;
  }
  
  /**
   * Asks the program to run one more step
   */
  final public void go(int deltaMs) {
    
    // 1. Read inputs
    // refresh kinect data
    kinect.update();

    // 2. Compute program pattern
    if (click == null) {
      click = new Click(bpmDuration = bpmToDuration(bpm));
      click.trigger();
    }
    click.run(deltaMs);
    if (click.click()) {
      ++beat;
    }
    for (int i = 0; i < modulators.size(); ++i) {
      Modulator m = (Modulator) modulators.get(i);
      m.run(deltaMs);
    }
    this.run(deltaMs);
    
    if (flashOn || flash.isRunning()) {
      float f = flash.getValue();
      for (int i = 0; i < this.colors.length; ++i) {
        // TODO: fix flash in RGB color mode
        color c = this.colors[i];
        float h = hue(c);
        float s = saturation(c);
        float b = brightness(c);
        float dscale = max(0, 1.5 - dist(i/10, i%10, 4.5, 4.5) / 4.0);
        s = max(0, s - f);
        b = constrain(s + f*dscale, 0, 100);
        this.colors[i] = color(h, s, b);
      }
    }
    this.sendColorsToLEDWall();
    
    // 3. Write to output
    leftLaser.sendDMX();
    rightLaser.sendDMX();
    ledWall.sendDMX();
    
    // 4. Draw graphics for inputs and outputs
    // we do this step after writing to the output since it has a lower
    // priority to be realtime
    leftLaser.draw();
    rightLaser.draw();
    ledWall.draw();
    kinect.draw();// needs to be after ledWall to draw on top of it
  }
  
  /**
   * The program implements a run loop, which is told
   * how many milliseconds have passed since its last
   * invocation.
   */
  abstract protected void run(int deltaMs);
  
  /**
   * The program operates on an array of colors nodes. These
   * are laid out in horizontal stripes, top to bottom.
   * - Index 0 is the top left corner.
   * - Index 9 is the top right corner.
   * - Index 10 is the leftmost node in the 2nd row.
   * - Index 90 is the bottom left corner
   * - Index 99 is the bottom right corner
   *
   *   00 01 02 03 04 05 06 07 08 09
   *   10 11 12 13 14 15 16 17 18 19
   *   20 ....................... 29
   *   .............................
   *   80 ....................... 89
   *   90 91 92 93 94 95 96 97 98 99
   *
   * The program's run() method should write new values
   * into the colors array as appropriate.
   * Used by programs made by Mark Slee
   */
  protected color[] colors;
  
  /**
   * Used by programs made by Florian Jourda
   */
  protected color[][] colors2D;  

  final public color[] getColors() {
    return colors;
  }
  
  final public color getColor(int index) {
    return colors[index];
  }

  protected void setColor(color c) {
    for (int i = 0; i < colors.length; ++i) {
      colors[i] = c;
    }
  }
  
  protected void resetColors() {
    if (this.use2DArray) {
      this.colors2D = new color[HEIGHT][WIDTH];
    } else {
      this.colors = new color[WIDTH * HEIGHT];
    }
  }
  
  /**
   * Send the colors stored in the 1D or 2D array depending
   * on what system the program uses
   */
  private void sendColorsToLEDWall() {
    if (!this.use2DArray) {
      //myColorMode(RGB);
      int k = 0;
      for (int i = 0; i < DeviceLEDWall.PIXELSINALINE; i ++) {
        for (int j = 0; j < DeviceLEDWall.PIXELSINALINE; j ++) {
          ledWall.pixels[i][j] = this.colors[k++];
        }
      }
    } else {
      // @TODO is there array.copy() function in java?
      for (int i = 0; i < DeviceLEDWall.PIXELSINALINE; i ++) {
        for (int j = 0; j < DeviceLEDWall.PIXELSINALINE; j ++) {
          ledWall.pixels[i][j] = this.colors2D[i][j];
        }
      }
    }
  }
  
  /**
   * LightShow is designed to run with a Korg NanoKontrol unit.
   * Controls 1-8 are send to programs. Whenever a knob, slider
   * or button is manipulated, one of the following methods is
   * invoked on the active program with the control number
   * (in the indices labeled on the device, 1-8, not CS-style
   * 0-indexing), values are in the MIDI range from 0-127.
   */
  
  /* abstract */ public void onSlider(int number, int value) {}
  /* abstract */ public  void onKnob(int number, int value) {}
  
  /* abstract */ protected void _onButtonPress(int number) {}
  /* abstract */ protected void _onButtonRelease(int number) {}
  
  public final void onKeyPressed() {
    if (keyCode == UP) {
      this.nudgeTempo(0.025);
    } else if (keyCode == DOWN) {
      this.nudgeTempo(-0.025);
    } else if (key == ' ') {
      this.tapTempo();
    } else if (keyCode == ENTER || key == 'z') {
      this.startFlash();
    }
  }

  public final void onKeyReleased() {
    this.stopFlash(keyCode != ENTER);
  }

  public final void onButtonPress(int number) {
    switch (number) {
    case 1:
      this.nudgeTempo(-0.025);
      break; 
    case 11:
      this.nudgeTempo(0.025);
      break;
    case 9:
    case 19:
      this.startFlash();
      break;
    default:
      this._onButtonPress(number);
    }
  }
  
  public final void onButtonRelease(int number) {
    switch (number) {
    case 1:
    case 11:
      break;
    case 9:
    case 19:
      this.stopFlash(number == 19);
      break;
    default:
      this._onButtonRelease(number);
    }
  }

  public void tapTempo() {
    int thisTap = millis();
    if (thisTap - lastTap < 1200) {
      ++numTaps;
      lastTap = thisTap;
      if (numTaps >= 3) {
        bpmDuration = (int) ((lastTap - firstTap) / (float) numTaps);
        bpm = durationToBpm(bpmDuration);
        click.setDuration(bpmDuration);
        println("BPM: " + bpm);
      }
    } else {
      numTaps = 0;
      firstTap = lastTap = thisTap;
    }
    beat = -1;
    click.fire();
  }

  private void nudgeTempo(float delta) {
    bpm += delta;
    click.setDuration(bpmDuration = bpmToDuration(bpm));
    println("BPM: " + bpm);
  }
 
  private void startFlash() {
    if (!flashOn) {
      flashOn = true;
      flash.setRange(0, 100, 100);
      flash.trigger();
    }
  }
  
  private void stopFlash(boolean slowFade) {
    if (flashOn) {
      flashOn = false;
      flash.setRange(flash.getValue(), 0, slowFade ? 1500: 200);
      flash.trigger();
    }
  }
}

/**
 * Factory to generate instances of programs on-demand. When
 * you make a new program, just add it to the list in
 * programClasses.
 */
class ProgramFactory {

  private final String[] programClasses = {
    "Life","Streamer","Strobe",
    "RompSparkle",
    "PulseMatrix",
    "Rain",
    "HeavyRain",
    "RisingWave",
    "Heart",
    "ColorPulse",
    "Streamer",
    "Vortex",
    "RompBlocks",
    "Warp",
    //"Pong",
    "RompSweep",
    "Bouncing",
    "Sinusoids",
    "Love",
    "Tetris"
    //"RedAndGreenHands"
    //"DepthMap"
  };
  
  /*
  private final String[] programClasses = {
    "Heart",
    "Rain",
    "Tetris",
    "ColorPulse",
    "Love",
    "Vortex",
    "RisingWave",
    "Life",
    "Strobe",
    "Streamer",
    "Bouncing",
    "Pong",
    "PulseMatrix",
    "Sinusoids",
    "Warp"
  };*/
    
  
  private final LightShow lightShow;
  private Program program;
  private int index = 0;
  
  public ProgramFactory(LightShow lightShow) {
    this.lightShow = lightShow;
    this.constructProgram();
  }
  
  private Program constructProgram() {
    try {
      Class cls = Class.forName("LightShow$Program" + this.programClasses[this.index]);
      Object[] args = { this.lightShow };
      return this.program = (Program) cls.getConstructors()[0].newInstance(args);
    } catch (Exception x) {
      x.printStackTrace();
    }
    println("EPIC REFLECTION FAILURE");
    return this.program = new ProgramColorPulse();
  }
  
  public Program getProgram() {
    return this.program;
  }
  
  public Program resetProgram() {
    return this.constructProgram();
  }
  
  public Program nextProgram() {
    ++this.index;
    if (this.index >= this.programClasses.length) {
      this.index = 0;
    }
    return this.constructProgram();
  }
  
  public Program prevProgram() {
    --this.index;
    if (this.index < 0) {
      this.index = this.programClasses.length-1;
    }
    return this.constructProgram();
  }
 /*
 
  /**
   * Keyboard hanlder
   *
  void keyPressed1() {
    controller.pattern.keyPressed();
  }
  */
}
