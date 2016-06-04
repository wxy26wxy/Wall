public class Shelf{
 PVector position;
 boolean create = false;
 boolean isRotate = false;
 boolean isBack = true;
 FPoly self;
 
 Shelf(int _x, int _y){
  position = new PVector(_x, _y);
   self = new FPoly();
   self.setPosition(_x, _y);
   self.setFill(255);
   self.setStrokeWeight(3);
   //self.setRestitution(1);
 }
 
 void create_self(){
   self = new FPoly();
   self.setPosition(position.x,position.y);
   self.setFill(255);
   self.setStatic(true);
 }
 void end_create_self(){
   world.add(self);
   println("Shelf created, x = ", self.getX(), self.getY());
   create = false;
 }
 void loop(){
   if (isRotate &&self.getRotation() <= PI/3){
     self.adjustRotation(0.05);
   }
   else{
     isRotate = false;
   }
   if (isBack && self.getRotation() >= 0 ){
     self.adjustRotation(-0.05);
   }
   else{
     isBack = false;
   }
 }
 
 
 void rotate(){
   self.adjustRotation(PI/3);
 }
 
 void back(){
   self.adjustRotation(-PI/3);
 }
}