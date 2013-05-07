import dmxP512.*;
import processing.serial.*;

int universeSize = 512;
boolean buffered = false;
String DMXPRO_PORT =  "COM18";//"/dev/ttys005";//case matters ! on windows port must be upper cased.
int DMXPRO_BAUDRATE = 115000;  

/**
 * This class represents the DMX driver that outputs to the Enttec USB-DMX dongle.
 * It is just a wrapper to catch some exception and fix some bugs
 */
class DMXOutput {
  DmxP512 dmxP512;
  PApplet pApplet;
  
  DMXOutput(PApplet pApplet) { 
    this.dmxP512 = new DmxP512(pApplet, universeSize, buffered);
  }
  
  void setup() {
    this.dmxP512.setupDmxPro(DMXPRO_PORT, DMXPRO_BAUDRATE);
  }
  
  /**
   * Reset all channels to 0
   */
  void reset() {
    // reset is not working for some reason so we do it by hand
    //this.dmxP512.reset();
    println("Reset");
    int[] zeros = new int[511];
    Arrays.fill(zeros, 0);
    this.dmxP512.set(1, zeros);
    println("End");
  }
  
  /**
   * Set the value (0 to 255) of a channel (1 to 512)
   */
  void set(int address, int value) {
    this.dmxP512.set(address, value);
  }
  
  void set(int address, int[] values) {
    this.dmxP512.set(address, values); 
  }
}

/**
 * This class represents objects that send DMX signal to DMX devices
 */
abstract class DeviceDMX {

  final static int firstDMXAddress = 1;
  
  int channelCount;
  int DMXAddress;

  DeviceDMX(int channelCount, int DMXAddress) {
    this.channelCount = channelCount;
    this.DMXAddress = DMXAddress;
    println("New " + this);
  }
  
  String toString() {
    return "DeviceDMX with address " + binary(this.DMXAddress) + " over " + this.channelCount + " channels"; 
  }

  int nextDMXAddress() {
    return this.DMXAddress + this.channelCount;
  }
  
  void setChannelValue(int channel, int value) {
    //println("DMX: set " + (this.DMXAddress + channel - 1) + " to " + value);
    dmxOutput.set(this.DMXAddress + channel - 1, value);
  }
  
  void setChannelValues(int[] channelValues) {
    dmxOutput.set(this.DMXAddress, channelValues);
  }
}
