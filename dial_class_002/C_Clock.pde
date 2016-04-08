// DECLARE/INITIALIZE CLASS SET
ClockSet clockz = new ClockSet();

/**
 *
 *
 /// PUT IN SETUP ///
 osc.plug(clockz, "mk", "/mkclock");
 osc.plug(clockz, "rmv", "/rmvclock");
 osc.plug(clockz, "rmvall", "/rmvallclock");
 
 /// PUT IN DRAW ///
 clockz.drw();
 *
 *
 */


class Clock {

  // CONSTRUCTOR VARIALBES //
  int ix;
  float x, y, dia;
  String bgclr;
  String strclr;
  int strwt;
  // CLASS VARIABLES //
  float l, r, t, b, c, m, rad;
  // CONSTRUCTORS //

  /// Constructor 1 ///
  Clock(int aix, float ax, float ay, float adia, String abgclr, String astrclr, int astrwt) {
    ix = aix;
    x = ax;
    y = ay;
    dia = adia;
    bgclr = abgclr;
    strclr = astrclr;
    strwt = astrwt;

    l=x;
    r=x+dia;
    t=y;
    b=y+dia;
    c=l+(dia/2.0);
    m=t+(dia/2.0);
    rad=dia/2.0;
  } //end constructor 1

  //  DRAW METHOD //
  void drw() {
    if ( bgclr.equals("none") ) noFill();
    else fill(clr.get(bgclr));
    if ( strclr.equals("none") ) noStroke();
    else stroke(clr.get(strclr));
    strokeWeight(strwt);
    ellipseMode(CENTER);
    ellipse(c, m, dia, dia);
    //center
    noStroke();
    if ( strclr.equals("none") ) noFill();
    else fill(clr.get(strclr));
    ellipse(c, m, 15, 15);
  } //End drw
  //
  //
}  //End class

////////////////////////////////////////////////////////////
/////////////   CLASS SET     //////////////////////////////
////////////////////////////////////////////////////////////

class ClockSet {
  ArrayList<Clock> cset = new ArrayList<Clock>();

  // Make Instance Method //
  void mk(int aix, float ax, float ay, float adia, String abgclr, String astrclr, int astrwt) {
    cset.add( new Clock( aix, ax, ay, adia, abgclr, astrclr, astrwt) );
  } //end mk method

  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Clock inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method

  // Draw Set Method //
  void drw() {
    for (Clock inst : cset) {
      inst.drw();
    }
  }//end drw method
  //
  //
} // END CLASS SET CLASS