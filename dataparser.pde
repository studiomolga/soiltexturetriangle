import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Date;

class DataFile {
  JSONArray data;
  JSONObject currData;
  float values[];
  int dataIndex;
  String tid;
  Date timeStamp;

  DataFile(JSONObject json, String tid) {
    JSONObject dataObject = json.getJSONArray("Data").getJSONObject(0);
    
    String ts = dataObject.getString("StartDate");
    ts = ts.substring(4, 8);
    SimpleDateFormat ft = new SimpleDateFormat("MMdd");
    try{
      timeStamp = ft.parse(ts);
    } catch (ParseException e){
      println("could not convert timestamp");
    }
    
    data = dataObject.getJSONArray("Data");
    this.tid = tid;
    setDataIndex(0);
    
    values = new float[data.size()];
    for(int i = 0; i < data.size(); i++){
      JSONObject value = data.getJSONObject(i % data.size());
      values[i] = value.getFloat("Value");
    }
  }
  
  Date getTimeStamp(){
    return timeStamp;
  }

  int getDataSize() {
    return(data.size());
  }

  void setDataIndex(int dataIndex) {
    this.dataIndex = dataIndex;
    currData = data.getJSONObject(this.dataIndex);
  }
  
  float getMaxValue(){
    return max(values);
  }
  
  float getCurrentValue(){
    float value = values[dataIndex];
    dataIndex++;    //TODO: move this to a seperate function, when you use the getCurrentValue and getNextValue functions in the wrong order they cause confusion, better to seperate
    dataIndex %= data.size();
    return value;
  }
  
  float getNextValue(){
    int index = (dataIndex + 1) % data.size();
    float value = values[index];
    return value;
  }
}

class DataParser {
  final String ID_STRINGS[] = {"temperature", "light"}; //we do this to be able to force the order of the datafiles
  String[] files;
  DataFile[] dataFiles;

  DataParser(String path) {
    String files[] = listFiles(path);
    dataFiles = new DataFile[files.length];
    
    for(int i = 0; i < ID_STRINGS.length; i++){
      String tid = ID_STRINGS[i];
      for(int j = 0; j < files.length; j++){
        if(files[j].contains(ID_STRINGS[i])){
          DataFile dataFile = new DataFile(loadJSONObject(files[j]), tid);
          dataFiles[i] = dataFile;
          break;
        }
      }
    }
  }
  
  String[] getStringIds(){
    return ID_STRINGS;
  }
  
  float[] getMaxValues(){
    float values[] = new float[dataFiles.length];
    for(int i = 0; i < dataFiles.length; i++){
      values[i] = dataFiles[i].getMaxValue();
    }
    return values;
  }
  
  Date getTimeStamp(){
    //we just return the timestamp of the first data file, as they will all be of the same day
    return dataFiles[0].getTimeStamp();
  }

  float[] getCurrentValues(){
    float values[] = new float[dataFiles.length];
    for(int i = 0; i < dataFiles.length; i++){
      values[i] = dataFiles[i].getCurrentValue();
    }
    return values;
  }

  float[] getNextValues(){
    float values[] = new float[dataFiles.length];
    for(int i = 0; i < dataFiles.length; i++){
      values[i] = dataFiles[i].getNextValue();
    }
    return values;
  }
  
  String[] listFiles(String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      File files[] = file.listFiles();
      String names[] = new String[files.length];
      for(int i = 0; i < files.length; i++){
        String absolutePath = files[i].getAbsolutePath();
        names[i] = absolutePath;
      }
      names = sort(names);
      return names;
    } else {
      // If it's not a directory
      return null;
    }
  }
}
