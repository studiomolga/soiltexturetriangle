enum Type {
  NONE, BACKGROUND, CIRCLE, TRI, TRI_BORDER
};

class NoiseData {
  String id;
  Type type;
  color clr;
  float fade;

  /*
  the data array suggested below should somehow be linked to our data parser, so we wait until we are in a position to implement the dataparser
  TODO: add a data array here, this could be different for every noisemap. It would pass along all data needed in order to create the speciic noise color
   TODO: add a way of updating the data array with new data.
   TODO: add special border constructor, which should take the colors of the two other components and use it to have all other colors of which the alpha is 255 set to a noise color mode
   */

  NoiseData(String id, Type type, color clr, float fade) {
    this.id = id;
    this.type = type;
    this.clr = clr;
    this.fade = fade;
  }
}

class Noise {
  PGraphics buffer;
  PGraphics shapeBuffer;
  float rate;
  float startTime;
  color triangleClr;
  NoiseData noiseData[];
  float circleFade;
  float fadeIncr;

  Noise(PGraphics shapeBuffer, float rate) {
    this.shapeBuffer = shapeBuffer;
    this.rate = rate;
    buffer = createGraphics(width, height);
    startTime = millis();
    noiseData = new NoiseData[0];
    circleFade = 0;
    fadeIncr = 0.1;
  }

  void setTriangleColor(color clr) {
    triangleClr = clr;
  }

  void addItemToNoiseData(NoiseData nmap) {
    noiseData = (NoiseData[]) append(noiseData, nmap);
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
    color clr = shapeBuffer.get(x, y);

    for (NoiseData item : noiseData) {
      if (item.clr == clr) {
        float rand = random(100);   
        if (rand < item.fade) {
          type = item.type;
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
      if (circleFade <= 100.0f) {
        circleFade += fadeIncr;
      } else {
        circleFade = 100.0f;
      }
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          Type t = getType(x, y);
          if (t != Type.NONE) {
            color clr = getColor(t, new PVector(x, y));
            buffer.set(x, y, clr);
          }
        }
      }
      buffer.endDraw();
      startTime = millis();
    }
  }

  void display() {
    image(buffer, 0, 0);
  }
}
