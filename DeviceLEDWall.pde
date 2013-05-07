/**
 * This class represents the entire LED wall, which is composed of 81 LED square pixels
 */
 
class DeviceLEDWall extends DeviceDMX {
  
  // Channels
  final static int PIXELSINALINE = 9;
  final static int PIXELSCOUNT = PIXELSINALINE * PIXELSINALINE;
  final static int CHANNELCOUNT = PIXELSCOUNT * 3;// 3 for RGB
   
  color[][] pixels;
  
  // Dimensions for drawing
  int pixelSize = LEDWallSize / PIXELSINALINE;
  int startX = margin;
  int startY = height - margin - LEDWallSize;
  int centerX = startX + LEDWallSize / 2;
  int centerY = startY + LEDWallSize / 2;
  
  DeviceLEDWall(int DMXAddress) {
    super(CHANNELCOUNT, DMXAddress);
  }
  
  void setup()
  {
    this.reset();
    
    // Draw the containing rectangle
    rect(startX, startY, LEDWallSize, LEDWallSize);
  }
  
  /**
   * Reset the RGB value of the wall to 0 (all black)
   */
  void reset()
  {
    this.pixels = new color[PIXELSINALINE][PIXELSINALINE];
    print("RESET WALL");
  }
 
  /**
   * Send DMX commands to the LED Wall.
   * In the pixels array, the pixels(i 0 to 8,j 0 to 8) are labeled:
   * 0,0  0,1  0,2  0,3 ...  0,8
   * 1,0  1,1  1,2  1,3 ...  1,8
   * 2,0  2,1  2,2  2,3 ...  2,8
   * 3,0  3,1  3,2  3,3 ...  3,8
   * ...  ...  ...  ... ...  ...
   * 8,0  8,1  8,2  8,3 ...  8,8
   *
   * In the physical wall, the DMX pixels(ledBoxId 1 to 9, squareIdInTheBox 1 to 9) are labeled:
   * 7,7  7,8  7,9  8,7 ...  9,9
   * 7,4  7,5  7,6  8,4 ...  9,6
   * 7,1  7,2  7,3  8,1 ...  9,3
   * 4,7  4,8  4,9  5,7 ...  6,9
   * ...  ...  ...  ... ...  ...
   * 1,1  1,2  1,3  2,1 ...  3,3   
   */
  void sendDMX() {
    int[] channelValues = new int[CHANNELCOUNT];
    
    // start at the bottom left corner
    int ledBoxI = 8;
    int ledBoxJ = 0;
    int channel = 0;// channel 1 has index 0 in channelValues
    boolean on;
    // copy the entire wall (three rows of three led boxes)
    for (int ledBoxRow = 0; ledBoxRow < 3; ledBoxRow++) {
      // copy three led boxes in a wall row
      for (int ledBoxInARow = 0; ledBoxInARow < 3; ledBoxInARow++) {;
        // copy one led box (three rows of three pixel)
        for (int deltaI = 0; deltaI < 3; deltaI++) {
          // copy three pixels in a led box row;
          for (int deltaJ = 0; deltaJ < 3; deltaJ++) {
            // copy one pixel
            color col = this.pixels[ledBoxI - deltaI][ledBoxJ + deltaJ];
            channelValues[channel++] = (int) red(col);
            channelValues[channel++] = (int) green(col);
            channelValues[channel++] = (int) blue(col);
          }
        }
        // shift to the next led box to the right
        ledBoxJ += 3;
      }
      // shift to the next led box row to the top
      ledBoxI -= 3;
      ledBoxJ = 0;
    }

    this.setChannelValues(channelValues);
  }
  
  /**
   * Draw graphics
   */
  void draw() {
    // draw all the pixels
    stroke(100);
    for (int i = 0; i < PIXELSINALINE; i ++)
    {
      for (int j = 0; j < PIXELSINALINE; j ++)
      {
        color col = this.pixels[i][j];
        fill(col);
        rect(this.startX + j * this.pixelSize, this.startY + i * this.pixelSize, this.pixelSize, this.pixelSize);
      }  
    }
  }
}
