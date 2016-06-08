// DECLARE/INITIALIZE CLASS SET
TimetrigSet timetrigz = new TimetrigSet();

/**
 *
 *
 /// PUT IN SETUP ///
 osc.plug(timetrigz, "mk", "/mktimetrig");
 osc.plug(timetrigz, "rmv", "/rmvtimetrig");
 osc.plug(timetrigz, "rmvall", "/rmvalltimetrig");
 
 /// PUT IN DRAW ///
 timetrigz.drw();
 *
 *
 */


class Timetrig {

  // CONSTRUCTOR VARIALBES //
  int ix;
  float c, m, rad, st, end;
  String sclr;
  int wt;
  // CLASS VARIABLES //
  float stnorm, endnorm, strad, endrad;
  boolean on = true;
  // CONSTRUCTORS //

  /// Constructor 1 ///
  Timetrig(int aix, float ac, float am, float arad, float ast, float aend, String asclr, int awt) {
    ix = aix;
    c = ac;
    m = am;
    rad = arad;
    st = ast;
    end = aend;
    sclr = asclr;
    wt = awt;

    stnorm = map(st, 0.0, 12.0, 0.0, 1.0);
    endnorm = map(end, 0.0, 12.0, 0.0, 1.0);
  } //end constructor 1

  //  DRAW METHOD //
  void drw() {

    strad = map(st, 0.0, 12.0, 0.0, TWO_PI);
    strad = strad-HALF_PI;
    endrad = map(end, 0.0, 12.0, 0.0, TWO_PI);
    endrad = endrad-HALF_PI;
    //event on off
    for (Dial inst : dialz.cset) {
      if (radians(inst.ang) >= strad && radians(inst.ang) <= endrad) {
        //event on trigger
        if (on) {
          on = false;
          osc.send("/eventon", new Object[]{inst.ix, ix, sclr}, sc); //sending: dial ix, event ix, event clr
        }
      }
      else{ 
        if (!on) {
          on = true;
          osc.send("/eventoff", new Object[]{inst.ix, ix, sclr}, sc);
        }
        
      }
    }


    noFill();
    stroke(clr.get(sclr));
    strokeCap(SQUARE);
    strokeWeight(wt);
    arc(c, m, rad, rad, strad, endrad);
  } //End drw

  // GET TIMER 
  void mktimer() {
    osc.send("/timer", new Object[]{ix, stnorm, endnorm}, sc);
  }
  //
  //
}  //End class

////////////////////////////////////////////////////////////
/////////////   CLASS SET     //////////////////////////////
////////////////////////////////////////////////////////////

class TimetrigSet {
  ArrayList<Timetrig> cset = new ArrayList<Timetrig>();

  // Make Instance Method //
  void mk(int aix, int clkix, float aradiusnorm, float ast, float aend, String asclr, int awt) {
    for (int i=bullseyez.cset.size ()-1; i>=0; i--) {
      Bullseye inst = bullseyez.cset.get(i);
      if (inst.ix == clkix) {
        float ac = inst.c;
        float am = inst.m;
        float aradius = map(aradiusnorm, 0.0, 1.0, 0.0, inst.dia);
        cset.add( new Timetrig( aix, ac, am, aradius, ast, aend, asclr, awt) );
        break;
      }
    }
  } //end mk method

  // Make Instance Method //
  void mkman(int aix, float ac, float am, float arad, float ast, float aend, String asclr, int awt) {
    cset.add( new Timetrig( aix, ac, am, arad, ast, aend, asclr, awt) );
  } //end mk method

  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Timetrig inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method

  // Draw Set Method //
  void drw() {
    for (Timetrig inst : cset) {
      inst.drw();
    }
  }//end drw method

  // Make Timer //
  void mktimer(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Timetrig inst = cset.get(i);
      if (inst.ix == ix) {
        inst.mktimer();
        break;
      }
    }
  } //End mktimer method
  //
  //
} // END CLASS SET CLASS