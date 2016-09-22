import processing.serial.*;
import controlP5.*;
import java.text.DecimalFormat;

/*********************************************************/
ControlP5 cp5;
DropdownList dList;

Serial port;
String[] portNames;
String data;
PFont f;

int ht = 50;
int side = 20;
float theta = 0.0;

String title;
int title_width, title_height;

String label;
int label_width, label_height;
int msg_width, msg_height;

DecimalFormat df;

/*********************************************************/


void setup() {
  
  cp5 = new ControlP5(this);
  df = new DecimalFormat("#.0");
  
  // setup window
  background(255);
  size(1024, 520);
  
  // setup font style
  f = createFont("Arial", 16, true);
  textFont(f);
  
  // setup title
  textSize(60);
  title = "Dimensions";
  title_width = width/2-140; title_height = 60;
  fill(color(100,150,200));
  text(title, title_width, title_height);
  
  
  // setup label
  label_width = width/2-300;  label_height = height/2-50;
  textSize(26);
  fill(color(50,150,100));
  text("Displacement (mm) : ", label_width, label_height);
  
  fill(color(150,100,50));
  text("Frequency 1 (Hz) : ", label_width, label_height+50);
  text("Frequency 2 (Hz) : ", label_width, label_height+100);
  
  // setup msg
  msg_width = width/2 + 170; msg_height = height/2-50;
  
 // setup comm port
  portNames = Serial.list();
  for(int i=0; i<portNames.length; i++){
     println(portNames[i]); 
  }
  
  dList = cp5.addDropdownList("list")
                .setPosition(width-160,25)
                .setSize(150,200)
                .setItemHeight(20)
                .setBarHeight(25)
                .setBackgroundColor(255)           
                .setColorLabel(255);
  dList.addItems(portNames);
  
 // port = new Serial(this,portNames[0], 9600);
  
  updateMinVal(100);
  updateMaxVal(200);
  updateMsg("messages");
  updateDisp(20.1);
  updateFreq(2.3, 5.4);
  
}

void draw(){

  
  if(port == null) {return;}
  
  if(port.available()>0){
   
    data = port.readStringUntil('\n');
    
  }
  if(data!=null){
    String[] s = data.split("_"); //<>//
    
    if(s[0].equals("min")){ //<>//
      
      updateMinVal(Float.parseFloat(s[1]));
      return;
    }
    
    if(s[0].equals("max")){
     
      updateMaxVal(Float.parseFloat(s[1]));
      return;
      
    }
    
    if(s[0].equals("msg")){
      updateMsg(s[1]);
      return;
    
    }
    
    if(s[0].equals("d")){ // displacement
      updateDisp(Float.parseFloat(s[1]));
      return;
    }
    
    if(s[0].equals("f")){
      
      updateFreq(Float.parseFloat(s[1]), Float.parseFloat(s[2] ));
      return;
    
    }
    
  }
  
  delay(100);

}

public void list(float choice){
 
  //println(choice);
  //println(cp5.get(DropdownList.class,"list").getValue());
  try {
    updateMsg("initiaitng port " + portNames[(int) choice]);
    port = new Serial(this,portNames[(int) choice], 9600);
    updateMsg("Success : port intialised");
  } catch (Exception e){
    updateMsg(e.toString());
  }
}

public void updateMinVal(float val){

  fill(255);
    rect(width-150, 160, 130, 25); 
  fill(0);
  textSize(16);
   text("Min : " + val, width-120, 180);
  
}

public void updateMaxVal(float val){
  
  fill(255);
    rect(width-150, 190, 130, 25);
   fill(0);
    textSize(16);
   text("Max : " + val, width-120, 210);
  
}

public void updateMsg(String s){
 
  fill(255);
  rect(width/2-370, height-50, 800, 25);
  fill(0);
  textSize(16);
   text(s, width/2-200, height-35);

}

public void updateDisp(float val){

  fill(255);
  rect(msg_width-200, msg_height-35, 150, 50);
  fill(0);
  textSize(56);
  text(df.format(val), msg_width-170, msg_height+10);

}

public void updateFreq(float f1, float f2){

  fill(255);
  rect(msg_width-200, msg_height+21, 150, 50);
  fill(0);
  textSize(56);
  text(df.format(f1), msg_width-170, msg_height+67);
  fill(255);
  rect(msg_width-200, msg_height+76, 150, 50);
  fill(0);
  text(df.format(f2), msg_width-170, msg_height+120);
  
}