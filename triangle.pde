class Triangle{
  int bottomOffset;
  color clr;
  PShape shape;
  
  Triangle(int bottomOffset, color clr){
    this.bottomOffset = bottomOffset;
    shape = createShape();
    this.clr = clr;
    
    createTriangle();
  }
  
  void createTriangle(){
    shape.beginShape();
    shape.noStroke();
    shape.fill(clr);
    shape.vertex(width/2, 0);
    shape.vertex(width, height - bottomOffset);
    shape.vertex(0, height - bottomOffset);
    shape.endShape(CLOSE);
  }
  
  PShape getShape(){
    return shape;
  }
}
