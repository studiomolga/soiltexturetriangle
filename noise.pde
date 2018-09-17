import java.util.Calendar;

enum Type {
  NONE, BACKGROUND, CIRCLE, TRI, TRI_BORDER, PERLIN
};

enum Season {
  SUMMER, AUTUMN, WINTER, SPRING
};

class NoiseData {
  String id;
  Type type;
  color clr;
  float fade;
  float data;
  Season season;
  
  /*
  the data array suggested below should somehow be linked to our data parser, so we wait until we are in a position to implement the dataparser
  TODO: add a data array here, this could be different for every noisemap. It would pass along all data needed in order to create the speciic noise color
   TODO: add a way of updating the data array with new data.
   TODO: add special border constructor, which should take the colors of the two other components and use it to have all other colors of which the alpha is 255 set to a noise color mode
   */

  NoiseData(String id, Type type, color clr, float fade, Date timeStamp) {
    this.id = id;
    this.type = type;
    this.clr = clr;
    this.fade = fade;
    data = 0;
    season = getSeason(timeStamp);
  }
  
  Season getSeason(Date timeStamp){
    Season s = Season.SUMMER;
    
    Date spring = getDate("0301");
    Date summer = getDate("0601");
    Date autumn = getDate("0901");
    Date winter = getDate("1201");
        
    if((timeStamp.after(spring) && timeStamp.before(summer)) || timeStamp.equals(spring)){
      s = Season.SPRING;
    } else if((timeStamp.after(summer) && timeStamp.before(autumn)) || timeStamp.equals(summer)){
      s = Season.SUMMER;
    } else if((timeStamp.after(autumn) && timeStamp.before(winter)) || timeStamp.equals(autumn)){
      s = Season.AUTUMN;
    } else if((timeStamp.after(winter) && timeStamp.before(spring)) || timeStamp.equals(winter)){
      s = Season.WINTER;
    }
    return s;
  }
  
  Date getDate(String ts){
    Date timeStamp = new Date();
    SimpleDateFormat ft = new SimpleDateFormat("MMdd");
    try{
      timeStamp = ft.parse(ts);
    } catch (ParseException e){
      println("could not convert timestamp");
    }
    return timeStamp;
  }
  
  
  void setData(float value){
    //this might turn in to a data array, depending on certain decisions
    data = value;
  }
}

class Noise {
  PGraphics buffer;
  PGraphics shapeBuffer;
  float rate;
  float startTime;
  color triangleClr;
  NoiseData noiseData[];
  float test;

  Noise(PGraphics shapeBuffer, float rate) {
    this.shapeBuffer = shapeBuffer;
    this.rate = rate;
    buffer = createGraphics(width, height);
    startTime = millis();
    noiseData = new NoiseData[0];
    test = 0;
  }
  
  void setTriangleColor(color clr) {
    triangleClr = clr;
  }

  void addItemToNoiseData(NoiseData nmap) {
    noiseData = (NoiseData[]) append(noiseData, nmap);
  }
  
  void setTest(float t){
    test = t;
  }

  color getColor(Type type, PVector pos, float data, Season season) {
    color clr = color(0);
    color startClr = color(0);
    color endClr = color(255);
    float inter = 0;
    switch(type) {
    case NONE:
      break;
    case BACKGROUND:
      float offset = ((data / 150) * 4) + 1.4;          //black: 1.4, white: 3.4, black: 5.4
      float mult = offset * HALF_PI;  
      inter = cos(1.75*(pos.y / height) + mult);
      inter += 1.0;
      inter /= 2.0;
      float chance = (((abs(pos.y - height) / height) * 0.25) + 0.75) * 95;
      
      if(random(100) < chance){
        clr = lerpColor(startClr, endClr, inter);
      } else {
        clr = color(random(127));
      }
      break;
    case CIRCLE:
      //println(data);
      //println(season);
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
    case PERLIN:
      clr = color(random(127, 256));
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
  
  float getData(Type t){
    float data = 0;
    for (NoiseData item : noiseData){
      if(item.type == t){
        data = item.data;
        break;
      }
    }
    return data;
  }
  
  Season getSeason(Type t){
    Season season = Season.SUMMER;
    for (NoiseData item : noiseData){
      if(item.type == t){
        season = item.season;
        break;
      }
    }    
    return season;
  }

  void update() {
    if (millis() - startTime > rate) {
      buffer.beginDraw();
      buffer.clear();
      buffer.background(0, 0);
      
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          Type t = getType(x, y);
          if (t != Type.NONE) {
            float data = getData(t);
            Season season = getSeason(t);
            color clr = getColor(t, new PVector(x, y), data, season);
            buffer.set(x, y, clr);
          }
        }
      }
      buffer.endDraw();
      startTime = millis();
      //println("----------------");
    }
  }

  void display() {
    image(buffer, 0, 0);
  }
}
