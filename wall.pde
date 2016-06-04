import java.util.ArrayList;
import KinectPV2.KJoint;
import KinectPV2.*;
import processing.serial.*;
import cc.arduino.*;
import fisica.*;

FWorld world;
Shelf shelf;
Shelf cup;
Belt belt;
Wind wind;
FPoly poly;
Book book;
Light light;
Arduino arduino;
KinectPV2 kinect;
float myscale=1000;
float w=200;
float h=100;
float mydist=50;
int x=0;
//int i=0;
int a=180;
int mode=0;
void setup() {
  fullScreen(P3D);
  kinect = new KinectPV2(this);
  kinect.enableDepthMaskImg(true);
  kinect.enableSkeletonDepthMap(true);
  kinect.init();
  arduino = new Arduino(this, "COM4", 57600);
  arduino.pinMode(5, Arduino.SERVO);
  arduino.pinMode(11, Arduino.SERVO);
  arduino.pinMode(13, Arduino.SERVO);
  arduino.pinMode(9, Arduino.OUTPUT);
  //arduino.pinMode(2, Arduino.SERVO);
  Fisica.init(this);

  world = new FWorld();
  world.setGravity(0, 300);

  shelf = new Shelf(600, 50);
  cup = new Shelf(400, 300);
  wind = new Wind(500, 500);
  belt = new Belt(100, 100);

  book = new Book(200, 350, 200, 200);
  light = new Light(100, 100);
  initLetters();
}

//////////
int knum = 0;
int tpx = 100;
int tpy = 100;
void draw() {
  //println(frameRate);
  background(0);
  ellipse(mouseX, mouseY, 10, 10);
  world.draw();
  book.drawSentence();
  fill(255);
  textSize(100);
  text("WALL", tpx, tpy);


  textSize(30);
  //textAlign(CENTER);
  text("Touch to Start", light.touch_point.x - 50, light.touch_point.y + 50);

  ///init everything
  shelf.isRotate = false;
  shelf.isBack = true;
  wind.isRotate = false;
  wind.isBack = true;
  belt.isMoving = false;
  cup.isRotate =false;
  cup.isBack = true;
  cup.isRotate =false;
  //fill(255);
  //ellipse(light.touch_point.x, light.touch_point.y, 60, 60);
  //  light.loop();
  light.drawLines();
  light.isTouch = false;
  //book.clean();
  //book.self.getX();
  //book.self.getY();
  scale(width/myscale, width/myscale);
  translate(230, 100, 0);

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();

  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      noFill();
      stroke(255);
      drawBody(joints);
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);

      float jx = 512 - joints[KinectPV2.JointType_HandRight].getX();
      float jy = joints[KinectPV2.JointType_HandRight].getY();
      float jx2 = 512 - joints[KinectPV2.JointType_HandLeft].getX();
      float jy2 = joints[KinectPV2.JointType_HandLeft].getY();
      if (dist(jx, jy, light.touch_point.x/width*myscale-w, light.touch_point.y/width*myscale-h) < mydist || dist(jx2, jy2, light.touch_point.x/width*myscale-w, light.touch_point.y/width*myscale-h) < mydist) {
        light.isTouch = true;
      }

      if (dist(jx, jy, shelf.position.x/width*myscale-w, shelf.position.y/width*myscale-h) < mydist || dist(jx2, jy2, shelf.position.x/width*myscale-w, shelf.position.y/width*myscale-h) < mydist) {
        shelf.isRotate = true;
        shelf.isBack = false;
      }

      if (dist(jx, jy, wind.position.x/width*myscale-w, wind.position.y/width*myscale-h)<mydist || dist(jx2, jy2, wind.position.x/width*myscale-w, wind.position.y/width*myscale-h)<mydist) {
        wind.isRotate = true;
        wind.isBack = false;
      }
      if (dist(jx, jy, cup.position.x/width*myscale-w, cup.position.y/width*myscale-h)<mydist || dist(jx2, jy2, cup.position.x/width*myscale-w, cup.position.y/width*myscale-h)<mydist) {
        cup.isRotate = true;
        cup.isBack = false;
      }

      if (dist(jx, jy, belt.position.x/width*myscale-w, belt.position.y/width*myscale-h) <mydist || dist(jx2, jy2, belt.position.x/width*myscale-w, belt.position.y/width*myscale-h) <mydist ) {
        belt.isMoving = true;
      }
      if (dist(jx, jy, book.position.x/width*myscale-w, book.position.y/width*myscale-h) < mydist || dist(jx2, jy2, book.position.x/width*myscale-w, book.position.y/width*myscale-h) < mydist) {
        book.clean();
      }
    }
  }
  ////Servo control
  if (shelf.isRotate) {
    arduino.servoWrite(13, 20);
   // arduino.servoWrite(2, 40);
  } else {
    arduino.servoWrite(13, 85);
    //arduino.servoWrite(2, 60);
  }
  if (wind.isRotate) {
    arduino.servoWrite(11, 45);
  } else {
    arduino.servoWrite(11, 135);
  }
  if (cup.isRotate) {
    arduino.servoWrite(5, 90);
  } else {
    arduino.servoWrite(5, 130);
  }
  if (belt.isMoving) {
    arduino.analogWrite(9, x);
    arduino.analogWrite(7, x);
    x++;
    if (x==180) {
      x=0;
    }
  } else {
    arduino.analogWrite(9, 0);
    arduino.analogWrite(7, 0);
  }

  world.step();
  light.loop();
  shelf.loop();
  cup.loop();
  wind.loop();
  belt.loop();
  book.loop();
  checkAvailable();
}

//draw the body
void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  //drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  // drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  // drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  //drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  //Single joints
  //drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  //drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  //drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  //drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJointHead(joints, KinectPV2.JointType_Head);
}

//draw a single joint
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  noStroke();
  //fill();
  translate(512-joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  if (mode==0)
    ellipse(random(-3, 3), random(-3, 3), 10, 10);
  else
  {
    ellipse(random(-10, 10), random(-10, 10), 10, 10);
  }
  popMatrix();
}
void drawJointHead(KJoint[] joints, int jointType) {
  pushMatrix();

  translate(512-joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  if (mode==0) {
    noStroke();
    fill(255);
    ellipse(random(-3, 3), random(-3, 3), 50, 50);
  } else
  {
    noStroke();
    fill(random(255));
    ellipse(random(-10, 10), random(-10, 10), 50, 50);
  }
  popMatrix();
}


//draw a bone from two joints
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(512-joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  if (mode==0)
    ellipse(random(-3, 3), random(-3, 3), 10, 10);
  else
  {
    ellipse(random(-10, 10), random(-10, 10), 10, 10);
  }
  popMatrix();

  if (mode==0) {
    line(512-joints[jointType1].getX()+random(-3, 3), joints[jointType1].getY()+random(-3, 3), joints[jointType1].getZ(), 
      512-joints[jointType2].getX()+random(-3, 3), joints[jointType2].getY()+random(-3, 3), joints[jointType2].getZ());
  } else
  {
    strokeWeight(random(3));
    line(512-joints[jointType1].getX()+random(-3, 3), joints[jointType1].getY()+random(-3, 3), joints[jointType1].getZ(), 
      512-joints[jointType2].getX()+random(-3, 3), joints[jointType2].getY()+random(-3, 3), joints[jointType2].getZ());
  }
}


void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(512-joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 20, 20);
  popMatrix();
}

void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(100, 100, 100);
    break;
  }
}