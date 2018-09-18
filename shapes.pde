class Triangle{
  PGraphics buffer;
  int topOffset;
  int bottomOffset;
  int strWeight;
  color clr;
  PShape triangle;
  
  Triangle(PGraphics buffer, int topOffset, int bottomOffset, color clr, int strWeight){
    this.buffer = buffer;
    this.topOffset = topOffset;
    this.bottomOffset = bottomOffset;
    this.strWeight = strWeight;
    triangle = createShape();
    this.clr = clr;
    
    createTriangle();
  }
  
  void createTriangle(){
    triangle.beginShape();
    //triangle.strokeWeight(strWeight);
    //triangle.stroke(0);
    triangle.noStroke();
    triangle.fill(clr);
    triangle.vertex(width/2, topOffset);
    triangle.vertex((width - 1) - strWeight, height - bottomOffset);
    triangle.vertex(strWeight, height - bottomOffset);
    triangle.endShape(CLOSE);
  }
  
  PShape getShape(){
    return triangle;
  }
  
  void display(){
    buffer.beginDraw();
    buffer.shape(triangle, 0, 0);
    buffer.endDraw();
  }
}

class Circle{
  PGraphics buffer;
  int radius;
  color clr;
  PVector pos;
  PShape circle;
  
  Circle(PGraphics buffer, PVector pos, int radius, color clr){
    this.buffer = buffer;
    this.pos = pos;
    this.radius = radius;
    this.clr = clr;
    
    createCircle();
  }
  
  void createCircle(){
    circle = createShape(ELLIPSE, 0, 0, radius, radius);
    circle.setFill(clr);
    circle.setStroke(false);
  }
  
  PShape getShape(){
    return circle;
  }
  
  void setAlpha(int alpha){
    clr = color(red(clr), green(clr), blue(clr), alpha);
    circle.setFill(clr);
  }
  
  void display(){
    buffer.beginDraw();
    buffer.shape(circle, pos.x, pos.y);
    buffer.endDraw();
  }
}

//TODO: is there a way to fuse the perlinCircle and triangle classes?
class PerlinCircle {
  final static short TIME_DIFF = 1000;
  final float NUM_ANGLES;
  
  float centerX, centerY, minSize, maxSize, deviation;
  float noiseScale, timeScale;
  int segments;

  final float TIME_UNIQUE = random(TIME_DIFF);
  //final float MIN_RAD, MAX_RAD;
  
  color perlinClr;
  color triangleClr;
  
  PVector nextCoord;
  PGraphics buffer;
  PGraphics maskImage = createGraphics(width, height);
  PGraphics sourceImage = createGraphics(width, height);
  PShape perlinShape = createShape();
  
  PerlinCircle(PGraphics buffer, PShape triangle, float centerX, float centerY, float minSize, float maxSize, int segments, color perlinClr, color triangleClr){
    this.buffer = buffer;
    this.perlinClr = perlinClr;
    this.triangleClr = triangleClr;
    this.centerX = centerX;
    this.centerY = centerY;
    this.minSize = minSize;    //we can adjust for different effects
    this.maxSize = maxSize;    //we can adjust for different effects
    this.segments = segments;
    NUM_ANGLES = TWO_PI / (float) segments;
    
    //MIN_RAD = minSize;
    //MAX_RAD = maxSize;
    noiseScale = 0.8;      //we can adjust for different effects
    timeScale = 0.005;     //we can adjust for different effects
    
    triangle.setFill(255);
    sourceImage.beginDraw();
    sourceImage.shape(triangle, 0, 0);
    sourceImage.endDraw();

    initShape();
  }
  
  void initShape(){
    int i = 0;
    perlinShape.beginShape();
    perlinShape.noStroke();
    while (i++ != segments) {
      nextCoord = findNextCoords(i);
      perlinShape.vertex(nextCoord.x, nextCoord.y);
    }
    perlinShape.endShape(CLOSE);
  }
  
  void updateShape(){
    for(int i = 0; i < perlinShape.getVertexCount(); i++){
      PVector v = findNextCoords(i);
      perlinShape.setVertex(i, v);
    }
  }
  
  PVector findNextCoords(final int seg) {
    final float angle = NUM_ANGLES*seg;
    final float cosAngle = cos(angle);
    final float sinAngle = sin(angle);
    final float time = timeScale*frameCount + TIME_UNIQUE;

    final float noiseValue = noise(
      noiseScale*cosAngle + noiseScale, 
      noiseScale*sinAngle + noiseScale, time);

    final float rad = maxSize*noiseValue + minSize;
    
    PVector coord = new PVector(rad*cosAngle, rad*sinAngle);
    return coord;
  }
  
  PGraphics getMask(){
    return maskImage;
  }
  
  void incrRadius(float incr){
    if(maxSize < 400.0f){
      maxSize += incr;
      if(maxSize - minSize > 200.0f){
        minSize += incr;
      }
    } else if(minSize < 400.0f){
      minSize += incr;
    }
  }
  
  void display(){
    updateShape();
    
    perlinShape.setFill(perlinClr);
    
    maskImage.beginDraw();
    maskImage.clear();
    maskImage.background(triangleClr);
    maskImage.pushMatrix();
    maskImage.translate(centerX, centerY);
    maskImage.shape(perlinShape);
    maskImage.popMatrix();
    maskImage.endDraw();
    maskImage.mask(sourceImage);
    
    buffer.beginDraw();
    buffer.image(maskImage, 0, 0);
    buffer.endDraw();
    
  }
}
