static final int BACKGROUND_COLOR = 255;

Noise noise;
PGraphics buffer;
Triangle triangle;
Circle circle;
PerlinCircle perlinCircle;

NoiseData backgroundData;
NoiseData circleData;
NoiseData triangleData;
NoiseData perlinData;

float circleFade;
float triangleFade;

void setup(){
  size(480, 480);
  buffer = createGraphics(width, height);
  noise = new Noise(buffer, 40.0f);
  color circleClr = color(0, 255, 0);
  color triangleClr = color(255, 0, 0);
  color perlinClr = color(0, 0, 255);
  triangle = new Triangle(buffer, 15, 80, triangleClr, 7);
  circle = new Circle(buffer, new PVector(width / 2, 0), 350, circleClr);
  perlinCircle = new PerlinCircle(buffer, triangle.getShape(), 0, height - 80, 100, 150, 200, perlinClr, triangleClr);
  
  circleFade = 0;
  triangleFade = 0;
  
  backgroundData = new NoiseData("background", Type.BACKGROUND, color(BACKGROUND_COLOR), 100);
  circleData = new NoiseData("circle", Type.CIRCLE, circleClr, circleFade);
  triangleData = new NoiseData("triangle", Type.TRI, triangleClr, triangleFade);
  perlinData = new NoiseData("perlin", Type.PERLIN, perlinClr, triangleFade);
  
  noise.addItemToNoiseData(backgroundData);
  noise.addItemToNoiseData(circleData);
  noise.addItemToNoiseData(triangleData);
  noise.addItemToNoiseData(perlinData);
  //noise.addItemToNoiseData(new NoiseData("triangle-border", Type.TRI_BORDER, color(0)));
}

void draw(){
  background(BACKGROUND_COLOR);
  clearBuffer();
 
  circle.display();
  perlinCircle.display();
  
  if(circleFade <= 100.0f){
    circleData.fade += 0.1f;
  } else {
    circleData.fade = 100.0f;
  }
  
  if(triangleFade <= 100.0f){
    triangleData.fade += 0.1f;
    perlinData.fade += 0.1f;
  } else {
    triangleData.fade = 100.0f;
    perlinData.fade = 100.0f;
  }  
  
  //image(buffer, 0, 0);
  noise.update();
  noise.display();
} 

void clearBuffer(){
  buffer.beginDraw();
  buffer.clear();
  buffer.background(BACKGROUND_COLOR, 0);
  buffer.endDraw();
}
