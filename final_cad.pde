import controlP5.*;
import processing.opengl.*;
import java.util.*;

/*
  --- Original 3D Modeling CAD Tool ---
  
  3DモデリングツールをProcessingで作りました。
  ライブラリは、opengl,controlP5を使用しています。
  
  Demo動画 : [https://youtu.be/HhC8-OHTk9o]
  高負荷プログラムなので、実行には注意が必要です。

*/

class SolidModel {
  
  PVector[] points;
  PVector trans;
  int solid_height;
  boolean is_focus;
  
  SolidModel(PVector[] p, int h) {
    points = p;
    solid_height = h;
    is_focus = false;
    trans = new PVector(0,0,0);
  }
  
  void setHeight(int h) {
     solid_height = h;
  }
  void draw() {

    if(is_focus){
      strokeWeight(4);
    } else {
      strokeWeight(1);
    }
    
    // 高さが0の場合はSketchっぽく描画
    if(solid_height == 0) {
      stroke(0, 255, 0, 255);
      fill(0, 255, 0, 20);
      beginShape(QUADS);
        for(int i=0; i<points.length; i++) {
         vertex(points[i].x + trans.x,  points[i].y + trans.y, points[i].z + trans.z);
        }
      endShape();
      strokeWeight(1);
      return;
    }
    
    fill(0, 255, 255, 100);
    stroke(0, 255, 255);
        
    // 底面を描画
    beginShape();
    for(int i=0; i<points.length; i++) {
     vertex(points[i].x + trans.x,  points[i].y + trans.y, points[i].z + trans.z);
    }
    endShape();
    
    // 天井面を描画
    beginShape();
    for(int i=0; i<points.length; i++) {
     vertex(points[i].x + trans.x,  points[i].y + trans.y, points[i].z+solid_height + trans.z);
    }
    endShape();
    
    // 側面を描画
    beginShape(QUADS);
    for(int i=0; i<points.length; i++) {
     vertex(points[i].x + trans.x,  points[i].y + trans.y, points[i].z + trans.z);
     vertex(points[i].x + trans.x,  points[i].y + trans.y, points[i].z+solid_height + trans.z);
     
     if(i+1 < points.length) {
      vertex(points[i+1].x + trans.x,  points[i+1].y + trans.y, points[i+1].z+solid_height + trans.z);
      vertex(points[i+1].x + trans.x,  points[i+1].y + trans.y, points[i+1].z + trans.z);
     } else {
      vertex(points[0].x + trans.x,  points[0].y + trans.y, points[0].z+solid_height + trans.z);
      vertex(points[0].x + trans.x,  points[0].y + trans.y, points[0].z + trans.z);
     }
    }
    endShape();
    
    strokeWeight(1);
  }
  
}


class Demo {
  
  Demo() {
  }

  void draw(color c) {
       
  }
}


class Grid {

  Grid() {
  }
  
  void draw() {
    for(int i=0; i<width; i++) {
      if(i % 20 == 0) {
        stroke(255, 255, 255, 40);
        line(-(height/2), i-(height/2), height, i-(height/2));
        line(i-(width/2), -(width/2), i-(width/2), width);
      }
    }   
  }
}


class Rect {
  
  boolean drawing = false;
  PVector start_point;
  PVector end_point;
  int mode;
  Rect() {
    mode = 0;
    start_point = new PVector(0, 0);
    end_point  = new PVector(0, 0);
  }
  
  
  void buildModel() {
    P = new PVector[4];
    P[0] = new PVector(start_point.x, start_point.y, 0);
    P[1] = new PVector(end_point.x, start_point.y, 0);
    P[2] = new PVector(end_point.x, end_point.y, 0);
    P[3] = new PVector(start_point.x, end_point.y, 0);
    s = new SolidModel(P, 0);
    models.add(s);
    cp5.get(ScrollableList.class, "selectModel").addItem("Model "+models.size(), null);
    selectModel(models.size()-1);
  }
  
  void onMousePressed(int x, int y) {
    if(mode == 0) {
      start_point.x = x;
      start_point.y = y;
      mode = 1;
      return;
    }
    if(mode == 1) {
       end_point.x = x;
       end_point.y = y;
       mode = 2;
       buildModel();
       tool_mode = 0;
       return;
    }
  }
  
  void draw() {
      // スタートポイントの描画
      if(mode == 1) {
        stroke(255, 255, 0);
        fill(255, 255, 0);
        ellipse(start_point.x, start_point.y, 5, 5);
      }
      
      // マウス移動中の描画線
      if(mode == 1) {
        stroke(0, 255, 0, 255);
        fill(0, 255, 0, 30);
        beginShape(QUADS);
          vertex(start_point.x, start_point.y, 0);
          vertex(mX,  start_point.y, 0);
          vertex(mX, mY, 0);
          vertex(start_point.x, mY, 0);
        endShape();
      }
  }
}




class Point {
  PVector P0;
  color c = color(255, 255, 255);
  Point(){
    P0 = new PVector(); P0.x = 0; P0.y = 0;
  }
  
  void draw(){
    if(P0.x !=  0 && P0.y != 0){
      stroke(c);
      fill(c);
      ellipse(P0.x, P0.y, 5, 5);
    }
  }
}

class Line {
  PVector P0;
  PVector P1;
  color c;
  
  Line() {
    P0 = new PVector(); P0.x = 0; P0.y = 0;
    P1 = new PVector(); P1.x = 0; P1.y = 0;
    c = color(255, 255, 255);
  }
  
  void draw(){
     stroke(c);
     line(P0.x, P0.y, P1.x, P1.y);
  }
}

class SubLine {
  PVector P0;
  PVector P1;
  PVector P2;
  color c = color(243, 127, 195);
  
  SubLine() {
    P0 = new PVector(); P0.x = 0; P0.y = 0;
    P1 = new PVector(); P1.x = 0; P1.y = 0;
    P2 = new PVector(); P1.x = 0; P1.y = 0;
  }
  void calc() { // 点対称の計算
    // P1を中心としたP0の点対称P2をもとめる
    P2.x = 2 * P1.x - P0.x;
    P2.y = 2 * P1.y - P0.y;
  }
  void draw(){
     calc();
     stroke(c);
     line(P0.x, P0.y, P2.x, P2.y);
     stroke(c);
     fill(c);
     ellipse(P0.x, P0.y, 5, 5);
     ellipse(P1.x, P1.y, 5, 5);
     ellipse(P2.x, P2.y, 5, 5);
  }
}

class Curve {
  PVector P0, P1, P2;
  PVector[] R;
  int tn;
  color c = color(168, 198, 70);
  int alpha = 255;
  
  Curve() {
    P0 = new PVector(); P0.x = 0;   P0.y = 0;
    P1 = new PVector(); P1.x = 0;   P1.y = 0;
    P2 = new PVector(); P2.x = 0;   P2.y = 0;
    tn = 100;
    R = new PVector[tn];
  }
  void draw() {
    int   i, tt;
    float t=0.0;
    float ts = (float)1 / tn;
    float B20t, B21t, B22t;

    noStroke();
    noFill();
    stroke(c);
    
    for(tt = 0; tt < tn ; tt+=1) {
        B20t =     (1-t)*(1-t)         ; 
        B21t = 2 *       (1-t)       *t;
        B22t =                      t*t; 
        R[tt] = new PVector();
        R[tt].x = B20t*P0.x + B21t*P1.x + B22t*P2.x;
        R[tt].y = B20t*P0.y + B21t*P1.y + B22t*P2.y;
      if (tt != 0) line(R[tt-1].x, R[tt-1].y, R[tt].x, R[tt].y); 
      t = t + ts;
    }
  }  
}

class Curve3 {
  PVector P0, P1, P2, P3;
  PVector[] R;
  int tn;
  color c = color(168, 198, 70);
  
  Curve3() {
    P0 = new PVector(); P0.x =  0; P0.y = 0;
    P1 = new PVector(); P1.x = 0; P1.y = 0;
    P2 = new PVector(); P2.x = 0; P2.y = 0;
    P3 = new PVector(); P3.x = 0; P3.y = 0;
    
    tn = 100;
    R = new PVector[tn];
  }
  
  void draw() {
    
    int   i, tt;
    float t=0.0;
    float ts = (float)1 / tn;
    float B30t, B31t, B32t, B33t;
    
    noFill();
    stroke(c);
    
    for(tt = 0; tt < tn ; tt+=1) {
        B30t =     (1-t)*(1-t)*(1-t)        ; 
        B31t = 3 * (1-t)*(1-t)       *t     ;
        B32t = 3 * (1-t)             *t*t   ; 
        B33t =                        t*t*t ;
        R[tt] = new PVector();
        R[tt].x = B30t*P0.x + B31t*P1.x + B32t*P2.x + B33t*P3.x;
        R[tt].y = B30t*P0.y + B31t*P1.y + B32t*P2.y + B33t*P3.y;
      if (tt != 0) line(R[tt-1].x, R[tt-1].y, R[tt].x, R[tt].y);
      t = t + ts;
    }
  }
}
class Cursor {
  PVector P;
  Cursor(){
    P = new PVector();
  }
  void draw(){
    stroke(255);
    noCursor();
    line(P.x-10, P.y, P.x+10, P.y);
    line(P.x, P.y-10, P.x, P.y+10);
  }
}

Demo d;
SolidModel s;
Grid grid;
int tool_mode = 0;
/*
  tool_mode
    0) ->
    1) -> CameraMoveMode
    2) -> 
    3) -> Rect
    4) -> Model選択
    5) -> ModelをScale
    6) -> ベジェを描画
*/

// Sketches
ArrayList<Rect> rect_sketches;
ArrayList<Point> points;
ArrayList<Line> lines;
ArrayList<Curve> curves;
ArrayList<Curve3> curves3;
SubLine subline;
Point p;
Line l;
Cursor cursor;

// Solids
ArrayList<SolidModel> models;

// Frags
String mode_name = "";
boolean is_dragging = false;
int camera_x=0;
int camera_y=0;

// ベジェ
int mDX, mDY; // mouse drag point
int mPX, mPY; // mouse press point
int mCX, mCY; // moulick point
int mX, mY; // mouse point
int b2X, b2Y;
float bs1X, bs1Y; // 1つ前のsubline
float bs2X, bs2Y;
float bp1X, bp1Y;
int drawingType = 0; //nothing


PVector[] P;

ControlP5 cp5;

void setup() {
  size(800, 800, OPENGL);
  grid = new Grid();
  
  points = new ArrayList<Point>();
  lines = new ArrayList<Line>();
  subline = new SubLine();
  curves = new ArrayList<Curve>(); 
  curves3 = new ArrayList<Curve3>();
  cursor = new Cursor();
 
 
  cp5 = new ControlP5(this);
  cp5.addButton("onCameraButton")
   .setLabel("Reset Camera")
   .setPosition(20,150)
   .setSize(120,40);
  cp5.addButton("onRectButton")
    .setLabel("Draw Rectangle")
    .setPosition(20,200)
    .setSize(120,40);
  cp5.addButton("onBezierButton")
    .setLabel("Draw BezierPath")
    .setPosition(20,250)
    .setSize(120,40);
  cp5.addButton("onPushModelButton")
    .setLabel("Push 3DModel")
    .setPosition(20,300)
    .setSize(120,40);
    
  cp5.addButton("onDeleteModelButton")
    .setLabel("Delete Model")
    .setPosition(20,350)
    .setSize(120,40);
    
  cp5.addScrollableList("selectModel")
     .setCaptionLabel("SolidModels")
     .setPosition(20, 600)
     .setSize(200, 200)
     .setBarHeight(40)
     .setItemHeight(40)
     .setType(ScrollableList.LIST);
     
     
  rect_sketches = new ArrayList<Rect>();
  models = new ArrayList<SolidModel>();
  
  // テストModel
  P = new PVector[5];
  P[0] = new PVector(22, 63, 0);
  P[1] = new PVector(117, 144, 0);
  P[2] = new PVector(174, 61, 0);
  P[3] = new PVector(89, 21, 0);
  P[4] = new PVector(300, 300, 0);
  s = new SolidModel(P, 200);
  models.add(s);
  cp5.get(ScrollableList.class, "selectModel").addItem("Model "+models.size(), null);
  
  
}

void onCameraButton(){
 tool_mode = 0;
 camera_x = 0; camera_y =0;
}
void onRectButton(){
  tool_mode = 3;
}

void onBezierButton() {
  tool_mode = 7;
}
void onPushModelButton() {
  tool_mode = 5;
}
void onDeleteModelButton() {
  for(int i=0; i<models.size(); i++) {
    if(models.get(i).is_focus) {
      models.remove(i);
      cp5.get(ScrollableList.class, "selectModel").clear();
      for(int j=0; j<models.size(); j++) {
      cp5.get(ScrollableList.class, "selectModel").addItem("Model "+(j+1), null);
      }
      
      break;
    }
  }
}

// Modelが選択された場合
void selectModel(int n) {
  tool_mode = 0;
  for(int i=0; i<models.size(); i++) {
    models.get(i).is_focus = false;
  }
  models.get(n).is_focus = true;
  
}

// 選択中のモデルをPushする
void modelPush() {
  for(int i=0; i<models.size(); i++) {
    if(models.get(i).is_focus) {
      models.get(i).setHeight((int)(mouseY*0.8));
      break;
    }
  }
}

void clearBezier(){
  points = new ArrayList<Point>();
  lines = new ArrayList<Line>();
  subline = new SubLine();
  curves = new ArrayList<Curve>(); 
  curves3 = new ArrayList<Curve3>();
  drawingType = 0;
}

// ベジェの閉図形描画を確立
void checkoutBezier() {
  List<PVector> aps = new ArrayList<PVector>(); 
  
  // Line
  for(int i=0; i < lines.size(); i++) {
    aps.add(lines.get(i).P0);
    aps.add(lines.get(i).P1);
  }
  
  // Curve
  for(int i=0; i < curves.size(); i++) {
    for(int j=0; j < curves.get(i).R.length; j++) {
      aps.add(curves.get(i).R[j]);
    }
  }

  // Curve3
  for(int i=0; i < curves3.size(); i++) {
    for(int j=0; j < curves3.get(i).R.length; j++) {
      aps.add(curves3.get(i).R[j]);
    }
  }
  
  PVector[] PV = (PVector[])aps.toArray(new PVector[0]);
  SolidModel s = new SolidModel(PV, 80);
  models.add(s);
  cp5.get(ScrollableList.class, "selectModel").addItem("Model "+models.size(), null);
}

void draw() {
  pushMatrix();
  
  background(40);
  fill(0, 255, 255);
  textFont(createFont("MS Gothic",16,true));
  text("Super 3DCadTool", 10, 20);
  textFont(createFont("MS Gothic",14,true));
  String txt="";
  if(tool_mode==0) {
    txt = "ドラッグでカメラの位置を動かせます";
  }
  if(tool_mode==1){
  
  }
  if(tool_mode==2){
  }
  if(tool_mode==3){
    txt = "長方形を描画します";
  }
  if(tool_mode==4){
  
  }
  if(tool_mode==5){
    txt = "ModelをPushします。マウスを上下にドラッグしてください";
  }
  if(tool_mode==6){
    txt = "ベジェを描画します。終点を開始点に合わせると閉図形にできます。";
  }
  text(txt, 10, 45);
  
  textFont(createFont("MS Gothic",12,true));
  text("選択したモデルの移動方法", 20, 510);
  text("・←→キーでx軸移動", 20, 530);
  text("・↑↓キーでz軸移動", 20, 550);
  text("・j,nキーでz軸移動", 20, 570);
  
  lights();
  
  // マウスカーソル描画
  cursor.P.x = mouseX;
  cursor.P.y = mouseY;
  cursor.draw();
  
  
  
  translate(width/2, height/2, -20);
  
  // カメラ位置移動
  if(tool_mode == 0 && is_dragging) {
    camera_x = -mouseX;
    camera_y = mouseY;
  }
  if(camera_x == 0 && camera_y ==0) {
    rotateX(0);
    rotateY(0);
  } else {
     rotateX(map(camera_x, 0, width, -PI, PI));
    rotateY(map(camera_y, 0, height, -PI, PI));
  }
    
  // Modelのpushing
  if(tool_mode == 5 && is_dragging) {
    modelPush();
  }
  
  grid.draw();
  
  // ベジェ曲線描画中
  if(tool_mode == 6) {
    for(int i = 0; i < points.size(); i++){
      points.get(i).draw();
    }
    for(int i = 0; i < lines.size(); i++){
      lines.get(i).draw();
    }
    for(int i = 0; i < curves.size(); i++){
      curves.get(i).draw();
    }
    for(int i = 0; i < curves3.size(); i++){
      curves3.get(i).draw();
    }
    if(drawingType == 1) { // 直線描画中
      lines.get(lines.size() - 1).P0.x = mCX;
      lines.get(lines.size() - 1).P0.y = mCY;
      lines.get(lines.size() - 1).P1.x = mX;
      lines.get(lines.size() - 1).P1.y = mY;
      lines.get(lines.size() - 1).draw();
    }
    
    if(drawingType == 2) { // SubLineとベジェの描画
      subline.P0.x = mDX; subline.P0.y = mDY;
      subline.P1.x = mPX; subline.P1.y = mPY;
      subline.draw();
      
      curves.get(curves.size() - 1).P0.x = subline.P1.x;
      curves.get(curves.size() - 1).P0.y = subline.P1.y;
      curves.get(curves.size() - 1).P1.x = subline.P2.x;
      curves.get(curves.size() - 1).P1.y = subline.P2.y;
      curves.get(curves.size() - 1).P2.x = b2X;
      curves.get(curves.size() - 1).P2.y = b2Y;
      curves.get(curves.size() - 1).draw();
      
      bp1X = mPX;
      bp1Y = mPY;
    }
    
    if(drawingType == 3) {
      subline.P0.x = mDX; subline.P0.y = mDY;
      subline.P1.x = bp1X; subline.P1.y = bp1Y;
      subline.draw();
      curves.get(curves.size() - 1).P0.x = subline.P1.x;
      curves.get(curves.size() - 1).P0.y = subline.P1.y;
      curves.get(curves.size() - 1).P1.x = subline.P0.x;
      curves.get(curves.size() - 1).P1.y = subline.P0.y;
      curves.get(curves.size() - 1).P2.x = mX;
      curves.get(curves.size() - 1).P2.y = mY;
      curves.get(curves.size() - 1).draw();
      
      bs1X = subline.P1.x;
      bs1Y = subline.P1.y;
      bs2X = subline.P0.x;
      bs2Y = subline.P0.y;
    }
    if(drawingType == 4) { // sublineと3次ベジェの描画
      subline.P0.x = mDX; subline.P0.y = mDY;
      subline.P1.x = mPX; subline.P1.y = mPY;
      subline.draw();
      
      curves3.get(curves3.size() - 1).P0.x = mPX;
      curves3.get(curves3.size() - 1).P0.y = mPY;
      curves3.get(curves3.size() - 1).P1.x = subline.P2.x;
      curves3.get(curves3.size() - 1).P1.y = subline.P2.y;
      curves3.get(curves3.size() - 1).P2.x = bs2X;
      curves3.get(curves3.size() - 1).P2.y = bs2Y;
      curves3.get(curves3.size() - 1).P3.x = bs1X;
      curves3.get(curves3.size() - 1).P3.y = bs1Y;
      curves3.get(curves3.size() - 1).draw();
      
      bp1X = mPX;
      bp1Y = mPY;
    }
  } else {
    clearBezier();
  }

  
  // すべてのSolidModelsを描画
  for(int i=0; i<models.size(); i++) {
    models.get(i).draw();
  }
  
  // すべてのRectSketchを描画
  if(tool_mode == 3){
    for(int i=0; i<rect_sketches.size(); i++) {
      rect_sketches.get(i).draw();
    }
  } else {
    rect_sketches.clear();
  }
  
  
  popMatrix();
}


void mouseClicked() {
  mCX = reMouseX(mouseX);
  mCY = reMouseY(mouseY);
  
  if(tool_mode == 7) {
    tool_mode = 6;
    return;
  }
  
  if(tool_mode == 6){
    
    // point0番とかぶっていれば、閉じたことにする
    if(points.size() > 0) {
      int diffX = (int) points.get(0).P0.x - mCX;
      int diffY = (int) points.get(0).P0.y - mCY;
      if(abs(diffX) < 20 && abs(diffY) < 20) {
        println("onaji");
        // ここで、ベジェを成立させる
        // ただし、3打点以上
        if(points.size() < 3) return;
        // ここでやる
        // ここでやる
        checkoutBezier();
        tool_mode = 0;
        return;
      }
    }
    
   if(drawingType == 0) {
      points.add(new Point());
      points.get(points.size() - 1).P0.x = mCX;
      points.get(points.size() - 1).P0.y = mCY;
      b2X = mCX;
      b2Y = mCY;
      drawingType = 1;
      lines.add(new Line());
    }
    if(drawingType == 1) {
      points.add(new Point());
      points.get(points.size() - 1).P0.x = mCX;
      points.get(points.size() - 1).P0.y = mCY;
      lines.add(new Line());
      b2X = mCX;
      b2Y = mCY;
    }
    if(drawingType == 3) {
      points.add(new Point());
      points.get(points.size() - 1).P0.x = mCX;
      points.get(points.size() - 1).P0.y = mCY;
      b2X = mCX;
      b2Y = mCY;
      drawingType = 1;
      lines.add(new Line());
    }
    if(mCX > 600-110 && mCY > 600-60) {
     drawingType = 0;
     // 全消去
     points = new ArrayList<Point>();
     lines = new ArrayList<Line>();
     subline = new SubLine();
     curves = new ArrayList<Curve>(); 
     curves3 = new ArrayList<Curve3>();
    }
  
  }

}

void mouseMoved() {
  mX = reMouseX(mouseX);
  mY = reMouseY(mouseY);
}


void mousePressed() {
  mPX = reMouseX(mouseX);
  mPY = reMouseY(mouseY);
  
  // Rectモード
  if(tool_mode == 3) {
    // Rectがないまたは、Rectが描画中でない場合は、新しくRectSketchをつくる
    if(rect_sketches.size() == 0 || rect_sketches.get(rect_sketches.size() -1).mode == 2) {
      rect_sketches.add(new Rect());
    }
    // 対象になるRectのメソッドをcallする
    Rect rect = rect_sketches.get(rect_sketches.size() -1);
    rect.onMousePressed(reMouseX(mouseX), reMouseY(mouseY));
    if(rect.mode == 2) rect_sketches.clear();
  }
  
}

void mouseReleased() {
  is_dragging = false;
  
  if(tool_mode == 6) {
    if(drawingType == 2) {
      // ベジェ曲線を追加
      curves.add(new Curve()); // mousemoveベジェ
      drawingType = 3;
    }
    if(drawingType == 4) {
      // ベジェ曲線を追加
      curves.add(new Curve()); // mousemoveベジェ
      drawingType = 3;
    }
  }
}

void mouseDragged() {
  mDX = reMouseX(mouseX);
  mDY = reMouseY(mouseY);
  is_dragging = true;
  
  if(tool_mode == 6){
  
    if(drawingType == 1) {
      // Drag開始点をマーク
      points.add(new Point());
      points.get(points.size() - 1).P0.x = mPX;
      points.get(points.size() - 1).P0.y = mPY;
      
      // ベジェ曲線を追加
      curves.add(new Curve());
      
      // 一つ前のラインを消去
      lines.remove(lines.size() - 1);
      drawingType = 2;
    }
    if(drawingType == 3) {
      // Drag開始点をマーク
      points.add(new Point());
      points.get(points.size() - 1).P0.x = mPX;
      points.get(points.size() - 1).P0.y = mPY;
      
      lines.add(new Line());
      // 3次ベジェ曲線を追加
      curves3.add(new Curve3());
      
      // 一つ前の2次ベジェを消去
      curves.remove(curves.size() - 1);
      
      drawingType = 4;
    }
    if(drawingType == 4) {
    }
  
  }
}





void keyPressed() {
  // RectのSketchを描画
  if (key=='r') {
    tool_mode = 3;
    mode_name = "RectSketch描画モード";
  }
  if (key=='m') {
    tool_mode = 1;
    mode_name = "カメラ移動モード";
  }
  if (key=='s') {
    tool_mode = 4;
    mode_name = "Sketchを選択してください";
  }
    if (key=='b') {
    tool_mode = 6;
    mode_name = "ベジェ曲線";
  }
  
  if (key=='i') {
    tool_mode = 5;
    mode_name = "高さを変えます";
  }
  
  // 選択しているModelを移動
  if (key=='j') {
    for(int i=0; i<models.size(); i++) {
      if(models.get(i).is_focus) {
        models.get(i).trans.z += 10;
        break;
      }
    }
  }
  if (key=='n') {
    for(int i=0; i<models.size(); i++) {
      if(models.get(i).is_focus) {
        models.get(i).trans.z -= 10;
        break;
      }
    }
  }
  if (key == CODED) {
    if (keyCode == RIGHT) {
      for(int i=0; i<models.size(); i++) {
        if(models.get(i).is_focus) {
          models.get(i).trans.x += 10;
          break;
        }
      }
    }
    if (keyCode == LEFT) {
      for(int i=0; i<models.size(); i++) {
        if(models.get(i).is_focus) {
          models.get(i).trans.x -= 10;
          break;
        }
      }
    }
    if (keyCode == DOWN) {
      for(int i=0; i<models.size(); i++) {
        if(models.get(i).is_focus) {
          models.get(i).trans.y += 10;
          break;
        }
      }
    }
    if (keyCode == UP) {
      for(int i=0; i<models.size(); i++) {
        if(models.get(i).is_focus) {
          models.get(i).trans.y -= 10;
          break;
        }
      }
    }
  }
  
}

int reMouseX(int x) {
   return x - width/2;
}
int reMouseY(int y) {
   return y - height/2;
}