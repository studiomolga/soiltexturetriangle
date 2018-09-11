enum Type {
  NONE, BACKGROUND, CIRCLE, TRI, TRI_BORDER
};

class NoiseMap {
  String id;
  Type type;
  color clr;
  boolean isEliminating;

  /*
  TODO: add a data array here, this could be different for every noisemap. It would pass along all data needed in order to create the speciic noise color
   TODO: add a way of updating the data array with new data.
   TODO: change name of NoiseMap to NoiseData
   TODO: add special border constructor, which should take the colors of the two other components and use it to have all other colors of which the alpha is 255 set to a noise color mode
   */

  NoiseMap(String id, Type type, color clr) {
    this.id = id;
    this.type = type;
    this.clr = clr;
  }
}

class Noise {
  PGraphics buffer;
  PGraphics shapeBuffer;
  float rate;
  float startTime;
  color triangleClr;
  NoiseMap noiseMap[];

  Noise(PGraphics shapeBuffer, float rate) {
    this.shapeBuffer = shapeBuffer;
    this.rate = rate;
    buffer = createGraphics(width, height);
    startTime = millis();
    noiseMap = new NoiseMap[0];
  }

  void setTriangleColor(color clr) {
    triangleClr = clr;
  }

  void addItemToNoiseMap(NoiseMap nmap) {
    noiseMap = (NoiseMap[]) append(noiseMap, nmap);
  }

  color getColor(Type type, PVector pos) {
    color clr = color(0);
    color startClr = color(0);
    color endClr = color(255);
    float inter = 0;
    switch(type) {
    case NONE:
      break;
    case BACKGROUND:
      float gradientOffset = 0;        //play with this value can also be negative
      inter = (pos.y - gradientOffset) / (height - gradientOffset);
      startClr = color(0);
      endClr = color(127);
      if (random(100) < inter * 100) {
        clr = lerpColor(startClr, endClr, inter);
      } else {
        clr = color(startClr);
      }
      break;
    case CIRCLE:
      float diameter = 350;
      inter = pos.y / (diameter / 2.0f);
      startClr = color(88, 75, 186);
      endClr = color(241, 165, 15);
      float randIncr = random(-0.2, 0.2);
      clr = lerpColor(startClr, endClr, inter + randIncr);
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

  Type getType(int x, int y) {
    Type type = Type.BACKGROUND;
    //color clr = shapeBuffer.get(x, y);

    color c = shapeBuffer.get(x, y);
    float alpha = alpha(c);
    color clr = color(red(c), green(c), blue(c));
  
    //if(red(clr) == 0 && green(clr) == 255 && blue(clr) == 0){
    //  print(red(clr));
    //  print(", ");
    //  print(green(clr));
    //  print(", ");
    //  print(blue(clr));
    //  print(", ");
    //  println(alpha(clr));
    //}
    
    //print(red(clr));
    //print(", ");
    //print(green(clr));
    //print(", ");
    //print(blue(clr));
    //print(", ");
    //println(alpha(clr));
    for (NoiseMap item : noiseMap) {
      
      if(red(item.clr) == 0 && green(item.clr) == 255 && blue(item.clr) == 0){
        println(item.type);
      }

      if (item.clr == clr) {
        //println("looping through noisemap");
        float rand = random(255);
        //print("item.type: ");
        //print(item.type);
        //print(" | rand < alpha: ");
        //println(rand < alpha);
        if (item.type ==  Type.CIRCLE && rand < alpha) {
          //print("random val: ");
          //print(rand);
          //print(" | alpha: ");
          //println(alpha);
          //print(" | color: ");
          //print(red(clr));
          //print(", ");
          //print(green(clr));
          //print(", ");
          //println(blue(clr));
        }       
        if (rand < alpha) {
          type = item.type;
          //if (type == Type.TRI) {
          //  println(type);
          //}
        }
        break;
      }
    }
    return type;
  }

  void update() {
    if (millis() - startTime > rate) {
      buffer.beginDraw();
      buffer.clear();
      buffer.background(0, 0);
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          //color shapeClr = shapeBuffer.get(x, y);
          //float alpha = alpha(shapeClr);
          //shapeClr = color(red(shapeClr), green(shapeClr), blue(shapeClr));
          //Type t = getType(shapeClr);
          Type t = getType(x, y);
          if (t != Type.NONE) {
            color clr = getColor(t, new PVector(x, y));
            buffer.set(x, y, clr);
          }
        }
      }
      println("-------------------");
      buffer.endDraw();
      startTime = millis();
    }
  }

  void display() {
    image(buffer, 0, 0);
  }
}
