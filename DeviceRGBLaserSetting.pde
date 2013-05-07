/**
 * This class represents all the settings available to the RGBLasers
 * on the different channels
 */
abstract class DeviceRGBLaserSetting {
 
 // category is defined in the subclasses
 abstract String category();
 String name;
 // dmxChannel is defined in the subclasses
 abstract int dmxChannel();
 int dmxValue;

  DeviceRGBLaserSetting(String name, int dmxValue) {
    this.name = name;
    this.dmxValue = dmxValue;
  }
}

class RGBLaserMode extends DeviceRGBLaserSetting {

  static final String category = "Mode";
  static final int dmxChannel = 1;
  
  RGBLaserMode(String name, int dmxValue) {
    super(name, dmxValue);
  }
  
  // I did not manage to get this static value from
  // an instance (this.getClass().getField("category"))
  String category() {
    return category;
  }
    
  int dmxChannel() {
    return dmxChannel;
  }
}

RGBLaserMode OFF = new RGBLaserMode("OFF", 0);
RGBLaserMode SOUNDACTIVE = new RGBLaserMode("SOUNDACTIVE", 50);
RGBLaserMode AUTO = new RGBLaserMode("AUTO", 100);
RGBLaserMode STATICPATTERNS = new RGBLaserMode("STATICPATTERNS", 150);
RGBLaserMode DYNAMICPATTERNS = new RGBLaserMode("DYNAMICPATTERNS", 200);

class RGBLaserPattern extends DeviceRGBLaserSetting {

  static final String category = "Pattern";
  static final int dmxChannel = 2;
  
  RGBLaserPattern(String name, int dmxValue) {
    super(name, dmxValue);
  }
  
  String category() {
    return category;
  }
    
  int dmxChannel() {
    return dmxChannel;
  }
}

class RGBLaserStaticPattern extends RGBLaserPattern {

  RGBLaserStaticPattern(String name, int dmxValue) {
    super(name, dmxValue);
  }
 
  boolean isStatic() {
    return true;
  }
}

RGBLaserStaticPattern ONECIRCLE = new RGBLaserStaticPattern("ONECIRCLE", 0);
RGBLaserStaticPattern EMPTYCIRCLE = new RGBLaserStaticPattern("EMPTYCIRCLE", 5);
RGBLaserStaticPattern DOTCIRCLE = new RGBLaserStaticPattern("DOTCIRCLE", 10);
RGBLaserStaticPattern SCANCIRCLE = new RGBLaserStaticPattern("SCANCIRCLE", 15);
RGBLaserStaticPattern TWOCIRCLES = new RGBLaserStaticPattern("TWOCIRCLES", 20);
RGBLaserStaticPattern THREECIRCLES = new RGBLaserStaticPattern("THREECIRCLES", 25);
RGBLaserStaticPattern FOURCIRCLES = new RGBLaserStaticPattern("FOURCIRCLES", 30);
RGBLaserStaticPattern TWOEMPTYCIRCLES = new RGBLaserStaticPattern("TWOEMPTYCIRCLES", 35);
RGBLaserStaticPattern TWODOTCIRCLES = new RGBLaserStaticPattern("TWODOTCIRCLES", 40);
RGBLaserStaticPattern HORIZONTALEXTENDLINE = new RGBLaserStaticPattern("HORIZONTALEXTENDLINE", 45);
RGBLaserStaticPattern HORIZONTALSHRINKLINE = new RGBLaserStaticPattern("HORIZONTALSHRINKLINE", 50);
RGBLaserStaticPattern HORIZONTALFLEXLINE = new RGBLaserStaticPattern("HORIZONTALFLEXLINE", 55);
RGBLaserStaticPattern HORIZONTALLINE = new RGBLaserStaticPattern("HORIZONTALLINE", 60);
RGBLaserStaticPattern HORIZONTALDOTLINE = new RGBLaserStaticPattern("HORIZONTALDOTLINE", 65);
RGBLaserStaticPattern VERTICALLINE = new RGBLaserStaticPattern("VERTICALLINE", 70);
RGBLaserStaticPattern VERTICALDOTLINE = new RGBLaserStaticPattern("VERTICALDOTLINE", 75);
RGBLaserStaticPattern DIAGONAL45 = new RGBLaserStaticPattern("DIAGONAL45", 80);
RGBLaserStaticPattern DOTDIAGONAL = new RGBLaserStaticPattern("DOTDIAGONAL", 85);
RGBLaserStaticPattern TWOHORIZONTALLINES = new RGBLaserStaticPattern("TWOHORIZONTALLINES", 90);
RGBLaserStaticPattern TWOHORIZONTALDOTLINES = new RGBLaserStaticPattern("TWOHORIZONTALDOTLINES", 95);
RGBLaserStaticPattern TWOVERTICALLINES = new RGBLaserStaticPattern("TWOVERTICALLINES", 100);
RGBLaserStaticPattern TWOVERTICALDOTLINES = new RGBLaserStaticPattern("TWOVERTICALDOTLINES", 105);
RGBLaserStaticPattern VLINE = new RGBLaserStaticPattern("VLINE", 110);
RGBLaserStaticPattern VDOTLINE = new RGBLaserStaticPattern("VDOTLINE", 115);
RGBLaserStaticPattern TRIANGLE1 = new RGBLaserStaticPattern("TRIANGLE1", 120);
RGBLaserStaticPattern DOTTRIANGLE1 = new RGBLaserStaticPattern("DOTTRIANGLE1", 125);
RGBLaserStaticPattern TRIANGLE2 = new RGBLaserStaticPattern("TRIANGLE2", 130);
RGBLaserStaticPattern DOTTRIANGLE2 = new RGBLaserStaticPattern("DOTTRIANGLE2", 135);
RGBLaserStaticPattern CHIASMALINE = new RGBLaserStaticPattern("CHIASMALINE", 140);
RGBLaserStaticPattern CHIASMDOTALINE = new RGBLaserStaticPattern("CHIASMDOTALINE", 145);
RGBLaserStaticPattern SQUARE = new RGBLaserStaticPattern("SQUARE", 150);
RGBLaserStaticPattern DOTSQUARE = new RGBLaserStaticPattern("DOTSQUARE", 155);
RGBLaserStaticPattern RECTANGLE = new RGBLaserStaticPattern("RECTANGLE", 160);
RGBLaserStaticPattern DOTRECTANGLE = new RGBLaserStaticPattern("DOTRECTANGLE", 165);
RGBLaserStaticPattern MANYHORIZONTALLINES = new RGBLaserStaticPattern("MANYHORIZONTALLINES", 170);
RGBLaserStaticPattern MANYVERTICALLINES = new RGBLaserStaticPattern("MANYVERTICALLINES", 175);
RGBLaserStaticPattern TETRAGON1 = new RGBLaserStaticPattern("TETRAGON1", 180);
RGBLaserStaticPattern TETRAGON2 = new RGBLaserStaticPattern("TETRAGON2", 185);  
RGBLaserStaticPattern PENTAGON1 = new RGBLaserStaticPattern("PENTAGON1", 190);
RGBLaserStaticPattern PENTAGON2 = new RGBLaserStaticPattern("PENTAGON2", 195);
RGBLaserStaticPattern PENTAGON3 = new RGBLaserStaticPattern("PENTAGON3", 200);
RGBLaserStaticPattern WAVELINE1 = new RGBLaserStaticPattern("WAVELINE1", 205);
RGBLaserStaticPattern WAVELINE2 = new RGBLaserStaticPattern("WAVELINE2", 210);
RGBLaserStaticPattern WAVELINE3 = new RGBLaserStaticPattern("WAVELINE3", 215);
RGBLaserStaticPattern WAVEDOTLINE = new RGBLaserStaticPattern("WAVEDOTLINE", 220);
RGBLaserStaticPattern SPIRALITYLINE = new RGBLaserStaticPattern("SPIRALITYLINE", 225);
RGBLaserStaticPattern WELCOME = new RGBLaserStaticPattern("WELCOME", 230);
RGBLaserStaticPattern HORIZONTALDOT = new RGBLaserStaticPattern("HORIZONTALDOT", 235);
RGBLaserStaticPattern VERTICALDOT = new RGBLaserStaticPattern("VERTICALDOT", 240);
RGBLaserStaticPattern MANYDOTS1 = new RGBLaserStaticPattern("MANYDOTS1", 245);
RGBLaserStaticPattern SQUAREDOT = new RGBLaserStaticPattern("SQUAREDOT", 250);
RGBLaserStaticPattern MANYDOTS2 = new RGBLaserStaticPattern("MANYDOTS2", 255);

class RGBLaserDynamicPattern extends RGBLaserPattern {

  RGBLaserDynamicPattern(String name, int dmxValue) {
    super(name, dmxValue);
  }
 
  boolean isStatic() {
    return false;
  }
}

// static patterns
RGBLaserDynamicPattern CIRCLETOBIG = new RGBLaserDynamicPattern("CIRCLETOBIG", 0);
RGBLaserDynamicPattern EMPTYCIRCLETOBIG = new RGBLaserDynamicPattern("EMPTYCIRCLETOBIG", 5);
RGBLaserDynamicPattern DOTCIRCLETOBIG = new RGBLaserDynamicPattern("DOTCIRCLETOBIG", 10);
RGBLaserDynamicPattern SCANCIRCLETOBIG = new RGBLaserDynamicPattern("SCANCIRCLETOBIG", 15);
RGBLaserDynamicPattern TWOCIRCLESROLL = new RGBLaserDynamicPattern("TWOCIRCLESROLL", 20);
RGBLaserDynamicPattern THREECIRCLESROLL = new RGBLaserDynamicPattern("THREECIRCLESROLL", 25);
RGBLaserDynamicPattern FOURCIRCLESROLL = new RGBLaserDynamicPattern("FOURCIRCLESROLL", 30);
RGBLaserDynamicPattern TWOEMPTYCIRCLESTURN = new RGBLaserDynamicPattern("TWOEMPTYCIRCLESTURN", 35);
RGBLaserDynamicPattern DOTCIRCLETOADD = new RGBLaserDynamicPattern("DOTCIRCLETOADD", 40);
RGBLaserDynamicPattern CIRCLEJUMP= new RGBLaserDynamicPattern("CIRCLEJUMP", 45);
RGBLaserDynamicPattern SCANCIRCLEEXTEND = new RGBLaserDynamicPattern("SCANCIRCLEEXTEND", 50);
RGBLaserDynamicPattern CIRCLEFLASH = new RGBLaserDynamicPattern("CIRCLEFLASH", 55);
RGBLaserDynamicPattern EMPTYCIRLCEROLL = new RGBLaserDynamicPattern("EMPTYCIRLCEROLL", 60);
RGBLaserDynamicPattern TWOCIRCLETURN = new RGBLaserDynamicPattern("TWOCIRCLETURN", 65);
RGBLaserDynamicPattern FOURCIRCLETURN = new RGBLaserDynamicPattern("FOURCIRCLETURN", 70);
RGBLaserDynamicPattern DIAGONALJUMP = new RGBLaserDynamicPattern("DIAGONALJUMP", 75);
RGBLaserDynamicPattern SECTORTOBIG = new RGBLaserDynamicPattern("SECTORTOBIG", 80);
RGBLaserDynamicPattern DOTSECTORTOBIG = new RGBLaserDynamicPattern("DOTSECTORTOBIG", 85);
RGBLaserDynamicPattern DIAGNOALMOVE = new RGBLaserDynamicPattern("DIAGNOALMOVE", 90);
RGBLaserDynamicPattern DOTDIAGNOALMOVE = new RGBLaserDynamicPattern("DOTDIAGNOALMOVE", 95);
RGBLaserDynamicPattern LONGSECTORROUND = new RGBLaserDynamicPattern("LONGSECTORROUND", 100);
RGBLaserDynamicPattern SHORTSECTORROUND = new RGBLaserDynamicPattern("SHORTSECTORROUND", 105);
RGBLaserDynamicPattern THREELINEROUND = new RGBLaserDynamicPattern("THREELINEROUND", 110);
RGBLaserDynamicPattern HORIZONTALLINEMOVE = new RGBLaserDynamicPattern("HORIZONTALLINEMOVE", 115);
RGBLaserDynamicPattern HORIZONTALDOTLINEMOVE = new RGBLaserDynamicPattern("HORIZONTALDOTLINEMOVE", 120);
RGBLaserDynamicPattern TWOHORIZONTALLINEMOVE = new RGBLaserDynamicPattern("TWOHORIZONTALLINEMOVE", 125);
RGBLaserDynamicPattern TWOHORIZONTALDOTLINEMOVE = new RGBLaserDynamicPattern("TWOHORIZONTALDOTLINEMOVE", 130);
RGBLaserDynamicPattern VERTICALLINEMOVE = new RGBLaserDynamicPattern("VERTICALLINEMOVE", 135);
RGBLaserDynamicPattern VERTICALDOTLINEMOVE = new RGBLaserDynamicPattern("VERTICALDOTLINEMOVE", 140);
RGBLaserDynamicPattern TWOVERTICALLINEMOVE = new RGBLaserDynamicPattern("TWOVERTICALLINEMOVE", 145);
RGBLaserDynamicPattern TWOVERTICALDOTLINEMOVE = new RGBLaserDynamicPattern("TWOVERTICALDOTLINEMOVE", 150);
RGBLaserDynamicPattern SQUAREEXTEND = new RGBLaserDynamicPattern("SQUAREEXTEND", 155);
RGBLaserDynamicPattern DOTSQUAREEXTEND = new RGBLaserDynamicPattern("DOTSQUAREEXTEND", 160);
RGBLaserDynamicPattern PENTAGONEXTEND = new RGBLaserDynamicPattern("PENTAGONEXTEND", 165);
RGBLaserDynamicPattern SQUARETURN = new RGBLaserDynamicPattern("SQUARETURN", 170);
RGBLaserDynamicPattern PENTAGONTURN = new RGBLaserDynamicPattern("PENTAGONTURN", 175);
RGBLaserDynamicPattern LINESCAN = new RGBLaserDynamicPattern("LINESCAN", 180);
RGBLaserDynamicPattern DOTLINESCAN = new RGBLaserDynamicPattern("DOTLINESCAN", 185);  
RGBLaserDynamicPattern WAVETURN = new RGBLaserDynamicPattern("WAVETURN", 190);
RGBLaserDynamicPattern DOTWAVETURN = new RGBLaserDynamicPattern("DOTWAVETURN", 195);
RGBLaserDynamicPattern WAVEFLOWING = new RGBLaserDynamicPattern("WAVEFLOWING", 200);
RGBLaserDynamicPattern DOTWAVEFLOWING= new RGBLaserDynamicPattern("DOTWAVEFLOWING", 205);
RGBLaserDynamicPattern SINEWAVE = new RGBLaserDynamicPattern("SINEWAVE", 210);
RGBLaserDynamicPattern DOTSINEWAVE = new RGBLaserDynamicPattern("DOTSINEWAVE", 215);
RGBLaserDynamicPattern TETRAGONTURN = new RGBLaserDynamicPattern("TETRAGONTURN", 220);
RGBLaserDynamicPattern PENTAGONSTARONETURN = new RGBLaserDynamicPattern("PENTAGONSTARONETURN", 225);
RGBLaserDynamicPattern PENTAGONSTARTWOTURN = new RGBLaserDynamicPattern("PENTAGONSTARTWOTURN", 230);
RGBLaserDynamicPattern SQUAREDOTJUMP = new RGBLaserDynamicPattern("SQUAREDOTJUMP", 235);
RGBLaserDynamicPattern BIRDFLY = new RGBLaserDynamicPattern("BIRDFLY", 240);
RGBLaserDynamicPattern MANYDOTONE = new RGBLaserDynamicPattern("MANYDOTONE", 245);
RGBLaserDynamicPattern VPATTERNMOVE = new RGBLaserDynamicPattern("VPATTERNMOVE", 250);
RGBLaserDynamicPattern MANYDOTTWO = new RGBLaserDynamicPattern("MANYDOTTWO", 255);

class RGBLaserColorSelection extends DeviceRGBLaserSetting {

  static final String category = "Color Selection";
  static final int dmxChannel = 6;
  
  RGBLaserColorSelection(String name, int dmxValue) {
    super(name, dmxValue);
  }

  String category() {
    return category;
  }
    
  int dmxChannel() {
    return dmxChannel;
  }
}

RGBLaserColorSelection S = new RGBLaserColorSelection("S", 0);
RGBLaserColorSelection G = new RGBLaserColorSelection("G", 30);
RGBLaserColorSelection R = new RGBLaserColorSelection("R", 60);
RGBLaserColorSelection SG = new RGBLaserColorSelection("SG", 90);
RGBLaserColorSelection GV = new RGBLaserColorSelection("GV", 120);
RGBLaserColorSelection VS = new RGBLaserColorSelection("VS", 150);
RGBLaserColorSelection VGS = new RGBLaserColorSelection("VGS", 180);
RGBLaserColorSelection MOVINGVGS = new RGBLaserColorSelection("MOVINGVGS", 210);

// @TODO make them as objects too?
int FAST = 0;
int SLOW = 255;
int SMALL = 0;
int BIG = 255; 
