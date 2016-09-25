import grafica.*;  //<>//

import processing.serial.*;
import controlP5.*;
import java.text.DecimalFormat;

/*********************************************************/
ControlP5 cp5;
DropdownList dList;

float dhighest = 0;

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

int dispHOffset;
int dispWOffset; 
int freqHOffset;
int freqWOffset;

DecimalFormat df;

GPointsArray points;
GPlot plot;
int nPoints = 500;

int counter = 0;
/*********************************************************/


void setup() {
  
  cp5 = new ControlP5(this);
  df = new DecimalFormat("0.0");
  
  PImage logo = loadImage("cesslogo.png");
  
  // setup window
  background(255);
  size(1100, 800);
  image(logo,10,20, 300,140);
  
  
  dispHOffset = height/2;
  dispWOffset = width/2;
  freqHOffset = height/2;
  freqWOffset = width/2;
  
  // setup font style
  f = createFont("Arial", 16, true);
  textFont(f);
  
  //setup graph window
  setupGraph();
  
  // setup title
  textSize(50);
  title = "Dimensions";
  title_width = width/2-140; title_height = 60;
  fill(color(200,150,100));
  text("CAPOMAESTRO '16-17", title_width-130, 50);
  fill(color(100,150,200));
  text(title, title_width, title_height+50);
  textSize(30);
  fill(color(11,10,129));
  text("23rd September 2016", title_width-20, title_height+90);
  
  
  // setup label
  label_width = width/2-300;  label_height = height/2-50;
  textSize(40);
  fill(color(50,150,100));
  text("Displacement (mm) : ", dispWOffset-160, dispHOffset-120);
  textSize(26);
  fill(color(50,150,200));
  text("Current : ", label_width, label_height);
  text("Highest : ", label_width+300, label_height);
  
  textSize(20);
  fill(color(150,100,50));
  text("Frequency (Hz) : ", freqWOffset-500 , freqHOffset-2);
  
  // setup msg
  msg_width = width/2 + 170; msg_height = height/2-50;
  
 // setup comm port
  portNames = Serial.list();
  for(int i=0; i<portNames.length; i++){
     updateMsg(portNames[i]); 
  }
  
  dList = cp5.addDropdownList("list")
                .setPosition(width-200,25)
                .setSize(100,200)
                .setItemHeight(20)
                .setBarHeight(25)
                .setBackgroundColor(color(100,100,100))           
                .setColorBackground(color(100,100,100))
                .setColorLabel(255);
  
  cp5.addButton("btnSCAN")
     .setPosition(width-260,25)
     .setSize(50,25)
     .setColorBackground(color(100,100,100))
     .setCaptionLabel("SCAN");
  
  cp5.addButton("btnCLR")
     .setPosition(width-260,55)
     .setSize(50,25)
     .setColorBackground(color(100,100,100))
     .setCaptionLabel("CLEAR");
  
  cp5.addButton("btnRST")
     .setPosition(width-260,85)
     .setSize(50,25)
     .setColorBackground(color(100,100,100))
     .setCaptionLabel("RESET");
     
  dList.addItems(portNames);
  
  updateMinVal(100);
  updateThreshVal(200);
  updateMsg("messages");
  updateDisp(6.3);
  updateDisp(5.1);
  updateFreq1(0);
}

void draw(){
  fill(255);
  updateFreq1(random(0,50));
  
  if(port == null) {return;}
  
  if(port.available()>0){
   
    data = port.readStringUntil('\n');
    
  }
  if(data!=null){
    String[] s = data.split("_");
    
    try {
    
    if(s[0].equals("min")){
      
      updateMinVal(Float.parseFloat(s[1]));
      return;
    }
    
    if(s[0].equals("t")){ // threshold of vibartion snesor
     
      updateThreshVal(Float.parseFloat(s[1]));
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
    
    if(s[0].equals("f1")){
      
      updateFreq1(Float.parseFloat(s[1]));
      return;
    
    }
    
   } catch(Exception e){
     
     updateMsg(e.toString());  
   }
  }
  
  delay(40);

}

public void list(float choice){
 
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
    rect(width-200, 60, 100, 25); 
  fill(0);
  textSize(16);
   text("Min : " + val, width-190, 80);
  
}

public void updateThreshVal(float val){
  
  fill(255);
    rect(width-200, 85, 100, 25);
   fill(0);
    textSize(16);
   text("Thr : " + val, width-190, 105);
  
}

public void updateMsg(String s){
 
  fill(255);
  rect(width/2-370, height-100, 800, 25);
  fill(0);
  textSize(16);
   text(s, width/2-200, height-85);

}

public void updateDisp(float val){
  
  fill(255);
  rect(msg_width-350, msg_height-35, 170, 50);
  fill(0);
  textSize(56);
  text(df.format(val), msg_width-320, msg_height+10);

  if(dhighest < val){dhighest = val;}
    
    fill(255);
    rect(msg_width-50, msg_height-35, 170, 50);
    fill(0);
    textSize(56);
    text(df.format(dhighest), msg_width-30, msg_height+10);  

}

public void updateFreq1(float f){

  fill(255);
  rect(freqWOffset-340 , freqHOffset-31, 60, 30);
  fill(color(200,50,50));
  textSize(26);
  text(df.format(f), freqWOffset-340 , freqHOffset-2);
  updatePlot(f);
  
}

public void setupGraph(){

  points = new GPointsArray(nPoints);
  
  for(int i=0; i<nPoints; i++){
    points.add(i,0);
  }
  
  plot = new GPlot(this);
  plot.setPos(freqWOffset-520,freqHOffset);
  plot.setOuterDim(1000,300);
  plot.setXLim(0, 500);
  plot.setYLim(0, 50);
  plot.activatePanning();
  
  plot.setPoints(points);
}

 void updatePlot(float val){
   
   plot.addPoint(new GPoint(counter,random(-50,50)));
  plot.removePoint(0);
  counter++;
  if(counter>nPoints){counter=0;}
   plot.beginDraw();
   plot.drawBackground();
   plot.drawXAxis();
   plot.drawYAxis();
    plot.drawBox();
    plot.getMainLayer().drawPoints();
    plot.drawLines();
    //plot.getMainLayer().drawFilledContour(GPlot.HORIZONTAL,0);
    plot.endDraw();
   
 }

public void btnSCAN(){
 //cp5.get(Button.class,"btnSCAN").getName();
 dList.clear(); 
 portNames = Serial.list();
  dList.addItems(portNames);
}

public void btnCLR(){

  dhighest = 0;
  updateDisp(0);
  
}

public void btnRST(){

  try{
    
    port.write('u');
    updateDisp(0);
    dhighest = 0;
    
  } catch (Exception e){
    
    updateMsg(e.toString());
  }
  
  
}