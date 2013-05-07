/**
 * A mask represents a selection of pixels on the 9*9 LED wall.
 * For example a mask can be a square or a line or other forms.
 * Pixels can be selected or not, or also have a transparency
 * alpha value between 0 (not selected) and 255 (selected).
 */
abstract class Mask {
  int[][] alpha;
}

class LineMask extends Mask {
  static final int HORIZONTAL = 0;
  static final int VERTICAL = 1;
  
  LineMask(int direction) {
  }
}
