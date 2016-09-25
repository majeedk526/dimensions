#include "Distance.h"
#include "Vibration.h"

Distance<A0> distance;
Vibration<1> frq1;
float disp;
char c;

void setup() {

  Serial.begin(9600);
  distance.configure();
}

void loop() {

  if(Serial.available()){
    c = Serial.read();

    if(c=='u'){distance.N = 0;}
    
    }
  
  disp = distance.getDistance();
  
  if(disp!=-1){
      Serial.print("d_");
      Serial.println(disp);  
    }
    
   disp = frq1.getFreq();
  if(disp!=-1){
      Serial.print("f1_");
      Serial.println(disp);  
    }

    
  delay(40);
}
