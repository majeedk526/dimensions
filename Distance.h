#include <Arduino.h>

template <byte op_pin>

class Distance {

  public:
  int N=0;
  
  void configure(){
      pinMode(op_pin, INPUT);
      
    }
  
  float getDistance(){

      if(N <150) { 
        calcAvg();
        minRawVal = avg;
        Serial.print("msg_init dist sen");
        Serial.println(avg);
        N++;
        if(N==149){
            Serial.print("min_");
            Serial.println(minRawVal);
            Serial.println("msg_READY");
          }
        return -1;
        }
        
      calcAvg();
      
      //def = ((avg-minRawVal)/interval) * maxDef;
      //Serial.print("avg_");
      //Serial.println(avg);
      def = (avg-minRawVal)/res;
     // if(def-prev < 0.4 && def-prev > -0.4) {def = prev;}
      prev = def;
      if(def<0.5){def=0;}
      return def;
    }

    private:
    int s;
    float def, avg, prev;
    float res = 2.6;
     int maxRawVal = 450;
     int minRawVal = 314;
    const float maxDef = 20.0; // in mm
    int interval = maxRawVal - minRawVal;
    int vals[30];
    long sum;
    int i;

    void calcAvg(){

      s = analogRead(op_pin);
        sum=0; avg = 0;
        for(i=0; i<29; i++){
          vals[i] = vals[i+1];
          sum += vals[i];
        }
        
        vals[29] = s;
        sum+= s;
        avg = sum/30.0;
      
      }
  
  };
