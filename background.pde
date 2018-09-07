//class Background{
//  color startClr;
//  color endClr;
//  float size;
  
//  Background(float size, color startClr, color endClr){
//    this.startClr = startClr;
//    this.endClr = endClr;
//    this.size = size;
//  }
  
//  void display(){
//    for(float y = height; y > (height - size); y--){
//      float inter = (y - size)  / size;
//      color clr = lerpColor(startClr, endClr, inter);
//      stroke(clr);
//      line(0, y, width, y);
//    }
//  }
  
//  void printClr(color c){
//    print(red(c));
//    print(", ");
//    print(green(c));
//    print(", ");
//    println(blue(c));
//  }
//}
