class ProgramBouncing extends Program {

  private float[] mags = {4, 6, 3, 2, 7};
  private float[] speeds = {360, 300, 390, 340, 310};
  private float[] accum = {0, 0, 0, 0, 0};

  private TriangleLFO[] magLFO = new TriangleLFO[5];

  public ProgramBouncing() {
    super("Bouncing", HSB);
    for (int i = 0; i < 5; ++i) {
      this.magLFO[i] = new TriangleLFO(2, 8, 8000 + i*1000);
      addModulator(this.magLFO[i].trigger().setValue(this.mags[i]));
    }
  }
  
  public void onSlider(int number, int value) {
    this.magLFO[number - 1].stop();
    this.magLFO[number - 1].setValue(map(value, 0, 127, 1, 8));
  }
  
  public void onKnob(int number, int value) {
    this.speeds[number - 1] = map(value, 0, 127, 1000, 100);
  }
  
  protected void run(int deltaMs) {
    for (int i = 0; i < 4; ++i) {
      this.mags[i] = this.magLFO[i].getValue();
      
      this.accum[i] += deltaMs / this.speeds[i];
      float v = 8.5 - mags[i] * abs(sin(this.accum[i]));
      float h = int(this.accum[i] * 20) % 360;
      for (int j = 0; j < WIDTH; ++j) {
        this.colors[2*i + HEIGHT*j] = color(h, 100, max(0, 100 - 40*(abs(j - v))));
        this.colors[2*i + 1 + HEIGHT*j] = color(h, 100, max(0, 100 - 40*(abs(j - v))));
      }
    }
  }
}
