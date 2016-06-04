public class Belt {
  PVector position;
  boolean create = false;
  boolean isMoving = false;
  FPoly self;

  Belt(int _x, int _y) {
    position = new PVector(_x, _y);
    self = new FPoly();
    self.setPosition(_x, _y);
    self.setFill(255);
    self.setStrokeWeight(3);
    self.setRestitution(0);
    self.setFriction(1);
  }

  void create_self() {
    self = new FPoly();
    self.setPosition(position.x, position.y);
    self.setFill(255);
    self.setStatic(true);
  }
  void end_create_self() {
    world.add(self);
    println("Belt created, x = ", self.getX(), self.getY());
    create = false;
  }
  void loop() {
    if (isMoving) {
      ArrayList<FBody> bodies = world.getBodies(); 
      for (int i = 0; i < bodies.size(); i++) {
        if (self.isTouchingBody(bodies.get(i))) {
          //println("here");
          //float x = bodies.get(i).getX();
          //float y = bodies.get(i).getY();

           bodies.get(i).adjustVelocity(map(mouseX,0,width,2,20), -map(mouseX,0,width,2,20));
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