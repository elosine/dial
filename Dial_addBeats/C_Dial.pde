// DECLARE/INITIALIZE CLASS SET
DialSet dialz = new DialSet();

/**
 *
 *
 /// PUT IN SETUP ///
 osc.plug(dialz, "mk", "/mkdial");
 osc.plug(dialz, "rmv", "/rmvdial");
 osc.plug(dialz, "rmvall", "/rmvalldial");
 
 /// PUT IN DRAW ///
 dialz.drw();
 *
 *
 */


class Dial {

  // CONSTRUCTOR VARIALBES //
  int ix;
  float c, m, dia;
  float rad1, rad2;
  String dclr;
  int wt;
  // CLASS VARIABLES //
  float x1, y1, x2, y2, rad;
  float ang= -90.0;
  // CONSTRUCTORS //

  /// Constructor 1 ///
  Dial(int aix, float ac, float am, float adia, float arad1, float arad2, String adclr, int awt) {
    ix = aix;
    c = ac;
    m = am;
    dia = adia;
    rad1 = arad1;
    rad2 = arad2;
    dclr = adclr;
    wt = awt;

    rad = dia/2.0;
    x1 = (cos(radians(ang))*(rad1*rad))+c;
    y1 = (sin(radians(ang))*(rad1*rad))+m;
    x2 = (cos(radians(ang))*(rad2*rad))+c;
    y2 = (sin(radians(ang))*(rad2*rad))+m;
  } //end constructor 1

  //  DRAW METHOD //
  void drw() {
    ////Calculate x & y
    osc.send("/getkdata", new Object[]{ix}, sc);
    x1 = (cos(radians(ang))*(rad1*rad))+c;
    y1 = (sin(radians(ang))*(rad1*rad))+m;
    x2 = (cos(radians(ang))*(rad2*rad))+c;
    y2 = (sin(radians(ang))*(rad2*rad))+m;
    //detect event
    for (Timetrig inst : timetrigz.cset) {
      if (radians(ang) >= inst.strad && radians(ang) <= inst.endrad) {
       //send continuous data
       float eventnorm = (radians(ang) - inst.strad)/(inst.endrad-inst.strad) ;
        osc.send("/eventnorm", new Object[]{ix, inst.ix, inst.sclr, eventnorm}, sc); //sending: dial ix, event ix, event clr, normpos
      }
    }
    strokeWeight(wt);
    stroke( clr.get(dclr) );
    line(x1, y1, x2, y2);
  } //End drw

  //  GET ANGLE METHOD //
  void getang(float val) {
    ang = map(val, 0.0, 1.0, 0.0, 360.0);
    ang = ang-90.0;
  }
  //
  //
}  //End class

////////////////////////////////////////////////////////////
/////////////   CLASS SET     //////////////////////////////
////////////////////////////////////////////////////////////

class DialSet {
  ArrayList<Dial> cset = new ArrayList<Dial>();

  // Make Instance Method //
  void mk(int aix, int clkix, float arad1, float arad2, String aclr, int awt) {
    for (int i=bullseyeCAz.cset.size ()-1; i>=0; i--) {
      BullseyeCA inst = bullseyeCAz.cset.get(i);
      if (inst.ix == clkix) {
        float ac = inst.c;
        float am = inst.m;
        float adia = inst.w;
        cset.add( new Dial( aix, ac, am, adia, arad1, arad2, aclr, awt) );
        break;
      }
    }
  } //end mk method

  // Make Instance Method //
  void mkman(int aix, float ac, float am, float adia, float arad1, float arad2, String aclr, int awt) {
    cset.add( new Dial( aix, ac, am, adia, arad1, arad2, aclr, awt) );
  } //end mk method

  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Dial inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method

  // Draw Set Method //
  void drw() {
    for (Dial inst : cset) {
      inst.drw();
    }
  }//end drw method

  // Get Control value //
  void kdat(int ix, float val) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Dial inst = cset.get(i);
      if (inst.ix == ix) {
        inst.getang(val);
        break;
      }
    }
  } //End kval method
  //
  //
} // END CLASS SET CLASS