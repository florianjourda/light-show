/**
 * A Modulator is an abstraction for a variable with a value
 * that varies over time, such as an envelope or a low frequency
 * oscillator. Some modulators run continuously, others may
 * halt after they reach a certain value.
 */
abstract class Modulator {
  protected boolean running = false;
  protected float value;
  
  /**
   * Sets the Modulator in motion
   */
  public Modulator start() {
    this.running = true;
    return this;
  }
  
  /**
   * Pauses the modulator wherever it is. Internal state should
   * be maintained. A subsequent call to start() should result in
   * the Modulator continuing as it was running before.
   */
  public Modulator stop() {
    this.running = false;
    return this;
  }
  
  /**
   * Indicates whether this modulator is running.
   */
  public boolean isRunning() {
    return this.running;
  }

  /**
   * Invoking the trigger() method restarts a modulator from its
   * initial value, and should also start the modulator if it is
   * not already running.
   */
  abstract public Modulator trigger();

  /**
   * Retrieves the current value of the modulator.
   */
  public float getValue() {
    return this.value;
  }
  
  /**
   * Set the modulator to a certain value in its cycle.
   */
  public Modulator setValue(float value) {
    this.value = value;
    return this;
  }
  
  /**
   * Applies updates to the modulator for the specified number
   * of milliseconds. This method is invoked by the core engine.
   */
  abstract public void run(int deltaMs);
}

/**
 * This modulator is a simple linear ramp from one value to another
 * over a specified number of milliseconds.
 */
class LinearEnvelope extends Modulator {
  
  private float startVal;
  private float endVal;
  private int durationMs;

  private float step;
  
  public LinearEnvelope(float startVal, float endVal, int durationMs) {
    this.value = this.startVal;
    this.setRange(startVal, endVal, durationMs);
  }
  
  public LinearEnvelope trigger() {
    this.value = this.startVal;
    this.start();
    return this;
  }
  
  public LinearEnvelope setDuration(int durationMs) {
    this.step = (this.endVal - this.startVal) / (float) durationMs;
    return this;
  }
  
  public LinearEnvelope setRange(float startVal, float endVal, int durationMs) {
    this.durationMs = durationMs;
    return this.setRange(startVal, endVal);
  }

  public LinearEnvelope setRange(float startVal, float endVal) {
    this.startVal = startVal;
    this.endVal = endVal;
    this.step = (this.endVal - this.startVal) / (float) durationMs;
    if (this.value < min(this.startVal, this.endVal) ||
        this.value > max(this.startVal, this.endVal)) {
      this.value = this.startVal;
    }
    return this;
  }
  
  public void run(int deltaMs) {
    if (!this.running) {
      return;
    }
    this.value += this.step * (float) deltaMs;
    
    // Check for hitting the end of the envelope
    if (((this.step > 0) && (this.value > this.endVal)) ||
        ((this.step < 0) && (this.value < this.endVal))) {
      this.value = this.endVal;
      this.running = false;
    }
  }
}

/**
 * A click is a simple modulator that fires a value of 1 every
 * time its duration has passed. Otherwise it always returns 0.
 */
class Click extends Modulator {
  private int elapsedMs;
  private int durationMs;
  
  public Click(int durationMs) {
    this.elapsedMs = 0;
    this.durationMs = durationMs;
  }
  
  public Modulator trigger() {
    this.elapsedMs = 0;
    return this.start();
  }
  
  public Modulator fire() {
    this.elapsedMs = durationMs;
    return this.start();
  }
  
  public Click setDuration(int durationMs) {
    this.durationMs = durationMs;
    return this;
  }
  
  public void run(int deltaMs) {
    if (!this.running) {
      return;
    } 
    this.elapsedMs += deltaMs;
    this.value = 0.0;
    while (this.elapsedMs >= this.durationMs) {
      this.value = 1.0;
      this.elapsedMs -= this.durationMs;
    }
  }
  
  public boolean click() {
    return this.getValue() == 1.0;
  }
}

/**
 * Simple square wave LFO. Not damped. Oscillates between a low and
 * high value.
 */
class SquareLFO extends Modulator {
  private float lowVal;
  private float hiVal;
 
  private boolean high;
  private int thresholdMs;
  private int elapsedMs;
  
  public SquareLFO(float lowVal, float hiVal, int durationMs) {
    this.value = this.lowVal = lowVal;
    this.hiVal = hiVal;
    this.setDuration(durationMs);
  }
  
  public Modulator trigger() {
    this.high = false;
    return this.start();
  }
  
  public void run(int deltaMs) {
    if (!this.running) {
      return;
    }
    this.elapsedMs += deltaMs;
    if (this.elapsedMs >= this.thresholdMs) {
      this.high = !this.high;
      while (this.elapsedMs >= this.thresholdMs) {
        this.elapsedMs -= this.thresholdMs;
      }
    }
  }
  
  public SquareLFO setDuration(int durationMs) {
    this.thresholdMs = durationMs/2;
    return this;
  }
  
  public float getValue() {
    return this.high ? this.hiVal : this.lowVal;
  }
  
  public Modulator setValue(float value) {
    this.high = (value == this.hiVal);
    return this;
  }
}

/**
 * A triangular LFO is a simple linear modulator that oscillates
 * between a low and hi value over a specified time period.
 */
class TriangleLFO extends Modulator {
  private float startVal;
  private float endVal;
  private int durationMs;

  private float step;
  private boolean inverted = false;

  public TriangleLFO(float startVal, float endVal, int durationMs) {
    this.value = this.startVal = startVal;
    this.endVal = endVal;
    
    this.durationMs = durationMs;
    this.step = (endVal - startVal) * 2.0 / (float) durationMs;
    
    if (this.startVal > this.endVal) {
      float temp = this.startVal;
      this.startVal = this.endVal;
      this.endVal = temp;
      this.inverted = true;
    }
  }
 
  public TriangleLFO setDuration(int durationMs) {
    this.durationMs = durationMs;
    float stepMag = (endVal - startVal) * 2.0 / (float) durationMs;
    this.step = (this.step > 0) ? stepMag : -stepMag;
    return this;
  }
  
  public Modulator trigger() {
    if (this.inverted) {
      this.step = -abs(this.step);
      this.value = this.endVal;
    } else {
      this.step = abs(this.step);
      this.value = this.startVal;
    }
    return this.start();
  }
  
  public void run(int deltaMs) {
    if (!this.running) {
      return;
    }
    this.value += this.step * deltaMs;
    while (true) {
      boolean overshoot = (this.step > 0) && (this.value > this.endVal);
      boolean undershoot = (this.step < 0) && (this.value < this.startVal);
      if (overshoot) {
        this.value = this.endVal - (this.value - this.endVal);
        this.step = -this.step;
      } else if (undershoot) {
        this.value = this.startVal + (this.startVal - this.value);
        this.step = -this.step;
      } else {
        break;
      }
    }
  }
}

/**
 * A sawtooth LFO oscillates from one extreme value to another. When
 * the later value is hit, the oscillator rests to its initial value.
 */
class SawLFO extends Modulator {
  private float startVal;
  private float endVal;
  private int durationMs;
  private float step;
  
  public SawLFO(float startVal, float endVal, int durationMs) {
    this.value = this.startVal = startVal;
    this.endVal = endVal;
    this.setDuration(durationMs);
  }
   
  public SawLFO setDuration(int durationMs) {
    this.durationMs = durationMs;
    this.step = (this.endVal - this.startVal) / (float) durationMs;
    return this;
  }
  
  public Modulator trigger() {
    this.value = this.startVal;
    return this.start();
  }
  
  public void run(int deltaMs) {
    if (!this.running) {
      return;
    }
    this.value += this.step * deltaMs;
    if ((this.step > 0) && (this.value > this.endVal)) {
      this.value = this.startVal + (this.value - this.endVal);
    } else if ((this.step < 0) && (this.value < this.endVal)) {
      this.value = this.startVal - (this.endVal - this.value);
    }
  }
}

