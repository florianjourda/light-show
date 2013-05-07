class ProgramSinusoids extends Program {

  private int accum = 0;
 
  private TriangleLFO decay = new TriangleLFO(80, 15, 30000);
  private TriangleLFO xMod = new TriangleLFO(-40, 40, 20000);
  
  public ProgramSinusoids() {
    super("Sinusoids", HSB);
    this.addModulator(this.decay.trigger());
    this.addModulator(this.xMod.trigger().setValue(0));
  }
  
  protected void run(int deltaMs) {
    this.accum += deltaMs;
    
    float magVal = sin(this.accum / 306.0);
    float xOffset = this.accum / 250.0;
    float sMag = sin(this.accum / 800.0);
    float dec = this.decay.getValue();
          
    for (int i = 0; i < HEIGHT; ++i) {
      float x = cos((i-4.5) * PI / 9.0);
      float v = 4.0 + 3.0*x*magVal;
      for (int j = 0; j < WIDTH; ++j) {
        float b = max(0, WIDTH * HEIGHT - abs(j - v) * dec);
        float h = (270 + i * this.xMod.getValue() + 180 * (j-4.5) / 4.0) % 360;
        this.colors[i + HEIGHT*j] = color(h, 65 + 30*sMag, b);
      }
    }
  }
}

