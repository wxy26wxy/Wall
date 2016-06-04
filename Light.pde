public class Light{
  FPoly self;
  FPoly line;
  boolean isTouch = false;
  boolean isStarted = false;
  PVector drop_point;
  PVector touch_point;
  Light(int x, int y){
    self =  new FPoly();
    self.setPosition(x,y);
    //self.vertex(-25,-100);
    //self.vertex(25,-100);
    //self.vertex(125,100);
    //self.vertex(-125,100);
    //self.setFill(255, 255, 100);
    
    
    self.vertex(0,0);
    
    self.setStatic(true);
    self.setSensor(true);
    world.add(self);
    
    line = new FPoly();
    line.setPosition(x,y);
    line.vertex(-2,200);
    line.vertex(-2,300);
    line.vertex(-25,300);
    line.vertex(-25,350);
    line.vertex(25,350);
    line.vertex(25,300);
    line.vertex(2,300);
    line.vertex(2,200);
    line.setStatic(true);
    line.setSensor(true);
    world.add(line);
    
    touch_point = new PVector(x,y);
    drop_point = new PVector(x,y);
  }
  
  void drawLines(){
    if (isTouch){
      //drop_point.x, drop_point.y
      pushStyle();
      strokeWeight(4);
      stroke(255);
      line(drop_point.x-40, drop_point.y,drop_point.x-60, drop_point.y+100);
      line(drop_point.x-10, drop_point.y+10,drop_point.x-20, drop_point.y+100-10);
      line(drop_point.x+20, drop_point.y-20,drop_point.x+60, drop_point.y+100-20);
      line(drop_point.x+50, drop_point.y-30,drop_point.x+100, drop_point.y+100-25);
      popStyle();
    }
  }
  
  void loop(){
     if (isTouch){
      self.setDrawable(false);
      if (frameCount%50==1) {
          Letter l = new Letter(int(drop_point.x +random (-20,20)), int(drop_point.y), int(random(0, 25)));
        }
    }
    else{
      self.setDrawable(false);
    }
    if (!isStarted){
      self.setDrawable(true);
    }
    
  }
}