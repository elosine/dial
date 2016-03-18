import netP5.*;
import oscP5.*;

OscP5 osc;
NetAddress sc;
float x, y, w, h, l, r, t, b, c, m, ra;
float dx2, dy2;
float ang = 30.0;
float stnorm, endnorm;

void setup() {
  size(500, 500);
  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);
  osc.plug(this, "kval", "/kdat");
  x=0.0;
  y=0.0;
  w=width-20;
  h=w;
  l=x;
  r=x+w;
  t=y;
  b=y+h;
  c=l+(w/2.0);
  m=t+(h/2.0);
  ra=w/2.0;
  ang = ang-90.0;
}

void draw() {
  background(0);
  //Background Circle
  noFill();
  strokeWeight(3);
  stroke(153, 255, 0);
  ellipseMode(CENTER);
  ellipse(c, m, w, h);
  clkobj(2.0, 5.0);
  //dial
  ////Calculate x & y
  osc.send("/getkdata", new Object[]{0}, sc);
  dx2 = (cos(radians(ang))*ra)+c;
  dy2 = (sin(radians(ang))*ra)+m;
  strokeWeight(2);
  stroke(255, 128, 0);
  line(c, m, dx2, dy2);
}


void clkobj(float st, float end) {
  stnorm = map(st, 0.0, 12.0, 0.0, 1.0);
  endnorm = map(end, 0.0, 12.0, 0.0, 1.0);
  float strad = map(st, 0.0, 12.0, 0.0, TWO_PI);
  strad = strad-HALF_PI;
  float endrad = map(end, 0.0, 12.0, 0.0, TWO_PI);
  endrad = endrad-HALF_PI;
  // fill(255,0,255);
  stroke(255, 0, 255);
  strokeCap(SQUARE);
  strokeWeight(19);
  arc(c, m, w/2, h/2, strad, endrad);
}
void mousePressed() {
  //create corresponding timer in sc to arc-timer-object
  osc.send("/timer", new Object[]{stnorm, endnorm}, sc);
}

void kval(int bus, float v) {
  ang = map(v, 0.0, 1.0, 0.0, 360.0);
  ang = ang-90.0;
}