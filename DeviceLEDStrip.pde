/**
 * This class represents a RGB KED Strip, controllable over 3 channels
 *

int RGBLEDStripCount = 2;
int nextRGBLEDStripId = 1;

class DeviceRGBLEDStrip extends DeviceDMX {

  int id;
  
  // Channels
  final static int CHANNELCOUNT = 3;
 
  // Channel 1: mode values
  RGBLEDStripMode mode;

  // Channel 2: pattern selection (patterns are defined in RGBLEDStripPattern.pde)
  RGBLEDStripPattern pattern;

  // Channel 3: position X
  int x;
  
  // Channel 4: position Y
  int y;
  
  // Channel 5: scanning speed (0 is fast, 255 is slow)
  int scanningSpeed;
  
  // Channel 6: dynamic patterns play speed (0 is fast, 255 is slow, has ten grade speed)
  int dynamicPatternPlaySpeed;
  
  // Channel 7: static pattern size (0 is small, 255 is big)
  int staticPatternSize; 
  
  // Channel 8: color selection (V, G, S, 3 colors combinered)
  RGBLEDStripColorSelection colorSelection;
  
  // Channel 9: divide into 1 to 51 segments
  int colorSegment;
  
  DeviceRGBLEDStrip(int DMXAddress) {
    super(CHANNELCOUNT, DMXAddress);
    this.id = nextRGBLEDStripId++;
    
    // Draw the containing rectangle
    int w = (usableWidth - (RGBLEDStripCount - 1) * margin) / RGBLEDStripCount;
    int h = usableHeight - LEDWallSize - margin;
    rect(margin + (this.id - 1) * (w + margin), margin, w, h);
  }

  /**
   * Send DMX commands to the laser
   /
  void sendDMX() {
    ///this.setChannelValue(1, this.mode.dmxValue);
  }
    
  /**
   * Draw graphics
   /
  void draw() {
    // Draw the containing rectangle
    int w = (usableWidth - (RGBLEDStripCount - 1) * margin) / RGBLEDStripCount;
    int h = usableHeight - LEDWallSize - margin;
    int x = margin + (this.id - 1) * (w + margin);
    int y = margin;
    
    fill(0);
    rect(x, y, w, h);
    fill(255);
    
    String modeText;
    if (this.mode == OFF)
    {
      modeText = "OFF";
    }
    else
    {
      modeText = this.pattern.name;
    }
    text(modeText, x, y, w, h);
    
    //println(this.x + " " + this.y);
  }
}

