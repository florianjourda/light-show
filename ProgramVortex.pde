class ProgramVortex extends Program {
  
  private TriangleLFO speedMod = new TriangleLFO(0.003, 0.016, 30000);
  private SawLFO hMod = new SawLFO(0, 360, 19000);
  private TriangleLFO sMod = new TriangleLFO(100, 50, 11000);
  private TriangleLFO bMod = new TriangleLFO(0.6, 1.0, 7000);
  
  private float accum = 0;
  
  public ProgramVortex() {
    super("Vortex", HSB);
    this.addModulator(this.speedMod.trigger());
    this.addModulator(this.hMod.trigger());
    this.addModulator(this.sMod.trigger());
    this.addModulator(this.bMod.trigger());    
  }
  
  public void run(int deltaMs) {
    this.accum += deltaMs * this.speedMod.getValue();
    for (int i = 0; i < HEIGHT; ++i) {
      for (int j = 0; j < WIDTH; ++j) {
        float d = dist((WIDTH - 1) / 2, (HEIGHT - 1) / 2, i, j);
        float b = max(0, sin(d*1.2 - accum)) * (100.0);
        int h = (int)(720 + this.hMod.getValue() - d*20) % 360;
        this.colors[i + HEIGHT * j] = color(h, this.sMod.getValue(), b * this.bMod.getValue());
      }
    }
  }
}

