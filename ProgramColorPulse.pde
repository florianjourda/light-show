class ProgramColorPulse extends Program {
  
  private Modulator rMod = new TriangleLFO(40, 255, 2000);
  private Modulator gMod = new TriangleLFO(40, 255, 4000);
  private Modulator bMod = new TriangleLFO(40, 255, 8000);
  
  private Modulator xMod = new TriangleLFO(3, 6, 8000);
  private Modulator yMod = new TriangleLFO(3, 6, 7000);
  
  private Modulator fMod = new TriangleLFO(30.0, 75.0, 15000);
  
  private float falloff = 50.0;
  
  public ProgramColorPulse() {
    super("ColorPulse", RGB);
    addModulator(rMod.trigger());
    addModulator(gMod.trigger());
    addModulator(bMod.trigger());
    addModulator(xMod.trigger().setValue(4.5));
    addModulator(yMod.trigger());
    addModulator(fMod.trigger());
  }
  
  public void onSlider(int num, int value) {
    this.falloff = map(value, 0, 127, 9.0, 90.0);
    this.fMod.stop();
  }
  
  protected void run(int deltaMs) {
    if (fMod.isRunning()) {
      this.falloff = fMod.getValue();
    }    
    float x = xMod.getValue();
    float y = yMod.getValue();
    
    for (int i = 0; i < HEIGHT; ++i) {
      for (int j = 0; j < WIDTH; ++j) {
        float d = this.falloff * dist(i, j, x, y);
        this.colors[i*WIDTH + j] = color(
          max(0, rMod.getValue() - d),
          max(0, bMod.getValue() - d),
          max(0, gMod.getValue() - d)
        );
      }
    }
  }
}

