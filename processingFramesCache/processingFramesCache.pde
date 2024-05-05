// cache and loop animated sequences in Processing using frames from folders in the "data" folder

import java.util.Date;
Sequence [] sequence = new Sequence[3];

void setup() {
  fullScreen();
  //size(1920, 1080);
  frameRate(10);
  background(0);
  sequence[0] = new Sequence("capybara", 0.25);
  sequence[1] = new Sequence("ostrich", 0.50);
}

void draw() {
  sequence[0].runTimecode();
  for (int i = 0; i <= width/sequence[0].w; i++) {
    int pos = i*sequence[0].w;
    sequence[0].playWithOffset(pos, 0, i);
    int h = sequence[0].h + sequence[1].h;
    sequence[0].playWithOffset(pos, h, i);
    sequence[0].playWithOffset(pos, h*2, i);
  }

  sequence[1].runTimecode();
  for (int i = 0; i <= width/sequence[1].w; i++) {
    int pos = i*sequence[1].w;
    sequence[1].playWithOffset(pos, sequence[0].h, i);
    int h = sequence[0].h + sequence[1].h + sequence[0].h;
    sequence[1].playWithOffset(pos, h, i);
  }
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

class Sequence {
  PImage [] frame;
  int w, h;
  int timecode = 0;

  Sequence(String seq_name, float scale) {
    scale = 1/scale;
    String folder = sketchPath() + "/data/" + seq_name + "/";
    StringList listOfFrames = listFrames(folder);
    println(listOfFrames);
    frame = new PImage[listOfFrames.size()];
    for (int i = 0; i < frame.length; i++) {
      frame[i] = loadImage(listOfFrames.get(i));
      frame[i].resize(int(frame[i].width/scale), int(frame[i].height/scale));
    }
    w = frame[0].width;
    h = frame[0].height;
  }

  void runTimecode() {
    timecode++;
    if (timecode == frame.length) timecode = 0;
  }

  void play(float x, float y) {
    image(frame[timecode], x, y);
  }

  void playWithOffset(float x, float y, int offset) {
    int frameNumber = timecode + offset;
    if (frameNumber >= frame.length) frameNumber = frameNumber - frame.length;
    image(frame[frameNumber], x, y);
  }
}
