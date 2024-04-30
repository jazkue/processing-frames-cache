// cache and loop an animated sequence in Processing using frames from the "data" folder

import java.util.Date;
PImage [] frame;
int timeCode = 0;

void setup() {
  size(1920, 1080);
  frameRate(10);
  background(0);

  String folder = sketchPath() + "/data/";
  StringList listOfFrames = listFrames(folder);
  print(listOfFrames);
  frame = new PImage[listOfFrames.size()];
  for (int i = 0; i < frame.length; i++) {
    frame[i] = loadImage(listOfFrames.get(i));
  }
}

void draw() {
  translate(-frame[0].width/2, -frame[0].height/2);
  translate(width/2, height/2);
  image(frame[timeCode], 0, 0);
  translate(-frame[0].width/2, -frame[0].height/2);

  timeCode++;
  if (timeCode == frame.length) timeCode = 0;
}


StringList listFrames(String dir) {
  String exts [] = {"jpg", "jpeg", "png", "gif", "tiff"};
  File directory = new File(dir);
  if (directory.isDirectory()) {
    StringList fileNames = new StringList();
    String [] dirList = directory.list();
    for (int i = 0; i < dirList.length; i ++)
      for (int j = 0; j < exts.length; j ++) {
        if (dirList[i].indexOf(exts[j]) >= 0) {
          fileNames.append(dir + dirList[i]);
        }
      }
    fileNames.sort();
    return fileNames;
  } else {
    return null;
  }
}
