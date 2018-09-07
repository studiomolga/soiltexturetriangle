static final int BACKGROUND_COLOR = 255;

Noise noise;
Triangle triangle;
Circle circle;

void setup(){
  size(480, 480);
  
  noise = new Noise(100.0f, 40.0f);
  color circleClr = color(100);
  color triangleClr = color(200);
  triangle = new Triangle(15, 80, triangleClr, 3);
  circle = new Circle(new PVector(width / 2, 0), 350, circleClr);
  noise.addItemToNoiseMap(new NoiseMap("circle", Type.GREY, circleClr));
  noise.addItemToNoiseMap(new NoiseMap("triangle", Type.COLOR, triangleClr));
  noise.addItemToNoiseMap(new NoiseMap("triangle-border", Type.GREY, color(0)));
}

void draw(){
  background(BACKGROUND_COLOR);
  circle.display();
  triangle.display();
  
  noise.update();
  noise.display();
} 
