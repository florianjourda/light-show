class ProgramTest extends Program {
  
  private int colorIndex = 0;
  private int vertical = 0;
  private int step = 0;
  private int totalMs = 0;
  
  public ProgramTest() {
     super("Test", RGB, true);
  }
 
  protected void run(int deltaMs) {
    
    this.totalMs += deltaMs;
    
    leftLaser.mode = OFF;
    rightLaser.mode = OFF;
    
    color col;
    
    if (this.colorIndex == 0) {
      col = color(255, 0, 0);
    }
    else if (this.colorIndex == 1) {
      col = color(0, 255, 0);
    }
    else if (this.colorIndex == 2) {
      col = color(0, 0, 255);
    }
    else {
      col = color(0, 0, 0);
    }
    
    this.resetColors();
    //int deltaI = floor(this.step / 3);
    //int deltaJ = this.step % 3;
    //ledWall.pixels[ledBoxI - deltaI][ledBoxJ + deltaJ] = col;
    //for (int deltaI = 0; deltaI < 3; deltaI++) {
    //  for (int deltaJ = 0; deltaJ < 3; deltaJ++) {
    //    ledWall.pixels[ledBoxI - deltaI][ledBoxJ + deltaJ] = col; 
    // }
    //}
  }
}


