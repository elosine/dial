#define NB 3
#include <digitalWriteFast.h>

//BUTTONS
////Momentary button vars
int bp[NB] = {4,5,6}; //arduino input pin numbers
boolean bg[NB] = {true, true, true};
//Toggle button vars
int btv[NB] = {0, 0,0};
int btamt[NB] = {2, 2,2};
boolean btg[NB] = {true, true,true};

//these pins can not be changed 2/3 are special pins
int encoderPin1 = 2;
int encoderPin2 = 3;

volatile int lastEncoded = 0;
volatile float encoderValue = 0;
int rev = 0;
int prev = 0;

long lastencoderValue = 0;

int lastMSB = 0;
int lastLSB = 0;

void setup() {
  Serial.begin (38400);
  for (int i = 0; i < NB; i++) pinMode(bp[i], INPUT_PULLUP);

  pinMode(encoderPin1, INPUT);
  pinMode(encoderPin2, INPUT);

  digitalWrite(encoderPin1, HIGH); //turn pullup resistor on
  digitalWrite(encoderPin2, HIGH); //turn pullup resistor on

  //call updateEncoder() when any high/low changed seen
  //on interrupt 0 (pin 2), or interrupt 1 (pin 3)
  attachInterrupt(0, updateEncoder, CHANGE);
  attachInterrupt(1, updateEncoder, CHANGE);

}

void loop() {
  rev = int(encoderValue);
  if (rev != prev) {
    Serial.print("rer0:");
    Serial.println(rev);
    if (rev > prev) {
      Serial.print("re0:");
      Serial.println(1);
    }
    else {
      Serial.print("re0:");
      Serial.println(-1);
    }
  }
  prev = rev;
 
  //BUTTONS
  for (int i = 0; i < NB; i++) {
    if ( digitalReadFast(bp[i]) == LOW) { //button pushed
      //momentary
      if (bg[i]) {
        bg[i] = false;
        Serial.print("b");
        Serial.print(String(i));
        Serial.print(":");
        // Serial.print( "b" + String(i) + ":");
        Serial.println(1);
      }
      //toggle
      if (btg[i]) {
        btg[i] = false;
        btv[i] = (btv[i] + 1) % btamt[i];
        Serial.print( "bt" + String(i) + ":");
        Serial.println(btv[i]);
      }
    }
    else { //button released
      //momentary
      if (!bg[i]) {
        bg[i] = true;
        Serial.print( "b" + String(i) + ":");
        Serial.println(0);
      }
      //toggle
      if (!btg[i]) {
        btg[i] = true;
      }
    }
  }
  
  delay(5);  
}


void updateEncoder() {
  int MSB = digitalReadFast(encoderPin1); //MSB = most significant bit
  int LSB = digitalReadFast(encoderPin2); //LSB = least significant bit

  int encoded = (MSB << 1) | LSB; //converting the 2 pin value to single number
  int sum  = (lastEncoded << 2) | encoded; //adding it to the previous encoded value

  if (sum == 0b1101 || sum == 0b0100 || sum == 0b0010 || sum == 0b1011) encoderValue = encoderValue - 0.5;
  if (sum == 0b1110 || sum == 0b0111 || sum == 0b0001 || sum == 0b1000) encoderValue = encoderValue + 0.5;

  lastEncoded = encoded; //store this value for next time
}
