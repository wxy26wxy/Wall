public class Wind {
  PVector position;
  boolean create = false;
  boolean isRotate = false;
  boolean isBack = true;
  FPoly self;

  Wind(int _x, int _y) {
    position = new PVector(_x, _y);
    self = new FPoly();
    self.setPosition(_x, _y);
    self.setFill(255);
    self.setStrokeWeight(3);
    self.setRestitution(1);
  }

  void create_self() {
    self = new FPoly();
    self.setPosition(position.x, position.y);
    self.setFill(255);
    self.setStatic(true);
  }
  void end_create_self() {
    self.setSensor(true);
    world.add(self);
    println("Wind created, x = ", self.getX(), self.getY());
    create = false;
  }
  void loop() {
    if (isRotate &&self.getRotation() < PI) {
      self.adjustRotation(0.1);
    } else {
      isRotate = false;
    }
    if (isBack && self.getRotation() > 0 ) {
      self.adjustRotation(-0.1);
    } else {
      isBack = false;
    }
    ArrayList<FBody> bodies = world.getBodies(); 
    for (int i = 0; i < bodies.size(); i++) {
      if (self.isTouchingBody(bodies.get(i))) {
        float x = bodies.get(i).getX();
        float y = bodies.get(i).getY();
        if (bodies.get(i)!= null) {
          bodies.get(i).addForce(-6000 * cos(self.getRotation()-PI/2+0.3), -6000 * sin (self.getRotation()-PI/2));
        }
      }
    }
  }


  void rotate() {
    self.adjustRotation(PI/3);
  }

  void back() {
    self.adjustRotation(-PI/3);
  }
}