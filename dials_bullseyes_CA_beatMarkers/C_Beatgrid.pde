// DECLARE/INITIALIZE CLASS SET
BeatgridSet beatgridz = new BeatgridSet();

/**
 *
 *
 /// PUT IN SETUP ///
 osc.plug(beatgridz, "mk", "/mkbeatgrid");
 osc.plug(beatgridz, "rmv", "/rmvbeatgrid");
 
 /// PUT IN DRAW ///
 beatgridz.drw();
 *
 *
 */


class Beatgrid {

  // CONSTRUCTOR VARIALBES //
  int ix, beix, rnum;
  int bpercyc, ndiv, nsdiv;
  String sclr;
  // CLASS VARIABLES //
  float c, m;
  int r1, r2;
  int nbt;
  float inc;
  float[][] coord;
  // CONSTRUCTORS //

  /// Constructor 1 ///
  Beatgrid(int aix, int abeix, int arnum, int abpercyc, int andiv, int ansdiv, String asclr) {
    ix = aix;
    beix = abeix;
    rnum = arnum;
    bpercyc = abpercyc;
    ndiv = andiv;
    nsdiv = ansdiv;
    sclr = asclr;

    for (BullseyeCA inst : bullseyeCAz.cset) {
      if (beix == inst.ix) {
        c = inst.c;
        m = inst.m;
        r1 = inst.rc[rnum][0];
        r2 = inst.rc[rnum][1];
      }
    }

    nbt = floor( (bpercyc*nsdiv)/ndiv );
    inc = 360.0/nbt;
    coord = new float [nbt][4];
    for (int i=0; i<nbt; i++) {
      coord[i][0] = ( cos( radians( (inc*i)-45.0 ) ) * r1 ) + c;
      coord[i][1] = ( sin( radians( (inc*i)-45.0 ) ) * r1 ) + m;
      coord[i][2] = ( cos( radians( (inc*i)-45.0 ) ) * r2 ) + c;
      coord[i][3] = ( sin( radians( (inc*i)-45.0 ) ) * r2 ) + m;
    }
  } //end constructor 1

  //  DRAW METHOD //
  void drw() {

    /*
    //event on off
     for (Dial inst : dialz.cset) {
     if (radians(inst.ang) >= strad && radians(inst.ang) <= endrad) {
     //event on trigger
     if (on) {
     on = false;
     osc.send("/eventon", new Object[]{inst.ix, ix, sclr}, sc); //sending: dial ix, event ix, event clr
     }
     } else { 
     if (!on) {
     on = true;
     osc.send("/eventoff", new Object[]{inst.ix, ix, sclr}, sc);
     }
     }
     }
     */



    stroke(clr.get(sclr));
    strokeCap(SQUARE);
    strokeWeight(1);
    for (int i=0; i<nbt; i++) line(coord[i][0], coord[i][1], coord[i][2], coord[i][3]);
  } //End drw


  //
  //
}  //End class

////////////////////////////////////////////////////////////
/////////////   CLASS SET     //////////////////////////////
////////////////////////////////////////////////////////////

class BeatgridSet {
  ArrayList<Beatgrid> cset = new ArrayList<Beatgrid>();

  // Make Instance Method //
  void mk(int aix, int abeix, int arnum, int abpercyc, int andiv, int ansdiv, String asclr) {
    cset.add( new Beatgrid( aix, abeix, arnum, abpercyc, andiv, ansdiv, asclr) );
  } //end mk method


  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Beatgrid inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method

  // Draw Set Method //
  void drw() {
    for (Beatgrid inst : cset) {
      inst.drw();
    }
  }//end drw method

 
  //
  //
} // END CLASS SET CLASS