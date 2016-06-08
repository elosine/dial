import netP5.*;
import oscP5.*;

OscP5 osc;
NetAddress sc;

int eventix = 0;

void setup() {
  size(500, 500);
  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);

  //Bullseye
  osc.plug(bullseyez, "mk", "/mkclock");
  osc.plug(bullseyez, "rmv", "/rmvclock");
  osc.plug(bullseyez, "rmvall", "/rmvallclock");
  //Dial
  osc.plug(dialz, "mk", "/mkdial");
  osc.plug(dialz, "mkman", "/mkdialman");
  osc.plug(dialz, "rmv", "/rmvdial");
  osc.plug(dialz, "rmvall", "/rmvalldial");
  osc.plug(dialz, "kdat", "/kdat");
  //Timetrig
  osc.plug(timetrigz, "mk", "/mktimetrig");
  osc.plug(timetrigz, "mkman", "/mktimetrigman");
  osc.plug(timetrigz, "rmv", "/rmvtimetrig");
  osc.plug(timetrigz, "rmvall", "/rmvalltimetrig");
  osc.plug(timetrigz, "mktimer", "/mktimer");

  bullseyez.mk( 0, 10.0, 10.0, width-20, "none", "seagreen", 5);
  dialz.mk(0, 0, 0.0, 1.0, "orange", 2) ;
  // events(13,20,0,new String[]{"goldenrod", "chocolate", "indigo", "pink", "TranquilBlue", "mint", "pine", "white"}, 2.0, 4.5);
}

void draw() {
  background(0);
  bullseyez.drw();
  timetrigz.drw();

  //Bullseye
  //make bullseye part of clock (rename) and string to int array for ring size or an auto constructor based on number of rings, still load to int array
  float c1 = 0.0;
  float m1 = 0.0;
  float d1 = 0.0;
  int nrings = 7;
  nrings = nrings+1;
  float ringw = (width-50.0)/nrings;
  for (Bullseye inst : bullseyez.cset) {
    if (inst.ix == 0) { 
      c1=inst.c; 
      m1 = inst.m;
      d1 = inst.dia;
    }
  }
  ellipseMode(CENTER);
  noStroke();
  fill ( int(random(255)), int(random(255)), int(random(255)));

  for (int i=0; i<nrings; i++) {
    fill( i*60, 255-(i*30), 128+(i*20));
    ellipse(c1, m1, d1-(ringw*i), d1-(ringw*i));
  }

  dialz.drw();
}

void events(int numevents_lo, int numevents_hi, int clkix, String[] clrs, float durlo, float durhi) {
  int numevents = int(random(numevents_lo, numevents_hi));
  for (int i=0; i<numevents; i++) {
    eventix++;
    float st = random(12.0);
    float dur = random(durlo, durhi);
    float end = st + dur;
    String cl = clrs[int(random(clrs.length))];

    timetrigz.mk( eventix, clkix, ( 1000 - 70 - ( (140*i)%980 ) )/1000.0, st, end, cl, int(random(3, 14)));
  }
}

/*
add transparency to events
 */