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
  float[][] tg;
  boolean hl = false;
  int hln = 0;
  int csr = 0;
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
      coord[i][0] = ( cos( radians( (inc*i)-90.0 ) ) * r1 ) + c;
      coord[i][1] = ( sin( radians( (inc*i)-90.0 ) ) * r1 ) + m;
      coord[i][2] = ( cos( radians( (inc*i)-90.0 ) ) * r2 ) + c;
      coord[i][3] = ( sin( radians( (inc*i)-90.0 ) ) * r2 ) + m;
    }
    tg = new float[nbt][4]; //position, color, shape, size
    for (int i=0; i<nbt; i++) {
      tg[i][0]= -1.0;
      tg[i][1]=1.0;
      tg[i][2]=0.0;
      tg[i][3]=7.0;
    }
  } //end constructor 1

  //  DRAW METHOD //
  void drw() {
    stroke(clr.get(sclr));
    strokeCap(SQUARE);
    strokeWeight(1);
    for (int i=0; i<nbt; i++) line(coord[i][0], coord[i][1], coord[i][2], coord[i][3]);
    //Highlight Beat
    if (hl) {
      strokeWeight(7);
      strokeCap(ROUND);
      switch(csr) {
      case 0:
        stroke(255, 255, 0, 150);
        break;
      case 1:
        stroke(30, 144, 255, 150);
        break;
      case 2:
        stroke(255, 128, 0, 150);
        break;
      }
      line(coord[hln][0], coord[hln][1], coord[hln][2], coord[hln][3]);
    }
    //Beat Targets
    for (int i=0; i<nbt; i++) {
      if (tg[i][0]>0) {
        //position
        //  float tgx = ( cos( radians( (inc*i)-90.0 ) ) * r1+(tg[i][0]*(r2-r1))  ) + c;
        //float tgy = ( cos( radians( (inc*i)-90.0 ) ) * r1+(tg[i][0]*(r2-r1))  ) + c;
        float tgx = ( cos( radians( (inc*i)-90.0 ) ) * (r1+((1.0-tg[i][0])*(r2-r1))) ) + c;
        float tgy = ( sin( radians( (inc*i)-90.0 ) ) * (r1+((1.0-tg[i][0])*(r2-r1))) ) + m;
        ellipseMode(CENTER);
        noStroke();
        //color
        switch(int(tg[i][1])) {
        case 1:
          fill(255, 0, 0);
          break;
        }
        //shape
        switch(int(tg[i][2])) {
        case 0:
          ellipse(tgx, tgy, tg[i][3], tg[i][3]);
          break;
        }
      }
    }
  } //End drw

  //Make Beat Targets Method
  void mktg(float pos, int clr, int shp, int sz) {
    tg[hln][0] = pos;
    tg[hln][1] = clr;
    tg[hln][2] = shp;
    tg[hln][3] = sz;
    osc.send("/mkbt", new Object[]{ix, hln}, sc);
  } //end mktg


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

  // Change Highlight Method //
  void hl(int ix, int inc) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Beatgrid inst = cset.get(i);
      if (inst.ix == ix) {
        int hln = (inst.hln+inc)%inst.nbt;
        if (hln== (-1)) inst.hln = inst.nbt-1;
        else inst.hln = hln;
      }
    }
  } //End hl method

  // Make Beat Target Method //
  void mktg(int ix, float pos, int clr, int shp, int sz) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Beatgrid inst = cset.get(i);
      if (inst.ix == ix) {
        if (inst.tg[inst.hln][0] == -1) inst.mktg(pos, clr, shp, sz);
        else {
          inst.tg[inst.hln][0] = -1;
          osc.send("/rmvbt", new Object[]{ix, inst.hln}, sc);
        }
      }
    }
  } //End mktg method

  // Make Beat Target Method //
  void rmvtg(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Beatgrid inst = cset.get(i);
      if (inst.ix == ix) {
        inst.tg[inst.hln][0] = -1;
      }
    }
  } //End rmvtg method

  // Change Track Method //
  void chtr(int ix) { 
    for (Beatgrid inst : cset) {
      inst.hl = false;
    }
    if (ix > -1) {
      for (int i=cset.size ()-1; i>=0; i--) {
        Beatgrid inst = cset.get(i);
        if (inst.ix == ix) {
          inst.hl = true;
          inst.hln = 0;
        }
      }
    }
  } //End chtr method

  // Get Beat Grids Method //
  void gtbtgr() {
    for (Beatgrid inst : cset) {
      int tnbts = (inst.bpercyc/inst.ndiv)*inst.nsdiv;
      float blen = 1.0/tnbts;
      osc.send("/btgr", new Object[] {inst.ix, blen, tnbts}, sc);
    }
  } //End gtbgr method

  // Change Csr Method //
  void chgcsr(int csrn) {
    for (Beatgrid inst : cset) {
      inst.csr = csrn;
    }
  } //End chgcsr method


  //
  //
} // END CLASS SET CLASS