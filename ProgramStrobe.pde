class ProgramStrobe extends Program {
  private SawLFO hMod = new SawLFO(0, 360, 5000);
  private TriangleLFO sMod = new TriangleLFO(1, 0, 2000);
  private TriangleLFO bMod = new TriangleLFO(1, 0, 2000);
  
  private TriangleLFO bRateMod = new TriangleLFO(2000, 250, 24000);
  private TriangleLFO bValMod = new TriangleLFO(100, 10, 18000);

  private float hVal = 0;
  private float sVal = 100;
  private float bVal = 100;
  
  private int[] hMillis = {0, 0};
  private int[] sMillis = {0, 0};
  private int[] bMillis = {0, 0};
  
  public ProgramStrobe() {
    super("Strobe", HSB);
    addModulator(this.bMod.trigger());
    addModulator(this.hMod.trigger());
    addModulator(this.bRateMod.trigger());
    addModulator(this.bValMod.trigger());
  }
  
  public void onSlider(int number, int value) {
    switch (number) {
    case 1:
      this.hVal = map(value, 0, 127, 0, 359);
      break;
    case 2:
      this.sVal = map(value, 0, 127, 0, 100);
      break;
    case 3:
      this.bVal = map(value, 0, 127, 0, 100);
      this.bValMod.stop();
      break;
    }
  }
  
  public void onKnob(int number, int value) {
    switch (number) {    
    case 1:
      if (value == 0) {
        this.hMod.stop();
        this.hMod.setValue(0);
      } else {
        this.hMod.setDuration((int) map(value, 0, 127, 10000, 100));
        this.hMod.start();
      }
      break;
     
    case 2:
      if (value == 0) {
        this.sMod.stop();
        this.sMod.setValue(1.0);
      } else {
        this.sMod.setDuration((int) map(value, 0, 127, 2000, 100));
        this.sMod.start();
      }
      break;
      
    case 3:
      if (value == 0) {
        this.bMod.stop();
        this.bMod.setValue(1.0);
      } else {
        this.bMod.setDuration((int) map(value, 0, 127, 2000, 100));
        this.bMod.start();
      }
      this.bRateMod.stop();
      break;  
    }
  }
  
  protected void _onButtonPress(int number) {
    int now = millis();
    switch (number) {
    case 1:
      if ((hMillis[0] > 0) && (now - hMillis[0] < 5000)) {
        this.hMod.setDuration((int) ((now - hMillis[0]) / 4.0));
      }
      hMillis[0] = hMillis[1];
      hMillis[1] = now;
      break;
    case 3:
      if ((bMillis[0] > 0) && (now - bMillis[0] < 5000)) {
        this.bRateMod.stop();
        this.bMod.setDuration((int) ((now - bMillis[0]) / 2.0));
        this.bMod.setValue(1.0);
      }
      bMillis[0] = bMillis[1];
      bMillis[1] = now;
      break;
    }
  }
  
  protected void run(int deltaMs) {
    if (this.bRateMod.isRunning()) {
      this.bMod.setDuration((int) this.bRateMod.getValue());
    }
    if (this.bRateMod.isRunning()) {
      this.bVal = this.bValMod.getValue();
    }
    
    for (int i = 0; i < HEIGHT; ++i) {
      for (int j = 0; j < WIDTH; ++j) {
        this.colors[i + HEIGHT*j] = color(
          (hVal + hMod.getValue() + 5*i + 2*j) % 360,
           sVal * sMod.getValue(),
           bVal * bMod.getValue());
      }
    }
  }
}

