class ProgramStreamer extends Program {
  private float decay = 60;
  private float offset = 40;
  private float speed = 0.5;
  private float trisin = 1.0;
  private float icol = 18.0;
  private float jcol = 0.0;
  private int cbase = 90;

  private TriangleLFO decayLfo = new TriangleLFO(20, 70, 16000);
  private TriangleLFO offLfo = new TriangleLFO(40, 140, 30000);
  private SawLFO cbaseLfo = new SawLFO(359, 0, 50000);
  private TriangleLFO icolLfo = new TriangleLFO(0, 40.0, 90000);
  private TriangleLFO jcolLfo = new TriangleLFO(0, 30.0, 60000);

  private int accum = 0;
  
  public ProgramStreamer() {
    super("Streamer", HSB);
    addModulator(offLfo.trigger());
    addModulator(decayLfo.trigger());
    addModulator(cbaseLfo.trigger().setValue(240));
    addModulator(icolLfo.trigger());
    addModulator(jcolLfo.trigger());
  }
  
  public void onSlider(int number, int value) {
    switch (number) {
    case 1:
      this.decay = map(value, 0, 127, 100, 20);
      this.decayLfo.setValue(this.decay);
      this.decayLfo.stop();
      break;
    case 2:
      this.offset = map(value, 0, 127, 0, 200);
      this.offLfo.setValue(this.offset);
      this.offLfo.stop();
      break;
    case 3:
      this.speed = map(value, 0, 127, 0.1, 2.0);
      break;
    case 4:
      this.trisin = map(value, 0, 127, 0.0, 1.0);
      break;
    case 5:
      this.icol = map(value, 0, 127, 0, 72.0);
      this.icolLfo.setValue(this.icol);
      this.icolLfo.stop();
      break;
    case 6:
      this.jcol = map(value, 0, 127, 0, 72.0);
      this.jcolLfo.setValue(this.jcol);
      this.jcolLfo.stop();
      break;
    case 7:
      this.cbase = (int) map(value, 0, 127, 0, 360);
      this.cbaseLfo.setValue(this.cbase);
      this.cbaseLfo.stop();
      break;
    }
  }
  
  private float tri1000(int n) {
    n = (n + 10000) % 1000;
    if (n < 250) {
      return n / 250.0;
    } else if (n < 750) {
      return 1.0 - (n-250) / 250.0;
    } else {
      return -1.0 + (n - 750) / 250.0;
    }
  }
  
  protected void run(int deltaMs) {  
    this.accum += deltaMs * this.speed;
   
    this.offset = this.offLfo.getValue();
    this.decay = this.decayLfo.getValue();
    this.cbase = (int) this.cbaseLfo.getValue();
    this.icol = this.icolLfo.getValue();
    this.jcol = this.jcolLfo.getValue();
    
    for (int i = 0; i < HEIGHT; ++i) {
      float t = 4.5 + 4.0 * tri1000((int) (accum - (9 - i) * this.offset));
      float s = 4.5 + 4.0 * sin((accum - (9 - i) * this.offset) / (1000.0 / TWO_PI));
      float v = (t * (1.0 - this.trisin)) + (s * this.trisin);
      for (int j = 0; j < WIDTH; ++j) {
        int h = (int) (this.cbase + (this.icol * (9.0 - i)) + (j * this.jcol));
        float b = max(0, 100 - abs(j - v) * this.decay);
        this.colors[i + HEIGHT*j] = color(h % 360, 100, b);
      }
    }
  }
}
