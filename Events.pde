void keyPressed() {
  if (key == BACKSPACE) {
    FBody hovered = world.getBody(mouseX, mouseY);
    if ( hovered != null) {
      world.remove(hovered);
    }
  }
  if (key == 's' || key == 'S'){
    shelf.create = true;
    shelf.position = new PVector(mouseX,mouseY);
    println("start draw Shelf");
  }
  if (key == 'c' || key == 'C'){
    cup.create = true;
    cup.position = new PVector(mouseX,mouseY);
    println("start draw Cup");
  }
  if (key == 'w' || key == 'W'){
    wind.create = true;
    wind.position = new PVector(mouseX,mouseY);
  }
  if (key == 'b' || key == 'B'){
    belt.create = true;
    belt.position = new PVector(mouseX,mouseY);
  }
  if (key == 'k' || key == 'K'){
    book.create = true;
    book.position = new PVector(mouseX,mouseY);
  }
  
  if (key == 'l' || key == 'L'){
    Letter l = new Letter(int(random(width/3,width*2/3)), 0, int(random(0,25)));
  }
  if (key == 'd' || key == 'D'){
    light.drop_point = new PVector(mouseX, mouseY);
    light.isStarted = true;
  }
  if (key == 't' || key == 'T'){
    light.touch_point = new PVector(mouseX, mouseY);
  }
  
  if (key == 'm' || key =='M'){
    book.position = new PVector(mouseX, mouseY);
  }
  if (key == 'v' || key =='V'){
    shelf.self.setDrawable(!shelf.self.isDrawable());
    cup.self.setDrawable(!cup.self.isDrawable());
    wind.self.setDrawable(!wind.self.isDrawable());
    belt.self.setDrawable(!belt.self.isDrawable());

  }
  if (key == 'i' || key == 'I'){
    tpx = mouseX;
    tpy = mouseY;
  }
}

void mousePressed() {
  if (shelf.create){
    shelf.create_self();
    //shelf.self.vertex(mouseX, mouseY);
  }
  if (cup.create){
    cup.create_self();
  }
  if (wind.create){
    wind.create_self();
  }
  if (belt.create){
    belt.create_self();
  }
  if (book.create){
    book.create_self();
    book.end_create_self();
  }
}

void mouseDragged() {
if (shelf.create){
  shelf.self.vertex(mouseX - shelf.position.x, mouseY - shelf.position.y);
}
if (cup.create){
  cup.self.vertex(mouseX - cup.position.x, mouseY - cup.position.y);
}
if (wind.create){
  wind.self.vertex(mouseX - wind.position.x, mouseY - wind.position.y);
}
if (belt.create){
  belt.self.vertex(mouseX - belt.position.x, mouseY - belt.position.y);
}
}

void mouseReleased() {
  if (shelf.create){
    shelf.end_create_self();
  }
  if (cup.create){
    cup.end_create_self();
  }
  if (wind.create){
    wind.end_create_self();
  }
  if (belt.create){
    belt.end_create_self();
  }
}