static final int BACKGROUND_COLOR = 0;

Noise noise;
Triangle triangle;
PShape tri;

void setup(){
  size(480, 480);
  noise = new Noise(85.0f, 40.0f);
  color clr = color(170);
  triangle = new Triangle(100, clr);
  tri = triangle.getShape();
  //noise.addItemToNoiseMap(new NoiseMap("background", Type.GREY, BACKGROUND_COLOR));
  noise.addItemToNoiseMap(new NoiseMap("triangle", Type.COLOR, clr));
}

void draw(){
  background(BACKGROUND_COLOR);
  shape(tri, 0, 0);
  
  noise.update();
  noise.display();
} 
