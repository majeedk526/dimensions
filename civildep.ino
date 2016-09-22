#include "Distance.h"
#include "Vibration.h"

Distance<0> distance;
//Vibration<1> frq1;
//Vibration<2> frq2;
float disp;

void setup() {
  // put your setup code here, to run once:

  Serial.begin(9600);
  distance.configure();
}

void loop() {
  // put your main code here, to run repeatedly:

  disp = distance.getDistance();
  
  if(disp!=-1){
      Serial.print("d_");
      Serial.println(disp);  
    }
    
   //disp = frq1.getFreq();
  if(disp!=-1){
      //Serial.print("f1_");
      //Serial.println(disp);  
    }

   //disp = frq2.getFreq();
  if(disp!=-1){
      //Serial.print("f2_");
      //Serial.println(disp);  
    }
    
  delay(40);
}
