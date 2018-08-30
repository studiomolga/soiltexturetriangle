Noise noise;

void setup(){
  size(480, 480);
  noise = new Noise(50.0f, 20.0f);
}

void draw(){
  background(255);
  noise.update();
  noise.display();
}
