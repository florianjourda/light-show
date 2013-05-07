/**
 * This class represents a Casa CTL-BM RGB Laser, controllable over 9 channels
 */

int RGBLaserCount = 2;
int nextRGBLaserId = 1;

class DeviceRGBLaser extends DeviceDMX {

  int id;

  // Channels
  final static int CHANNELCOUNT = 9;

  // Channel 1: mode values
  RGBLaserMode mode;

  // Channel 2: pattern selection (patterns are defined in RGBLaserPattern.pde)
  RGBLaserPattern pattern;

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
  RGBLaserColorSelection colorSelection;

  // Channel 9: divide into 1 to 51 segments
  int colorSegment;

  DeviceRGBLaser(int DMXAddress) {
    super(CHANNELCOUNT, DMXAddress);
    this.id = nextRGBLaserId++;

    // Draw the containing rectangle
    int w = (usableWidth - (RGBLaserCount - 1) * margin) / RGBLaserCount;
    int h = usableHeight - LEDWallSize - margin;
    rect(margin + (this.id - 1) * (w + margin), margin, w, h);
  }

  /**
   * Send DMX commands to the laser
   */
  void sendDMX() {
    this.setChannelValue(1, this.mode.dmxValue);
    if (this.mode == OFF || this.mode == SOUNDACTIVE) return;
    this.setChannelValue(2, this.pattern.dmxValue);
    this.setChannelValue(3, this.x);
    this.setChannelValue(4, this.y);
    this.setChannelValue(5, this.scanningSpeed);
    this.setChannelValue(6, this.dynamicPatternPlaySpeed);
    this.setChannelValue(7, this.staticPatternSize);
    this.setChannelValue(8, this.colorSelection.dmxValue);
    this.setChannelValue(9, this.colorSegment);
  }

  /**
   * Draw graphics
   */
  void draw() {
    // Draw the containing rectangle
    int w = (usableWidth - (RGBLaserCount - 1) * margin) / RGBLaserCount;
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
    else if (this.mode == SOUNDACTIVE)
    {
      modeText = "SOUNDACTIVE";
    }
    else
    {
      modeText = this.pattern.name;
    }
    text(modeText, x, y, w, h);

    //println(this.x + " " + this.y);
  }
}

