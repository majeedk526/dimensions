#include <Arduino.h>

template <byte op_pin>

class Distance {

  public:
  
  void configure(){
      Serial.println("msg_Cofiguring pin");
      pinMode(op_pin, INPUT);
      
    }
  
  float getDistance(){

      if(N <250) {
        s = analogRead(op_pin); 
        Serial.println("msg_initialising sensor");
        calcAvg();
        minRawVal = avg;
        N++;
        return -1;
        }
        
      calcAvg();
      
      //def = ((avg-minRawVal)/interval) * maxDef;
      def = (avg-minRawVal)/res;
      //Serial.println(avg);
      //Serial.println(def);
      if(def<0){minRawVal += -def; def=0;}
      return def;
    }

    private:
    int s;
    float def, avg;
    float res = 2.5;
     int maxRawVal = 450;
     int minRawVal = 314;
    const float maxDef = 20.0; // in mm
    int interval = maxRawVal - minRawVal;
    int vals[20];
    long sum;
    int i, N = 0;

    void calcAvg(){

      s = analogRead(op_pin);
        sum=0;
        for(i=0; i<19; i++){
          vals[i] = vals[i+1];
          sum += vals[i];
        }
        
        vals[19] = s;
        sum+= vals[19];
        avg = sum/20.0;
      
      }
  
  };
