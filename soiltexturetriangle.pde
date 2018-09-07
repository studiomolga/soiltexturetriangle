static final int BACKGROUND_COLOR = 255;

Noise noise;
PGraphics buffer;
Triangle triangle;
Circle circle;

void setup(){
  size(480, 480);
  buffer = createGraphics(width, height);
  noise = new Noise(buffer, 20.0f);
  color circleClr = color(0, 255, 0);
  color triangleClr = color(255, 0, 0);
  triangle = new Triangle(buffer, 15, 80, triangleClr, 7);
  circle = new Circle(buffer, new PVector(width / 2, 0), 350, circleClr);
  noise.addItemToNoiseMap(new NoiseMap("circle", Type.COLOR, circleClr));
  noise.addItemToNoiseMap(new NoiseMap("triangle", Type.COLOR, triangleClr));
  noise.addItemToNoiseMap(new NoiseMap("triangle-border", Type.GREY, color(0)));
}

void draw(){
  background(BACKGROUND_COLOR);
  clearBuffer();
  circle.display();
  triangle.display();
  
  //image(buffer, 0, 0);
  noise.update();
  noise.display();
} 

void clearBuffer(){
  buffer.beginDraw();
  buffer.clear();
  buffer.background(0, 0);
  buffer.endDraw();
}
