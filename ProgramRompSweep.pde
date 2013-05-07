class ProgramRompSweep extends Program {
  
  private LinearEnvelope yMod = new LinearEnvelope(11, -1, bpmDuration * 2);
  private SawLFO hMod = new SawLFO(0, 360, 15000);
  private TriangleLFO sMod = new TriangleLFO(70, 100, 9000);
  private boolean yMode = true;
  private boolean xMode = true;
  private boolean bothWays = false;
  private boolean odd = false;
  
  public ProgramRompSweep() {
    super("RompSweep", HSB);
    addModulator(yMod.trigger());
    addModulator(hMod.trigger());
    addModulator(sMod.trigger());
    addModulator(flash.setValue(0));
  }
    
  protected void run(int deltaMs) {
    if (click.click()) {
      yMod.setDuration(bpmDuration).trigger();
      odd = !odd;
    }
    float h = hMod.getValue();
    float s = sMod.getValue();
    for (int i = 0; i < this.colors.length; ++i) {
      int index = yMode ? (i/10) : (i%10);
      index = xMode ? 9-index : index;
      index = (bothWays && odd) ? index : 9-index;
      float b = max(0, 100 - 40 * abs(index - yMod.getValue()));
      this.colors[i] = color(h, s, b);
    }
  }
  
  protected void _onButtonPress(int number) {
    switch (number) {
      case 2:
        xMode = true;
        yMode = true;
        break;
      case 12:
        xMode = false;
        yMode = true;
        break;
      case 3:
        xMode = false;
        yMode = false;
        break;
      case 13:
        xMode = true;
        yMode = false;
        break;
      case 4:
        bothWays = false;
        break;
      case 14:
        bothWays = true;
        break;
    }
  }
}

class RompSparkle extends Program {
  
  private TriangleLFO[] lfos = {
    new TriangleLFO(0, 90, 5000),
    new TriangleLFO(0, 90, 3000),
    new TriangleLFO(0, 90, 2000),
    new TriangleLFO(0, 90, 8000)
  };

  public RompSparkle() {
    super("RompSparkle", HSB);
    for (int i = 0; i < lfos.length; ++i) {
      addModulator(lfos[i].trigger());
    }
  }
  
  protected void run(int deltaMs) {
    for (int i = 0; i < this.colors.length; ++i) {
      this.colors[i] = color(
        lfos[(i+2) % lfos.length].getValue() * 4,
        10 + lfos[(i+1) % lfos.length].getValue(),
        10 + lfos[i % lfos.length].getValue()
      );
    }
  }
}

class RompBlocks extends Program {
  
  private LinearEnvelope bEnv = new LinearEnvelope(1, 0, 500);
  private float hVal;
  private float xVal;
  private float yVal;
  
  public RompBlocks() {
    super("RompBlocks", HSB);
    addModulator(bEnv);
  }
  
  protected void run(int deltaMs) {
    if (click.click()) {
      hVal = random(360);
      xVal = 1 + random(7);
      yVal = 1 + random(7);
      bEnv.setDuration(bpmDuration);
      bEnv.trigger();
    }
    float bVal = bEnv.getValue();
    for (int i = 0; i < this.colors.length; ++i) {
      float maxdist = max(abs(i%10 - xVal), abs(i/10 - yVal));
      float b = constrain((140 - maxdist * 50), 0, 100) * bVal;
      this.colors[i] = color(hVal, 100, b);
    }
  }
}

class RompFuse extends Program {
  
  private TriangleLFO pulser = new TriangleLFO(20, 100, bpmDuration * 4);
  private int count = 0;
  
  public RompFuse() {
    super("RompFuse", HSB);
    addModulator(pulser.trigger());
  }
  
  protected void run(int deltaMs) {
    if (click.click()) {
      if (count++ >= 3) {
        count = 0;
        pulser.setDuration(bpmDuration * 4).trigger();
      }
    }
    
    float b = pulser.getValue();
    for (int i = 0; i < this.colors.length; ++i) {
      int x = i / 10;
      int y = i % 10;
      if ((x == 4 || x == 5) && (y == 4 || y == 5)) {
        this.colors[i] = color(
          0, 100, b
        );
      } else {
        this.colors[i] = color(0, 0, 0);
      }
    }
  }
}
