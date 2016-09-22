#include <Arduino.h>

template <byte pin>

class Vibration {

  private:
   int val; 
   int vals[20];
   long sum;
   int i=0;
   float avg;

   int n = 0;
   int thresh;

   bool p1 = false;
   bool p2 = true;
   int tCount = 0;
   float freq = 0;

  public: 
  void configure(){
    pinMode(pin, INPUT);
  }

  float getFreq(){

      val = analogRead(pin);

  if(n<100){
    n++;
    calcAvg();
    thresh = avg;
    Serial.print("msg_init vib sen ");
    Serial.println(avg);
    if(n==99){
        Serial.print("t_");
        Serial.println(thresh);
      }
    return -1;
    }  

    calcAvg();
    //Serial.println(avg);
   tCount++;
  if(avg > thresh && !p1) {
      p1 = true;
      p2 = false;
      return -1;
    }

  if(avg < thresh && !p2){
      p1 = false;
      p2 = true;
      freq = 1/(tCount*0.02);
      tCount = 0;
    }

  if(tCount>200){
      freq = 0;
    }
    return freq;
    
  
  }

  void calcAvg(){
      
        sum=0;
        for(i=0; i<19; i++){
          vals[i] = vals[i+1];
          sum += vals[i];
        }

        vals[19] = val;
        sum+= val;
        avg = sum/20;
        
  }
 };
