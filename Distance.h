#include <Arduino.h>

template <byte op_pin>

class Distance {

  public:
  
  void configure(){
      pinMode(op_pin, INPUT);
      
    }
  
  float getDistance(){

      if(N <150) {
        s = analogRead(op_pin); 
        calcAvg();
        minRawVal = avg;
       // Serial.print("msg_init dist sen");
        //Serial.println(avg);
        N++;
        if(N==149){
          //  Serial.print("min_");
            //Serial.println(minRawVal);
          }
        return -1;
        }
        
      calcAvg();
      
      //def = ((avg-minRawVal)/interval) * maxDef;
      //Serial.print("avg_");
      //Serial.println(avg);
      def = (avg-minRawVal)/res;
      if(def-prev < 0.5 && def-prev > -0.5) {def = prev;}
      prev = def;
      if(def<0.5){def=0;}
      return def;
    }

    private:
    int s;
    float def, avg, prev;
    float res = 2.5;
     int maxRawVal = 450;
     int minRawVal = 314;
    const float maxDef = 20.0; // in mm
    int interval = maxRawVal - minRawVal;
    int vals[10];
    long sum;
    int i, N = 0;

    void calcAvg(){

      s = analogRead(op_pin);
        sum=0; avg = 0;
        for(i=0; i<9; i++){
          vals[i] = vals[i+1];
          sum += vals[i];
        }
        
        vals[9] = s;
        sum+= s;
        avg = sum/10.0;
      
      }
  
  };
