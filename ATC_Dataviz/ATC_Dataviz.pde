//****************************************************************
//This file is the main Processing file
//Color constants are in the main setup() part as well as overall dimensions
//****************************************************************

Aircraft[] Planes;

Shaper shaper_main;
Shaper shaper_in;
Shaper shaper_out;

String[] RawData;

float[] Lengths;

float SCALE = 3.2;
float HEIGHT_SCALE = 15;
float OVERALL_WIDTH = 1000;
float STEP = 25;
float STARTTIME = 11; //Used to offset times found in data

float AVG_LINE_HEIGHT = 3;
float AVG_LINE_LEFT = 20;
float AVG_LINE_RIGHT = 800;

float BASE = 475;
float ARC_BASELINE = 300;
float UPPER_BASE = 125;

color BACKGROUND;
color AVG_LINE_COLOR;
color MAIN_COLOR;
color IN_COLOR;
color OUT_COLOR;
color ARC_COLOR;
float ARC_OPACITY;

float arc_x;
float arc_y;
float arc_size;
float count;
float starting_count;
float ending_count;
float numberofac;
float sum;

Boolean current_main;
Boolean current_in;
Boolean current_out;

//****************************************************************
void setup() {

  //Useful info here!
  size(850, 600);  
  RawData = loadStrings("data.txt");
  MAIN_COLOR = color(#200034);
  AVG_LINE_COLOR = color(#F0F511);
  IN_COLOR = color(#03FFAD);
  OUT_COLOR = color(#F54FBB);
  ARC_COLOR = color(#1A74ED);
  ARC_OPACITY = 50;
  BACKGROUND = color(255);
  smooth();
  
  
  //Dump data into usable class container
  Planes = new Aircraft[RawData.length];  
  Lengths = new float[RawData.length];
  for (int i = 0; (i < RawData.length); i++) {
    String[] pieces = split(RawData[i],'\t');
    Planes[i] = new Aircraft(  pieces[0], 
                               int(pieces[1]),
                               new Time(float(pieces[2]),
                               float(pieces[3])),
                               new Time(float(pieces[4]),
                               float(pieces[5])),
                               pieces[6],
                               STARTTIME);
    Lengths[i] = Planes[i].getLength();
  }   
  
  Lengths = sort(Lengths);

}
//****************************************************************

void draw() {
  
  background(BACKGROUND);

  //Draw arcs with certain color and opacity
  for (int i = 0; i<Planes.length;i++) {
    if (Planes[i].callsign.length() == 0)
      break;
    fill(ARC_COLOR,ARC_OPACITY);
    arc_x = SCALE*(  Planes[i].checkinstart()+
                     ((Planes[i].checkoutstart()-Planes[i].checkinstart())/2)
                  );
    arc_y = ARC_BASELINE;
    arc_size = SCALE*Planes[i].getLength();
    arc(arc_x,arc_y,arc_size,arc_size,PI,2*PI);
    

  }
  
  //Setting constants related to next part
  sum = 0;
  numberofac = 0;
  current_main = false;
  current_in = false;
  current_out = false;
  shaper_main = new Shaper(MAIN_COLOR);
  shaper_in = new Shaper(IN_COLOR);
  shaper_out = new Shaper(OUT_COLOR);
  
  //Calculate how many aircraft are in the air and draw resulting graph
  
  //Generate how many aircraft are contained in the given slot
  for (int i =0; i<OVERALL_WIDTH;i+=STEP) {
    count = 0;
    starting_count = 0;
    ending_count = 0;
    for (int j = 0; j<Planes.length;j++) {
      if (Planes[j].callsign.length() == 0)
        break;
      if  ((Planes[j].checkinstart()<(i/SCALE))&&
          (Planes[j].checkoutstart()>(i/SCALE)))
        count ++;
      if  ((Planes[j].checkinstart()<(i/SCALE))&&
          (Planes[j].checkinstart()+(STEP/SCALE)>(i/SCALE)))
        starting_count ++;
      if  ((Planes[j].checkoutstart()<(i/SCALE))&&
          (Planes[j].checkoutstart()+(STEP/SCALE)>(i/SCALE)))
        ending_count ++;
    }
    
    //Keep track for average line
    sum += count;
    numberofac ++;
    
    //Build shapes using classes
    current_main = shape_shifter(shaper_main,count,
                                 current_main,i,BASE-count*HEIGHT_SCALE,BASE);
    current_in = shape_shifter(shaper_in,starting_count,
                                 current_in,i,UPPER_BASE-starting_count*HEIGHT_SCALE,UPPER_BASE);
    current_out = shape_shifter(shaper_out,ending_count,
                                 current_out,i,UPPER_BASE+ending_count*HEIGHT_SCALE,UPPER_BASE);

  }
  
  //Draw all the shapes
  shaper_main.draw_all();
  shaper_in.draw_all();
  shaper_out.draw_all();
  //Draw red average line
  sum /= numberofac;
  noStroke();
  fill(AVG_LINE_COLOR);
  rect(AVG_LINE_LEFT,BASE-sum*HEIGHT_SCALE,AVG_LINE_RIGHT,AVG_LINE_HEIGHT);
  
 

}

//****************************************************************

Boolean shape_shifter(Shaper shaper, float count, Boolean current, float x, float y,float base) {
  
  if(current) {
      if (count >0) {
        shaper.update(x+(STEP/2),y);
      }
      else {
        shaper.update(x+STEP,base);
        current = false;
      }
    }
    else {
      if (count >0) {
        shaper.add_Shape(x, base);
        shaper.update(x+(STEP/2),y);
        current = true;
      }
    }
    return current;
}
//****************************************************************
void mousePressed() {
  save("ATC-Dataviz.png"); 
} 
//****************************************************************
  

