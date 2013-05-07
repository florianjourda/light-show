class ProgramWarp extends Program {
  
  private float accum = 0;
  
  private TriangleLFO hMod = new TriangleLFO(0, 360, 19000);
  private TriangleLFO vMod = new TriangleLFO(-1/50.0, 1/50.0, 37000);
  private TriangleLFO sMod = new TriangleLFO(100, 40, 7000);
  private TriangleLFO xMod = new TriangleLFO(-2, 11, 24000);
  
  public ProgramWarp() {
    super("Warp", HSB);
    this.addModulator(this.hMod.trigger());
    this.addModulator(this.vMod.trigger());
    this.addModulator(this.sMod.trigger());
    this.addModulator(this.xMod.trigger().setValue(4.5));
  }
  
  public void run(int deltaMs) {
    this.accum += deltaMs * this.vMod.getValue();
    for (int i = 0; i < HEIGHT; ++i) {
      for (int j = 0 ; j < WIDTH; ++j) {
        float d = abs(i - this.xMod.getValue());
        float b = max(0, sin(this.accum + d - 1.8*abs(j-4.5) / 2.0));
        int h = (int)(this.hMod.getValue() + d*20.0) % 360;
        this.colors[i + WIDTH*j] = color(h, this.sMod.getValue(), b*100);
      }
    }
  }
}

