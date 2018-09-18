import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Date;
import java.util.Map;

static final int BACKGROUND_COLOR = 255;
static final float DATA_PERIOD = 3000;

DataParser dataParser;

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
float perlinRadius;

float dataStartTime;
String sids[];
float currValues[];
float nextValues[];

int soilTypeID = 0;

void settings(){
  size(480, 480);
  dataParser = new DataParser(sketchPath()+"/data/datafiles");
  sids = dataParser.getStringIds();
}

void setup(){
  buffer = createGraphics(width, height);
  noise = new Noise(buffer, 40.0f);
  color circleClr = color(0, 255, 0);
  color triangleClr = color(255, 0, 0);
  color perlinClr = color(0, 0, 255);
  triangle = new Triangle(buffer, 15, 80, triangleClr, 7);
  circle = new Circle(buffer, new PVector(width / 2, 0), 350, circleClr);
  perlinCircle = new PerlinCircle(buffer, triangle.getShape(), 0, height - 80, 0, 0, 200, perlinClr, triangleClr);
  
  circleFade = 80;
  triangleFade = 100;
  perlinRadius = 0;
  
  Date timeStamp = dataParser.getTimeStamp();
  
  backgroundData = new NoiseData("background", Type.BACKGROUND, color(BACKGROUND_COLOR), 100, timeStamp);
  circleData = new NoiseData("circle", Type.CIRCLE, circleClr, circleFade, timeStamp);
  triangleData = new NoiseData("triangle", Type.TRI, triangleClr, triangleFade, timeStamp);
  perlinData = new NoiseData("perlin", Type.PERLIN, perlinClr, triangleFade, timeStamp);
  
  noise.addItemToNoiseData(backgroundData);
  noise.addItemToNoiseData(circleData);
  noise.addItemToNoiseData(triangleData);
  noise.addItemToNoiseData(perlinData);
  //noise.addItemToNoiseData(new NoiseData("triangle-border", Type.TRI_BORDER, color(0)));
  
  dataStartTime = millis();
  nextValues = dataParser.getNextValues();
  currValues = dataParser.getCurrentValues();
  
  //temporary soil type set
  perlinData.setData(soilTypeID);
  println(Soil.valueOf(soilTypeID));
}

void draw(){
  background(BACKGROUND_COLOR);
  clearBuffer();
  
  if(millis() - dataStartTime >= DATA_PERIOD){
    soilTypeID += 1;
    soilTypeID %= 12;
    perlinData.setData(soilTypeID);
    println(Soil.valueOf(soilTypeID));
    
    nextValues = dataParser.getNextValues();
    currValues = dataParser.getCurrentValues();
    
    dataStartTime = millis();
    setData();
  } else {
    setData();
  }
 
  circle.display();
  perlinCircle.display();
  
  //if(circleFade <= 100.0f){
  //  circleData.fade += 0.1f;
  //} else {
  //  circleData.fade = 100.0f;
  //}
  
  perlinCircle.incrRadius(0.2f);
  
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

void setData(){
  for(int i = 0; i < currValues.length; i ++){
    float diff = nextValues[i] - currValues[i];
    float mult = (millis() - dataStartTime) / DATA_PERIOD;
    mult = (mult <= 1) ? mult : 1;
    float newValue = currValues[i] + (diff * mult);
    
    switch(sids[i]){
      case "temperature":
        circleData.setData(newValue);
        break;
      case "light":
        backgroundData.setData(newValue);
        break;
    }
  }
}

void clearBuffer(){
  buffer.beginDraw();
  buffer.clear();
  buffer.background(BACKGROUND_COLOR, 0);
  buffer.endDraw();
}
