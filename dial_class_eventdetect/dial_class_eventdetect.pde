import netP5.*;
import oscP5.*;

OscP5 osc;
NetAddress sc;

void setup() {
  size(500, 500);
  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);

  //Clock
  osc.plug(clockz, "mk", "/mkclock");
  osc.plug(clockz, "rmv", "/rmvclock");
  osc.plug(clockz, "rmvall", "/rmvallclock");
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

  clockz.mk( 0, 10.0, 10.0, width-20, "none", "seagreen", 5);
 // dialz.mk(0, width/2.0, height/2.0, width-20, 0.33, 0.66, "orange", 2);
  //timetrigz.mk(0, width/2.0, height/2.0, (width-20)/2.0, 4.5, 8.75, "plum", 20);
}

void draw() {
  background(0);
  clockz.drw();
  timetrigz.drw();
  dialz.drw();
}