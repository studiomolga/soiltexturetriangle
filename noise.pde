enum Type {NONE, BACKGROUND, CIRCLE, TRI, TRI_BORDER};

class NoiseMap{
  String id;
  Type type;
  color clr;
  
  NoiseMap(String id, Type type, color clr){
    this.id = id;
    this.type = type;
    this.clr = clr;
  }
}

class Noise{
  PGraphics buffer;
  PGraphics shapeBuffer;
  float rate;
  float startTime;
  color triangleClr;
  NoiseMap noiseMap[];
  
  Noise(PGraphics shapeBuffer, float rate){
    this.shapeBuffer = shapeBuffer;
    this.rate = rate;
    buffer = createGraphics(width, height);
    startTime = millis();
    noiseMap = new NoiseMap[0];
  }
   
  void setTriangleColor(color clr){
    triangleClr = clr;
  }
  
  void addItemToNoiseMap(NoiseMap nmap){
    noiseMap = (NoiseMap[]) append(noiseMap, nmap);
  }
  
  color getColor(Type type, PVector pos){
    //here we can place any format for coloring the noise, just make sure we add this to the Type enum at the top of the file
    
    /* 
    somehow here we need to make something that can form a gradient out of the noise... which means we will need to know the coordinate of the pixel
    it however still needs to be noise so there needs to be some random distribution, i guess we can do something with colorLerp() and then a random variation of the inter value 
    but we might have to inject some other random colors in order to keep the feelinig of it being noise, but first we should try the above method
    */
    color clr = color(0);
    switch(type){
      case NONE:
        break;
      case BACKGROUND:
        float gradientOffset = 100;        //play with this value can also be negative
        float inter = (pos.y - gradientOffset) / (height - gradientOffset);
        if(random(100) < inter * 100){
          clr = lerpColor(color(255), color(0), inter);
        } else {
            clr = color(255);
        }
        break;
      case CIRCLE:
        clr = color(random(256));
        break;
      case TRI:
        clr = color(random(256), random(256), random(256));
        break;
      case TRI_BORDER:
        clr = color(random(256));
        break;
    }
    return clr;
  }
  
  Type getType(int x, int y){
    Type type = Type.BACKGROUND;
    color clr = shapeBuffer.get(x, y);
    for(NoiseMap item : noiseMap){
      if(item.clr == clr){
        type = item.type;
        break;
      }
    }
    return type;
  }
  
  void update(){
    if(millis() - startTime > rate){
      buffer.beginDraw();
      buffer.clear();
      buffer.background(0, 0);
      for(int x = 0; x < width; x++){
        for(int y = 0; y < height; y++){
          Type t = getType(x, y);
          if(t != Type.NONE){
            color clr = getColor(t, new PVector(x, y));
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
