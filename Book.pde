public class Book {
  PVector position;
  PVector size;
  boolean create = false;
  char[] words;
  FBox self;

  Book(int _x, int _y, int w, int h) {
    position = new PVector(_x, _y);
    size = new PVector(w, h);
    self = new FBox(size.x, size.y);
    self.setPosition(_x, _y);
    self.setFill(255);
    self.setStrokeWeight(3);
    self.setRestitution(0);
    self.setFriction(1);

    words = new char[0];
  }

  void create_self() {
    self = new FBox(size.x, size.y+50);
    self.setPosition(position.x, position.y);
    self.setFill(255);
    self.setStatic(true);
    //self.setSensor(true);
  }
  void end_create_self() {
    world.add(self);
    println("Book created, x = ", self.getX(), self.getY());
    create = false;
  }
  void loop() {
    for (int i = 0; i < letters.size(); i++) {
      println(i);
      if (self.isTouchingBody(letters.get(i).poly)) {
        println("fuck");
        if (words.length >= 5) {
          clean();
        }
        letters.get(i).alive = false;
        words = expand(words, words.length+1);
        int index = words.length - 1;
        words[index]= letters.get(i).letter;//expands
      }
    }
  }

  void drawSentence() {
    String sentence = new String(words);
    fill(0);
    textSize(60);
    text(sentence, self.getX() - size.x/2, self.getY());
    textSize(30);
    fill(255);
    text("Move Words Here", self.getX() - size.x/2 -20, self.getY() - 150);
    
  }

  void clean() {
    words = new char[0];
  }


  void rotate() {
    self.adjustRotation(PI/3);
  }

  void back() {
    self.adjustRotation(-PI/3);
  }
}