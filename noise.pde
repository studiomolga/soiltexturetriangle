enum Type {
  NONE, BACKGROUND, CIRCLE, TRI, TRI_BORDER, PERLIN
};

enum Season {
  SUMMER, AUTUMN, WINTER, SPRING
};

enum Soil {
    SAND(0), LOAMY_SAND(1), SANDY_LOAM(2), LOAM(3), SANDY_CLAY_LOAM(4), SANDY_CLAY(5), CLAY_LOAM(6), CLAY(7), SILTY_CLAY(8), SILTY_CLAY_LOAM(9), SILT_LOAM(10), SILT(11);

    private int value;
    private static Map map = new HashMap();

    private Soil(int value) {
        this.value = value;
    }

    static {
        for (Soil soil : Soil.values()) {
            map.put(soil.value, soil);
        }
    }

    public static Soil valueOf(int soil) {
        return (Soil) map.get(soil);
    }

    public int getValue() {
        return value;
    }
}

class NoiseData {
  String id;
  Type type;
  color clr;
  float fade;
  float data;
  Season season;
  
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

  Noise(PGraphics shapeBuffer, float rate) {
    this.shapeBuffer = shapeBuffer;
    this.rate = rate;
    buffer = createGraphics(width, height);
    startTime = millis();
    noiseData = new NoiseData[0];
  }
  
  void setTriangleColor(color clr) {
    triangleClr = clr;
  }

  void addItemToNoiseData(NoiseData nmap) {
    noiseData = (NoiseData[]) append(noiseData, nmap);
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
      float offset = ((data / 150.0f) * 4.0f) + 1.4f;          //black: 1.4, white: 3.4, black: 5.4
      float mult = offset * HALF_PI;  
      inter = cos(1.75*(pos.y / height) + mult);
      inter += 1.0;
      inter /= 2.0;
      float chance = (((abs(pos.y - height) / height) * 0.25) + 0.75) * 95;

      if(random(100) > chance){
        float randIncr = random(-0.3, 0.3);
        inter += randIncr;
      }
      clr = lerpColor(startClr, endClr, inter);
      break;
    case CIRCLE:
      float diameter = 350;
      inter = pos.y / (diameter / 2.0f);
      float randIncr = random(-0.2, 0.2);
      float colorInter = 0.0f;
      
      switch(season){
        case SUMMER:
          colorInter = (constrain(data, 15, 55.0f) - 15.0f) / 40.0f;
          startClr = lerpColor(color(255, 106, 166), color(255, 0, 121), colorInter);
          endClr = lerpColor(color(221, 255, 239), color(255, 193, 0), colorInter);
          break;
        case AUTUMN:
          colorInter = (constrain(data, -10.0f, 45.0f) + 10.0f) / 55.0f;
          startClr = lerpColor(color(237, 255, 184), color(255, 93, 79), colorInter);
          endClr = lerpColor(color(239, 135, 139), color(255, 0, 121), colorInter);
          break;
        case WINTER:
          colorInter = (constrain(data, -10.0f, 25.0f) + 10.0f) / 35.0f;
          startClr = lerpColor(color(213, 249, 220), color(255, 192, 69), colorInter);
          endClr = lerpColor(color(184, 234, 255), color(143, 253, 214), colorInter);
          break;
        case SPRING:
          colorInter = (constrain(data, 5, 40.0f) - 5.0f) / 35.0f;
          startClr = lerpColor(color(182, 242, 255), color(96, 251, 182), colorInter);
          endClr = lerpColor(color(219, 184, 255), color(255, 85, 234), colorInter);
          break;
      }
      clr = lerpColor(startClr, endClr, inter + randIncr);
      break;
    case TRI:
      clr = color(random(256), random(256), random(256));
      break;
    case TRI_BORDER:
      clr = color(random(256));
      break;
    case PERLIN:
      Soil soil = Soil.valueOf((int) data);
      //println(soil);
      float c = random(100);
      switch(soil){
        case SAND:
          if(c < 10){
            clr = color(255);
          } else {
            clr = color(0);
          }
          break;
        case LOAMY_SAND:
          if(c < 3){
            clr = color(255);
          } else {
            clr = color(0);
          }
          break;
        case SANDY_LOAM:
          if(c > 2 && c < 7){
            clr = color(random(120, 170));
          } else if(c <= 2 ){
            clr = color(255);
          } else {
            clr = color(0);
          }
          break;
        case LOAM:
          if(c > 2 && c < 5){
            clr = color(random(90, 140));
          } else if(c <= 2 ){
            clr = color(200);
          } else {
            clr = color(0);
          }
          break;
        case SANDY_CLAY_LOAM:
          if(c > 2 && c < 4){
            clr = color(random(60, 110));
          } else if(c <= 2 ){
            clr = color(150);
          } else {
            clr = color(0);
          }
          break;
        case SANDY_CLAY:
          if(c > 2 && c < 12){
            clr = color(random(60, 110));
          } else if(c <= 2 ){
            clr = color(160);
          } else {
            clr = color(0);
          }
          break;
        case CLAY_LOAM:
          if(c > 2 && c < 12){
            clr = color(random(60, 80));
          } else if(c <= 2 ){
            clr = color(100);
          } else {
            clr = color(0);
          }
          break;
        case CLAY:
          if(c < 2){
            clr = color(random(60, 90));
          } else {
            clr = color(0);
          }
          break;
        case SILTY_CLAY:
          if(c < 20){
            clr = color(random(60, 90));
          } else {
            clr = color(0);
          }
          break;
        case SILTY_CLAY_LOAM:
          if(c > 1 && c < 3){
            clr = color(random(90, 130));
          } else if(c <= 1){
            clr = color(170);
          } else {
            clr = color(0);
          }
          break;
        case SILT_LOAM:
          if(c > 1 && c < 5){
            clr = color(random(120, 150));
          } else if(c <= 1){
            clr = color(170);
          } else {
            clr = color(0);
          }
          break;
        case SILT:
          if(c > 2 && c < 12){
            clr = color(random(100, 140));
          } else if(c <= 2 ){
            clr = color(160);
          } else {
            clr = color(0);
          }
          break;
      }
      //clr = color(random(127, 256));
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
    }
  }

  void display() {
    image(buffer, 0, 0);
  }
}
