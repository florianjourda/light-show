class ProgramHeart extends Program {
  
  final int[] MASK = {
    0,  62, 78, 62,  0,  0, 62, 78, 62,  0,
    62, 99, 99, 93, 64, 64, 93, 99, 99, 62,
    78, 99, 99, 99, 94, 94, 99, 99, 99, 78,
    62, 99, 99, 99, 99, 99, 99, 99, 99, 62,
    0,  99, 99, 99, 99, 99, 99, 99, 99,  0,
    0,  30, 99, 99, 99, 99, 99, 99, 30,  0,
    0,   0, 69, 99, 99, 99, 99, 69,  0,  0,
    0,   0,  0, 78, 99, 99, 78,  0,  0,  0,
    0,   0,  0,  2, 99, 99,  2,  0,  0,  0,
    0,   0,  0,  0,  3,  3,  0,  0,  0,  0
  };    
  
  private TriangleLFO bMod = new TriangleLFO(0, 1.0, 2000);
  private TriangleLFO cMod = new TriangleLFO(0, 15, 11000);
  private TriangleLFO mix = new TriangleLFO(-0.5, 1.5, 30000);
  
  public ProgramHeart() {
    super("Heart", HSB);
    this.addModulator(this.bMod.trigger());
    this.addModulator(this.cMod.trigger());
    this.addModulator(this.mix.trigger());
  }
  
  public void run(int deltaMs) {
    float mix = max(0, min(1, this.mix.getValue()));
    for (int i = 0; i < HEIGHT * WIDTH; ++i) {
      int ii = i + floor(i / WIDTH);
      if ((i % WIDTH) > WIDTH / 2) ii ++;
      float h = 359 - cMod.getValue() * dist(ii/10, ii%10, 4.5, 4.5);
      float b1 = MASK[ii] * this.bMod.getValue();
      float b2 = (99-MASK[ii]) * this.bMod.getValue();
      this.colors[i] = color(h, 100, lerp(b1, b2, mix));
    }
  }
}

