#include "Distance.h"

Distance<0> distance;
int disp;

void setup() {
  // put your setup code here, to run once:

  Serial.begin(9600);
  Serial.println("msg_setup");
  distance.configure();
  
}

void loop() {
  // put your main code here, to run repeatedly:

  disp = distance.getDistance();
  if(disp!=-1){
      Serial.println(disp);  
    }
  
  delay(10);
}
