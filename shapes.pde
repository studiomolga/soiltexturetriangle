class Triangle{
  int topOffset;
  int bottomOffset;
  int strWeight;
  color clr;
  PShape triangle;
  
  Triangle(int topOffset, int bottomOffset, color clr, int strWeight){
    this.topOffset = topOffset;
    this.bottomOffset = bottomOffset;
    this.strWeight = strWeight;
    triangle = createShape();
    this.clr = clr;
    
    createTriangle();
  }
  
  void createTriangle(){
    triangle.beginShape();
    triangle.strokeWeight(strWeight);
    triangle.stroke(0);
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
    shape(triangle, 0, 0);
  }
}

class Circle{
  int radius;
  color clr;
  PVector pos;
  PShape circle;
  
  Circle(PVector pos, int radius, color clr){
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
  
  void display(){
    shape(circle, pos.x, pos.y);
  }
}