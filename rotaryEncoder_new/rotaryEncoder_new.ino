#define ENCODER_OPTIMIZE_INTERRUPTS

#include <Encoder.h>

// Change these pin numbers to the pins connected to your encoder.
//   Best Performance: both pins have interrupt capability
//   Good Performance: only the first pin has interrupt capability
//   Low Performance:  neither pin has interrupt capability
Encoder rep0(2, 3);
//   avoid using pins with LEDs attached
int red0;
long pre0  = -999;

void setup() {
  Serial.begin(115200);
}

void loop() {
  long re0;
  re0 = rep0.read();
  if (re0 != pre0 ) {
    //raw value
    Serial.print("re0:");
    Serial.println(re0);
    //direction value
    if(re0>pre0) red0=1;
    else red0 = -1;
    Serial.print("red0:");
    Serial.println(red0);
    pre0 = re0;
}

}
