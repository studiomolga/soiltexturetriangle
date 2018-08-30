enum Type {BINARY, GREY, COLOR};

class Noise{
  PGraphics buffer;
  float density;
  float rate;
  float startTime;
  Type type;
  
  Noise(float density, float rate){
    this.density = density;
    this.rate = rate;
    buffer = createGraphics(width, height);
    startTime = millis();
    type = Type.COLOR;
  }
  
  void setDensity(float density){
    this.density = density;
  }
  
  void setType(Type type){
    this.type = type;
  }
  
  color getColor(){
    //here we can place any format for coloring the noise, just make sure we add this to the Type enum at the top of the file
    color clr = color(0);
    switch(type){
      case BINARY:
        clr = color(random(2) * 255);
        break;
      case GREY:
        clr = color(random(256));
        break;
      case COLOR:
        clr = color(random(256), random(256), random(256));
        break;
    }
    return clr;
  }
  
  void update(){
    if(millis() - startTime > rate){
      buffer.beginDraw();
      buffer.clear();
      buffer.background(0, 0);
      for(int x = 0; x < width; x++){
        for(int y = 0; y < height; y++){
          if(random(100) < density){
            color clr = getColor();
            buffer.set(x, y, clr);
          }
        }
      }
      buffer.endDraw();
      startTime = millis();
    }
  }
  
  void display(){
    image(buffer, 0, 0);
  }
}
