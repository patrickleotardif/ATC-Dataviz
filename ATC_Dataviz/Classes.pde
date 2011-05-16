//*************************************************
//This file contains the following classes:
//Aircraft: container for data
//Time: Utility class to make things easier
//Shaper : To make pretty flow/bar graphs
//Shape: One shape that froms a series viewed as a graph
//Point: Duh
//*************************************************

class Aircraft
{
  String callsign;
  int altitude;
  Time checkin;
  Time checkout;
  String frequency;
  float starttime;
  
  Aircraft(String newcallsign, int newaltitude, Time newcheckin, Time newcheckout, String newfrequency, float newstarttime) {
    callsign = newcallsign;
    altitude = newaltitude;
    checkin = newcheckin;
    checkout = newcheckout;
    frequency = newfrequency;
    starttime = newstarttime;
  }
  
  float getLength(){
    return checkout.total() - checkin.total();
  }
  
  float checkinstart(){
    return (checkin.total() - (starttime*60));
  }
  float checkoutstart(){
    return (checkout.total() - (starttime*60));
  }
  
  
}

//*************************************************

class Time
{
  float hours;
  float minutes;
  
  Time(float newhours, float newminutes){
    hours = newhours;
    minutes = newminutes;
  }
  
  float total(){
    return ((hours*60)+minutes);
  }
}

//*************************************************

class Shaper
{
  Shape[] shapes;
  int num;
  color fill_color;
  
  Shaper(color new_fill_color) {
    shapes = new Shape[0];
    num = 0;
    fill_color = new_fill_color;
  }
  
  void add_Shape(float first_x,float first_y) {
    shapes = (Shape[])append(shapes, new Shape(first_x,first_y,fill_color));
    num++;
  }
  
  void update(float x,float y) {
    shapes[num-1].add_point(x,y);
  }
  
  void draw_all() {
    for(int i = 0; i < num;i++)
       shapes[i].draw_shape();
  }
}

//*************************************************

class Shape
{
  
 Point[] points;
 int num;
 color fill_color;
 
 Shape(float first_x, float first_y,color new_fill_color) {
   points = new Point[1];
   points[0] = new Point(first_x,first_y);
   num = 1;
   fill_color = new_fill_color;
 }
 
 void add_point(float next_point_x, float next_point_y) {
   points = (Point[])append(points, new Point(next_point_x,next_point_y)); 
   num++;
 }
 
 void draw_shape() {
   
   beginShape();
   fill(fill_color);
   
   curveVertex(points[0].x,points[0].y);
   for(int i=0;i<num;i++) {
      curveVertex(points[i].x,points[i].y);
   }
   curveVertex(points[num-1].x,points[num-1].y);
   
   endShape();
   
 }
 
}

//*************************************************

class Point
{
  float x;
  float y;
  
  Point(float new_x, float new_y) {
    x = new_x;
    y = new_y;
  }
  
}
  
//*************************************************
