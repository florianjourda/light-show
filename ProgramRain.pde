class ProgramRain extends Program {
  
  private final int NUM_DROPS = 20;
  
  private SawLFO hMod = new SawLFO(0, 359, 14000);
  private TriangleLFO dMod = new TriangleLFO(4, 6, 23000);
  private TriangleLFO vMod = new TriangleLFO(0.006, 0.024, 40000);
  protected boolean vertical;
  
  Drop[] drops = new Drop[NUM_DROPS];
  
  class Drop {
    public int x;
    public float y;
    
    public Drop(int x, float y) {
      this.x = x;
      this.y = y;
    }
  }
  
  public ProgramRain() {
    super("Rain", HSB);
    for (int i = 0; i < NUM_DROPS; ++i) {
      drops[i] = new Drop((int) random(0, 10), random(-2, 12));
    }
    this.addModulator(this.hMod.trigger());
    this.addModulator(this.dMod.trigger());
    this.addModulator(this.vMod.trigger().setValue(0.01));
    vertical = true;
  }
  
  public void run(int deltaMs) {
    float[] b = new float[100];
    for (int i = 0; i < 100; ++i) {
      b[i] = 0;
    }
    
    for (int i = 0; i < drops.length; ++i) {
      Drop d = drops[i];
      if (d.y > 12) {
        d.y = random(-4, -2);
        d.x = (int) random(0, 10);
      }
      int fy = floor(d.y);
      
      for (int y = floor(d.y-2); y <= floor(d.y + 2); ++y) {
        if (y >= 0 && y < 10) {
          b[d.x + y*10] += max(0, 80 - abs(d.y - y)*40);
        }
      }
      d.y += deltaMs * this.vMod.getValue();
    }
    for (int i = 0; i < WIDTH * HEIGHT; ++i) {
      // to make the rain vertical or inclined
      int ii = vertical ? i + floor(i/WIDTH) : i;
      this.colors[i] = color((540 + this.hMod.getValue() - (ii/10) * this.dMod.getValue()) % 360, min(100, 150 - (ii/10)*10), min(100, b[ii]));
    }
    
  }
}

class ProgramHeavyRain extends ProgramRain {
  
  public ProgramHeavyRain() { 
    super();
    vertical = false;
  } 
}
