//import java.util.Map;

enum Type {NONE, BINARY, GREY, COLOR};

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
  float density;
  float rate;
  float startTime;
  
  color triangleClr;
  
  //HashMap<String,Type> typeHashMap;
  //Type type;
  NoiseMap noiseMap[];
  
  Noise(float density, float rate){
    this.density = density;
    this.rate = rate;
    buffer = createGraphics(width, height);
    startTime = millis();
    //type = Type.COLOR;
    noiseMap = new NoiseMap[0];
    //typeHashMap = new HashMap<String,Type>();
  }
  
  void setDensity(float density){ 
    this.density = density;
  }
  
  void setTriangleColor(color clr){
    triangleClr = clr;
  }
  
  void addItemToNoiseMap(NoiseMap nmap){
    noiseMap = (NoiseMap[]) append(noiseMap, nmap);
    //println(noiseMap)
  }
  
  //void setType(Type type){
  //  this.type = type;
  //}
  
  color getColor(Type type){
    //here we can place any format for coloring the noise, just make sure we add this to the Type enum at the top of the file
    color clr = color(0);
    switch(type){
      case NONE:
        break;
      case BINARY:
        clr = color(random(2) * 255);
        //clr = color(255, 32);
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
  
  Type getType(int x, int y){
    Type type = Type.BINARY;
    color clr = get(x, y);
    //println(red(clr));
    for(NoiseMap item : noiseMap){
      //println(item.type);
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
          if(random(100) < density){
            Type t = getType(x, y);
            //println(t);
            if(t != Type.NONE){
              color clr = getColor(t);
              buffer.set(x, y, clr);
            }
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
