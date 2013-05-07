class ProgramPulseMatrix extends Program {

  private TriangleLFO brtMod = new TriangleLFO(-80, 100, 5000);
  private SawLFO hueMod = new SawLFO(0, 359, 4000);
  
  private TriangleLFO xMod = new TriangleLFO(0, 10, 8000);
  private TriangleLFO yMod = new TriangleLFO(10, 0, 11000);
  
  private TriangleLFO bScaleMod = new TriangleLFO(1.2, 0.2, 24000);
  
  public ProgramPulseMatrix() {
    super("PulseMatrix", HSB);
    addModulator(this.brtMod.trigger());
    addModulator(this.hueMod.trigger());
    addModulator(this.xMod.trigger());
    addModulator(this.yMod.trigger());
    addModulator(this.bScaleMod.trigger());
  }
  
  protected void run(int deltaMs) { 
    float bScale = min(1.0, this.bScaleMod.getValue());
    
    float hVal = this.hueMod.getValue();
    float bVal = this.brtMod.getValue();
    
    float xVal = this.xMod.getValue();
    float yVal = this.yMod.getValue();
    
    for (int x = 0; x < HEIGHT; ++x) {
      for (int y = 0; y < WIDTH; ++y) {
        float brt = (x%2==0 ^ y%2==1) ? max(0, bVal) : max(0, 20 - bVal);
        colors[x + HEIGHT*y] = color((720 + hVal - x*xVal - y*yVal) % 360, 100, brt * bScale);
      }
    }
  }
}
