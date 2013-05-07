import SimpleOpenNI.*;
SimpleOpenNI  context;

class ProgramDepthMap extends Program {

  private TriangleLFO[] magLFO = new TriangleLFO[5];

  public ProgramDepthMap() {
    super("DepthMap", RGB, true);
  }
  
  protected void run(int deltaMs) {
    this.resetColors();
    
    /*for (int i=0;i<9;i++){
      this.colors2D[i][4] = color(255, 0, 0);
      this.colors2D[4][i] = color(255,0,0);
    }*/
    
  }
}
