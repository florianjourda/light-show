class ProgramLife extends Program {

  private SawLFO trans = new SawLFO(0, 1, 500);

  private boolean[] curState = new boolean[100];
  private boolean[] nextState = new boolean[100];

  private int[] drawHue = new int[100];
  private float[] drawSat = new float[100];
  private char[] drawState = new char[100];

  private HashMap stateCache;

  private int stagnant = 0;
  private float lastTrans = 0;

  final static private char DEAD = 'X';
  final static private char BIRTHING = 'B';
  final static private char ALIVE = 'O';
  final static private char DYING = 'D';

  public ProgramLife() {
    super("Life", HSB);
    this.randomize();
    addModulator(this.trans.trigger());
  }
  
  private void randomize() {
    for (int i = 0; i < 100; ++i) {
      this.curState[i] = this.nextState[i] = false;
      this.drawHue[i] = int(random(360));
      this.drawSat[i] = random(50, 100);
      this.drawState[i] = DEAD;
    }
    int count = int(random(10, 70));
    for (int i = 0; i < count; ++i) {
      int pos = int(random(100));
      this.curState[pos] = true;
      this.drawState[pos] = ALIVE;
    }
   
    this.stateCache = new HashMap();
    this.stagnant = 0;
    this.generateColors();
  }
  
  protected void run(int deltaMs) {
    float transValue = trans.getValue();
    if (transValue < this.lastTrans) {
      for (int i = 0; i < 100; ++i) {
        int[] ret = this.countNeighbors(i);
        int tot = ret[0];
        if (curState[i]) {
          nextState[i] = (tot == 2) || (tot == 3);
        } else {
          if (nextState[i] = (tot == 3)) {
            this.drawHue[i] = ret[1];
            this.drawSat[i] = ret[2];
          }
        }
      }
      // Transfer buffer over to current
      if (this.stagnant > 1) {
        if (this.stagnant >= 4) {
          this.randomize();
        } else if (this.stagnant >= 2) {
          for (int i = 0; i < 100; ++i) {
           this.drawState[i] =
             (this.drawState[i] == ALIVE) ? DYING : DEAD;
           }
        }
      } else {
        for (int i = 0; i < 100; ++i) {
          this.drawState[i] =
            (this.curState[i] ?
              (this.nextState[i] ? ALIVE : DYING) :
              (this.nextState[i] ? BIRTHING : DEAD));
          this.curState[i] = this.nextState[i];
        }
      }
      
      String hash = new String(this.drawState);
      if (this.stateCache.containsKey(hash)) {
        ++this.stagnant;
      } else {
        this.stateCache.put(hash, true);
      }
    }
     
    this.lastTrans = transValue;
    this.generateColors();
  }
  
  private void generateColors() {
    float bVal = this.trans.getValue();
    for (int i = 0; i < HEIGHT*WIDTH; ++i) {
      float hVal = this.drawHue[i];
      switch (this.drawState[i]) {
        case DEAD:
          this.colors[i] = color(hVal, 0, 0);
          break;
        case BIRTHING:
          this.colors[i] = color(hVal, this.drawSat[i], 100 * bVal);
          break;
        case ALIVE:
          this.colors[i] = color(hVal, this.drawSat[i], 100);
          break;  
        case DYING:
          this.colors[i] = color(hVal, this.drawSat[i], 100 * (1.0 - bVal));
          break;
      }
    }
  }
  
  private int[] countNeighbors(int n) {
    int tot = 0;
    float hu = 0;
    float sat = 0;
    if (n % 10 > 0) {
      if (this.curState[n-1]) {
        ++tot; // west
        hu += this.drawHue[n-1];
        sat += this.drawSat[n-1];
      }
      if ((n > 9) && this.curState[n-11]) {
        ++tot; // northwest
        hu += this.drawHue[n-11];
        sat += this.drawSat[n-11];
      }
      if ((n < 90) && this.curState[n + 9]) {
        ++tot; // southwest
        hu += this.drawHue[n+9];
        sat += this.drawSat[n+9];
      }
    }
    if (n % 10 < 9) {
      if (this.curState[n+1]) {
        ++tot; // east
        hu += this.drawHue[n+1];
        sat += this.drawSat[n+1];
      }
      if ((n > 9) && this.curState[n-9]) {
        ++tot; // northeast
        hu += this.drawHue[n-9];
        sat += this.drawSat[n-9];
      }
      if ((n < 90) && this.curState[n+11]) {
        ++tot; // southeast
        hu += this.drawHue[n+11];
        sat += this.drawSat[n+11];
      }
    }
    if ((n > 9) && this.curState[n-10]) {
      ++tot; // north
      hu += this.drawHue[n-10];
      sat += this.drawSat[n-10];
    }
    if ((n < 90) && this.curState[n+10]) {
      ++tot; // south
      hu += this.drawHue[n+10];
      sat += this.drawSat[n+10];
    }
    
    int[] ret = new int[3];
    ret[0] = tot;
    ret[1] = (int) (hu / (float) tot);
    ret[2] = (int) (sat / (float) tot);
    return ret;
  }
  
  public void onSlider(int number, int value) {
    if (number == 1) {
      this.trans.setDuration((int) map(value, 0, 127, 2000, 100));
    }
  }
}
