class ProgramRedAndGreenHands extends Program {

  private TriangleLFO[] magLFO = new TriangleLFO[5];

  public ProgramRedAndGreenHands() {
    super("RedAndGreenHands", RGB, true);
  }
  
  protected void run(int deltaMs) {
    if (kinect.leftHand != null)
    {
      leftLaser.mode = STATICPATTERNS;
      leftLaser.pattern = VERTICALLINE;
      leftLaser.x = max(0, min(255, (int) kinect.leftHand.pos.x));
      leftLaser.y = 0;//max(0, min(255, (int) kinect.leftHand.pos.y));
      leftLaser.scanningSpeed = FAST;
      leftLaser.dynamicPatternPlaySpeed = SLOW;
      leftLaser.staticPatternSize = BIG;
      leftLaser.colorSelection = R;//VGS;
      leftLaser.colorSegment = 0;
    }
    else
    {
      leftLaser.mode = OFF;
    }

    //if (kinect.rightHand != null)
    if (kinect.leftHand != null)
    {
      rightLaser.mode = STATICPATTERNS;
      rightLaser.pattern = HORIZONTALLINE;
      rightLaser.x = 0;//max(0, min(255, (int) kinect.rightHand.pos.x));
      rightLaser.y = max(0, min(255, (int) kinect.leftHand.pos.y));
      rightLaser.scanningSpeed = FAST;
      rightLaser.dynamicPatternPlaySpeed = SLOW;
      rightLaser.staticPatternSize = BIG;
      rightLaser.colorSelection = MOVINGVGS;//VGS;
      rightLaser.colorSegment = 0;
    }
    else
    {
      rightLaser.mode = OFF;
    }

    this.resetColors();
    if (kinect.leftHand != null) {
      int i = (int) (4.5 - kinect.leftHand.pos.y / ledWall.pixelSize);
      int j = (int) (4.5 + kinect.leftHand.pos.x / ledWall.pixelSize);
      i = max(0, min(DeviceLEDWall.PIXELSINALINE - 1, i));
      j = max(0, min(DeviceLEDWall.PIXELSINALINE - 1, j));
      this.colors2D[i][j] = color(255, 0, 0);
    }
    if (kinect.rightHand != null) {
      int i = (int) (4.5 - kinect.rightHand.pos.y / ledWall.pixelSize);
      int j = (int) (4.5 + kinect.rightHand.pos.x / ledWall.pixelSize);
      i = max(0, min(DeviceLEDWall.PIXELSINALINE - 1, i));
      j = max(0, min(DeviceLEDWall.PIXELSINALINE - 1, j));
      this.colors2D[i][j] = color(red(ledWall.pixels[i][j]), 255, 0);
    }
  }
}
