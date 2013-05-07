class ProgramLove extends Program {

  private final String quote = "LOVE ";
  private final int STEP = 2000;

  private float[] bMask;
  private int charIndex = 0;
  private int accum = 0;
  private int hVal = 0;
  private int sVal = 0;
  
  public ProgramLove() {
    super("Love", HSB);
    this.bMask = new float[100];
    this.setMask(this.charIndex);
  }
  
  private void setMask(int index) {
    PGraphics pg = createGraphics(10, 10, P2D);
    pg.beginDraw();
    pg.background(color(0, 0, 0));
    pg.fill(color(255, 255, 255));
    pg.textFont(createFont("Verdana Bold", 13, true));
    pg.textAlign(CENTER);
    int offset = (index == 0) ? 5 : 6;
    pg.text(this.quote.substring(index, index+1), offset, 10);
    pg.endDraw();
    PImage raster = pg.get();
    for (int i = 0; i < 100; ++i) {
      this.bMask[i] = brightness(raster.pixels[i]);
    }
    this.hVal = (int) random(0, 360);
  }
  
  public void run(int deltaMs) {
    this.accum += deltaMs;
    if (this.accum > STEP) {
      this.accum -= STEP;
      ++this.charIndex;
      if (this.charIndex >= this.quote.length()) {
        this.charIndex = 0;
      }
      this.setMask(this.charIndex);
    }
    
    float step = STEP / 2.0;
    float brt = this.accum < step ? this.accum / step : (2*step - this.accum) / step;
    for (int i = 0; i < WIDTH * HEIGHT; ++i) {
      int ii = i + floor(i / WIDTH);
      this.colors[i] = color(
        (360 + this.hVal + this.accum / 9 - (ii%10)*10) % 360,
        max(0, min(100, 20 + 25 * abs((ii/10) - ((STEP - this.accum) / (STEP / 10.0))))),
        min(100, 1.4 * this.bMask[ii] * brt));
    }
  }
}
