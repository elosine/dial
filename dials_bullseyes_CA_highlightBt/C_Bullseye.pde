// DECLARE/INITIALIZE CLASS SET
BullseyeSet bullseyez = new BullseyeSet();

/**
 *
 *
 /// PUT IN SETUP ///
 osc.plug(bullseyez, "mk", "/mkbullseye");
 osc.plug(bullseyez, "rmv", "/rmvbullseye");
 osc.plug(bullseyez, "rmvall", "/rmvallbullseye");
 
 /// PUT IN DRAW ///
 bullseyez.drw();
 *
 *
 */


class Bullseye {

  // CONSTRUCTOR VARIALBES //
  int ix;
  float x, y, dia;
  String bgclr;
  String strclr;
  int strwt;
  int nrings;
  // CLASS VARIABLES //
  float l, r, t, b, c, m, rad;
  float ringw;
  // CONSTRUCTORS //

  /// Constructor 1 ///
  Bullseye(int aix, float ax, float ay, float adia, String abgclr, String astrclr, int astrwt, int anrings) {
    ix = aix;
    x = ax;
    y = ay;
    dia = adia;
    bgclr = abgclr;
    strclr = astrclr;
    strwt = astrwt;
    nrings = anrings;

    l=x;
    r=x+dia;
    t=y;
    b=y+dia;
    c=l+(dia/2.0);
    m=t+(dia/2.0);
    rad=dia/2.0;

    nrings = nrings+1;
    ringw = (dia-50.0)/nrings;
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

class BullseyeSet {
  ArrayList<Bullseye> cset = new ArrayList<Bullseye>();

  // Make Instance Method //
  void mk(int aix, float ax, float ay, float adia, String abgclr, String astrclr, int astrwt, int anrings) {
    cset.add( new Bullseye( aix, ax, ay, adia, abgclr, astrclr, astrwt, anrings) );
  } //end mk method

  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Bullseye inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method

  // Draw Set Method //
  void drw() {
    for (Bullseye inst : cset) {
      inst.drw();
    }
  }//end drw method
  //
  //
} // END CLASS SET CLASS