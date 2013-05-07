class ProgramTetris extends Program {
  
  private final int STEP_TIME = 200;
  private final int GAME_OVER_TIME = 3000;  
  
  private int accum = 0;
  
  private boolean[] grid;
  
  private Piece currentPiece;
  private ArrayList lines;
  private boolean gameOver = false;

  private TriangleLFO bgMod = new TriangleLFO(0, 10, 3500);
  private SawLFO pieceMod = new SawLFO(0, 359, 4000);
  
  public ProgramTetris() {
    super("Tetris", HSB);
    this.grid = new boolean[WIDTH * HEIGHT];
    for (int i = 0; i < this.grid.length; ++i) {
      this.grid[i] = false;
    }
    this.currentPiece = this.nextPiece();
    this.lines = new ArrayList();
    this.addModulator(this.bgMod.trigger());
    this.addModulator(this.pieceMod.trigger());
  }
  
  public int getLevel(int x) {
     print(" |b x:" + x);
    for (int i = 0; i < WIDTH; ++i) {
      if (this.grid[x + WIDTH*i]) {
        return WIDTH-i;
      }
    }
    return 0;
  }
  
  protected void run(int deltaMs) {
    this.accum += deltaMs;
    if (this.gameOver) {
      if (this.accum > this.GAME_OVER_TIME) {
        this.accum -= this.GAME_OVER_TIME;
        this.gameOver = false;
      }
    } else if (this.accum > this.STEP_TIME) {
      this.step();
      this.accum -= this.STEP_TIME;
    }
    this.currentPiece.draw(false);
  }
  
  public void step() {
    this.clearLines();
    this.currentPiece.fall();
    this.findLines();
  }
  
  private void findLines() {
    this.lines = new ArrayList();
    for (int y = 0; y < WIDTH; ++y) {
      boolean hasLine = true;
      for (int x = 0; x < WIDTH; ++x) {
        if (!this.grid[x + WIDTH*y]) {
          hasLine = false;
        }
      }
      if (hasLine) {
        this.lines.add(y);
      }
    }
  }
  
  private void clearLines() {
    for (int y = 0; y < WIDTH; ++y) {
      boolean hasLine = true;
      for (int x = 0; x < WIDTH; ++x) {
        if (!this.grid[x + WIDTH*y]) {
          hasLine = false;
          break;
        }
      }
      if (hasLine) {
        for (int yy = y; yy > 0; --yy) {
          for (int x = 0; x < WIDTH; ++x) {
            colors[x + WIDTH*yy] = colors[x + WIDTH*(yy-1)];
            grid[x + WIDTH*yy] = grid[x + WIDTH*(yy-1)];
          }
        }
        for (int x = 0; x < WIDTH; ++x) {
          grid[x] = false;
        }
      }
    }
  }
  
  private Piece nextPiece() {
    Piece piece = new Square();
    switch ((int) random(0, 7)) {
      case 0: piece = new Ell(); break;
      case 1: piece = new Tee(); break;
      case 2: piece = new Line(); break;
      case 3: piece = new Fwomp(); break;
      case 4: piece = new Ess(); break;
      case 5: piece = new Zee(); break;
    }
    piece.rotate((int) random(0, 4));
    piece.xPos = (int) random(0, 11-piece.width());
    piece.computeTargets();
    
    return piece;
  }
  
  abstract class Piece {
    
    private int xPos = 0, yPos = 0;
    protected int[][] offsets; // array of x/y offset pairs
    protected int hVal;
    
    private int xTarget;
    private int rotationTarget;
    
    public Piece() {
      this.hVal = (int) random(0, 360);
    }
    
    public void fall() {
      if (this.xPos > this.xTarget) {
        --this.xPos;
      } else if (this.xPos < this.xTarget) {
        ++this.xPos;
      }
      if ((this.yPos >= this.height()) && this.rotationTarget > 0) {
        if (this.rotationTarget == 2) {
          this.rotate(1);
          this.rotationTarget = 1;
        } else {
          this.rotate(this.rotationTarget);
          this.rotationTarget = 0;
        }
        this.xPos = min(this.xPos, WIDTH - this.width());
      }
      
      if (this.floored()) {
        this.draw(true);
        if (this.yPos - this.height() < 0) {
          // GAME OVER
          gameOver = true;
          for (int i = 0; i < grid.length; ++i) {
            grid[i] = false;
          }
        }
        currentPiece = nextPiece();
      } else {
        ++this.yPos;
      }
    }
    
    public int width() {
      int w = 1;
      for (int i = 0; i < this.offsets.length; ++i) {
        w = max(w, this.offsets[i][0] + 1);
      }
      return w;
    }
    
    public int height() {
      int h = 1;
      for (int i = 0; i < this.offsets.length; ++i) {
        h = max(h, this.offsets[i][1] + 1);
      }
      return h;
    }
    
    public void computeTargets() {
      int best = 1000;
      int rotation = 0;
      int x = 0;
      
      for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 11 - this.width(); ++j) {
          int sc = this.score(j);
          if (sc < best) {
             rotation = i;
             x = j;
             best = sc;
          }
        }
        this.rotate(1);
      }
      
      // set the targets
      this.xTarget = x;
      this.rotationTarget = rotation;
    }
    
    public int score(int x) {
      int w = this.width();
      
      int[] floors = new int[w];
      int[] ceilings = new int[w];
      int[] dists = new int[w];
      for (int i = 0; i < w; ++i) {
        ceilings[i] = WIDTH;
        floors[i] = WIDTH;
      }
      for (int i = 0; i < this.offsets.length; ++i) {
        int xoff = this.offsets[i][0];
        floors[xoff] = min(floors[xoff], this.offsets[i][1]);
      }
      for (int i = 0; i < w; ++i) {
            print(" |a x:" + x);
        int l = getLevel(x + i);
        dists[i] = WIDTH + floors[i] - l;
        ceilings[i] = min(ceilings[i], l + floors[i]);
      }
      
      int center = (int) abs(x - 4.5 + w);
      
      int base = -5*min(dists) + 3*this.height() - center;
      
      if (dists.length > 1) {
        for (int i = 0; i < dists.length - 1; ++i) {
          if (dists[i] != dists[i+1]) {
            return 100  + base;
          }
        }
      }

      return base; // perfect flat fit
    }
    
    public void rotate(int iterations) {
      for (int i = 0; i < iterations; ++i) {
        int xMin = 2;
        int yMin = 0;
        for (int j = 0; j < this.offsets.length; ++j) {
          int tmp = this.offsets[j][0];
          this.offsets[j][0] = this.offsets[j][1];
          this.offsets[j][1] = -tmp;
          xMin = min(xMin, this.offsets[j][0]);
          yMin = min(yMin, this.offsets[j][1]);
        }
        for (int j = 0; j < this.offsets.length; ++j) {
          this.offsets[j][0] -= xMin;
          this.offsets[j][1] -= yMin;
        }
      }
    }
    
    private boolean floored() {
      for (int i = 0; i < this.offsets.length; ++i) {
        int x = this.xPos + this.offsets[i][0];
        int y = this.yPos - this.offsets[i][1];
        if (y >= 9) {
          return true;
        }
        int idx = (y+1)*WIDTH + x;
        if (idx >= 0 && idx < 100 && grid[idx]) {
          return true;
        }
      }
      return false;
    }
            
    public void draw(boolean cement) {
      if (gameOver) {
        for (int i = 0; i < 100; ++i) {
          color c = colors[i];
          colors[i] = color(hue(c), saturation(c), max(0, brightness(c)-2));
        }
        return;
      }
      
      for (int i = 0; i < WIDTH * HEIGHT; ++i) {
        if (!grid[i]) {
          if ((i + (i/HEIGHT)%2) % 2 == 0) {
            colors[i] = color(0, 0, 0);
          } else {
            colors[i] = color(100, 50, 0.25 * (bgMod.getValue() * i / 80.0 + (i / 40.0)));
          }
        }
      }
      
      for (int i = 0; i < lines.size(); ++i) {
        int y = (Integer) lines.get(i);
        for (int x = 0; x < WIDTH; ++x) {
          colors[y*WIDTH + x] = color(0, 0, 100.0 - 100.0 * (float) accum / (float) STEP_TIME);
        }
      }
      
      for (int i = 0; i < this.offsets.length; ++i) {
        int x = this.xPos + this.offsets[i][0];
        int y = this.yPos - this.offsets[i][1];
        if (x >= 0 && x < HEIGHT && y >=0 && y < WIDTH) {
          colors[y*HEIGHT + x] = color((this.hVal + pieceMod.getValue()) % 360, 100, 100);
          if (cement) {
            grid[y*HEIGHT + x] = true;
          }
        }
      }
    }
  }
  
  class Ell extends Piece {
    private final int[][] myOffsets = {{0,0}, {1, 0}, {2, 0}, {0, 1}};
    
    public Ell() {
      this.offsets = this.myOffsets;
    }
  }

  class Fwomp extends Piece {
    private final int[][] myOffsets = {{0,0}, {1, 0}, {2, 0}, {2, 1}};
    
    public Fwomp() {
      this.offsets = this.myOffsets;
    }
  }
  
  class Square extends Piece {
    private final int[][] myOffsets = {{0,0}, {0, 1}, {1, 0}, {1, 1}};
    
    public Square() {
      this.offsets = this.myOffsets;
    }
  }
  
  class Tee extends Piece {
    private final int[][] myOffsets = {{0, 0}, {1, 0}, {2, 0}, {1, 1}};
    
    public Tee() {
      this.offsets = this.myOffsets;
    }
  }
  
  class Line extends Piece {
    private final int[][] myOffsets = {{0, 0}, {1, 0}, {2, 0}, {3, 0}};
    
    public Line() {
      this.offsets = this.myOffsets;
    }
  }

  class Ess extends Piece {
    private final int[][] myOffsets = {{0, 0}, {1, 0}, {1, 1}, {2, 1}};
    
    public Ess() {
      this.offsets = this.myOffsets;
    }
  }
  
  class Zee extends Piece {
    private final int[][] myOffsets = {{0, 0}, {0, 1}, {1, 1}, {1, 2}};
    
    public Zee() {
      this.offsets = this.myOffsets;
    }
  }
}
