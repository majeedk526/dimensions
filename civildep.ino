#include "Distance.h"
#include "Vibration.h"

Distance<0> distance;
Vibration<1> frq1;
Vibration<2> frq2;
float disp;

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

   disp = frq1.getFreq();
  if(disp!=-1){
      Serial.println(disp);  
    }

   disp = frq2.getFreq();
  if(disp!=-1){
      Serial.println(disp);  
    }
    
  delay(2);
}
