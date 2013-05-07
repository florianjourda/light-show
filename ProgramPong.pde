class ProgramPong extends Program {
  
  private final float BRT_MAX = 2.5;
  
  private SawLFO bg = new SawLFO(0, 360, 8000);
  private TriangleLFO brt = new TriangleLFO(0, BRT_MAX, 4000);
  
  public ProgramPong() {
    super("Pong", HSB);
    lPad = rPad = 4.5;
    lAI = rAI = true;
    this.resetGame();
    addModulator(this.bg.trigger());
    addModulator(this.brt.trigger());
  }
  
  private int waitToStart = 1000;
  private float xPos, yPos;
  private float xVel, yVel;
  private float lPad, rPad;
  private int lScore, rScore;
  private boolean lAI, rAI;
  
  public void onSlider(int num, int value) {
    if (num == 1) {
      this.lPad = map(value, 0, 127, 8, 1);
      this.lAI = false;
    } else if (num == 2) {
      this.rPad = map(value, 0, 127, 8, 1);
      this.rAI = false;
    }
  }
  
  private void resetGame() {
    this.resetBall();  
    this.lScore = this.rScore = 0;
  }
  
  private void resetBall() {
    xPos = 4.5;
    yPos = 5.0;
    xVel = random(0.002, 0.004);
    if (((int)random(0, 1)) == 1) {
      xVel = -xVel;
    }
    if (lScore > 5 || rScore > 5) {
      lScore = rScore = 0;
    }
    yVel = random(0.002, 0.005);
    waitToStart = 1000;
  }
  
  protected void run(int deltaMs) {   
    if (waitToStart > 0) {
      waitToStart -= deltaMs;
    } else {
      xPos += xVel * deltaMs;
      yPos += yVel * deltaMs;
      if (xVel < 0 && lAI) {
        float sign = (lPad < yPos) ? 1 : -1;
        float mv = min(0.01 * deltaMs, abs(yPos - lPad));
        lPad += sign * mv;
      }
      if (xVel > 0 && rAI) {
        float sign = (rPad < yPos) ? 1 : -1;
        float mv = min(0.01 * deltaMs, abs(yPos - rPad));
        rPad += sign * mv;
      }
      
      // paddle connection!
      if (xPos < 0.5) {
        if (abs(yPos - lPad) > 2.0) {
          ++rScore;
          this.resetBall();
        } else {
          xVel = -xVel;
          xPos = 1.0 + xPos;
          yVel += xVel * random(0, 0.4);
          xVel += 0.001;
        }
      } else if (xPos > 8.5) {
        if (abs(yPos - rPad) > 2.0) {
          ++lScore;
          this.resetBall();
        } else {
          xVel = -xVel;
          xPos = 17.0 - xPos;
          yVel += xVel * random(0, 0.4);
          xVel -= 0.001;
        }
      }
    }
    
    // bouncing off top/bottom
    if (yPos < 1.5) {
      yVel = -yVel;
      yPos = 1.0 + yPos;
    } else if (yPos > 8.5) {
      yVel = -yVel;
      yPos = 17.0 - yPos;
    }
    
    float bgHue = this.bg.getValue();
    float brtVal = this.brt.getValue();
    for (int x = 0; x < WIDTH; ++x) {
      for (int y = 0; y < HEIGHT; ++y) {
        float d = dist(x, y, xPos, yPos);
        if (d < 1.2) {
          // ball
          this.colors[y*HEIGHT + x] = color(0, 0, max(0, 100 - d*80));
        } else {
          // background
          float brt = (y % 2 == 0) ^ (x % 2 == 0) ? brtVal : BRT_MAX-brtVal;
          this.colors[y*HEIGHT + x] = color(bgHue, 80, brt);
        }        
      }
    }

    for (int y = 0; y < HEIGHT; ++y) {
      if (abs(y - lPad) < 1.8) {
        this.colors[y * HEIGHT] = color(120, 100, max(0, 100 - 60 * abs(y - lPad)));
      }
      if (abs(y - rPad) < 1.8) {
        this.colors[y * HEIGHT + WIDTH - 1] = color(240, 100, max(0, 100 - 60 * abs(y - rPad)));
      }
    }
    for (int x = 0; x < 10; ++x) {
      this.colors[x] = color(0, 100, 20);
    }
    for (int x = 0; x < lScore; ++x) {
      this.colors[x] = color(120, 100, 100);
    }
    for (int x = 0; x < rScore; ++x) {
      this.colors[HEIGHT - 1 - x] = color(240, 100, 100);
    }
  }
}
