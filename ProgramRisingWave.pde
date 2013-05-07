class ProgramRisingWave extends Program {
  private Modulator hMod = new TriangleLFO(0, 1, 2500);
  private Modulator sMod = new TriangleLFO(0, 1, 5000);
  private Modulator dMod = new SquareLFO(-1, 1, 5000);
  private Modulator d2Mod = new SquareLFO(1, -1, 10000);

  private float accum = 0;
  
  public ProgramRisingWave() {
    super("RisingWave", HSB);
    addModulator(hMod.trigger());
    addModulator(sMod.trigger());
    addModulator(dMod.trigger());
  }
  
  protected void run(int deltaMs) {
    float hVal = hMod.getValue();
    float sVal = sMod.getValue();
    
    this.accum += deltaMs;

    float sign = dMod.getValue();
    float sign2 = d2Mod.getValue();
    
    for (int i = 0; i < this.colors.length; i++) {
      float row = (i / WIDTH);
      float b, h, s;

      h = (accum/50.0 + (WIDTH + sVal*WIDTH * sign2 + row + (i%WIDTH) * hVal * sign) * 36.0) % 360;
      s = min(100, 60 + hVal*40.0 + sVal*40.0 - abs((i/WIDTH)-4)*WIDTH);
      this.colors[i] = color(h, s, min(100, 120 - abs((i%WIDTH)-4)*WIDTH));
    }
  }
}
