// cache and loop animated sequences in Processing using frames from subfolders in the "data" folder

import java.util.Date;
Sequence [] sequence = new Sequence[3];

void setup() {
  fullScreen();
  //size(1920, 1080);
  frameRate(10);
  background(0);
  sequence[0] = new Sequence("capybara");
  //sequence[0].crop(0, 0, 1280, 720);
  sequence[0].resizeSequence(0.25);
  sequence[1] = new Sequence("ostrich");
  sequence[1].resizeSequence(0.5);
  //sequence[1].crop(0, 0, 1280, 720);
}

void draw() {
  sequence[0].runTimecode();
  sequence[1].runTimecode();

  int totalHeight = sequence[0].h + sequence[1].h;
  for (int j = 0; j < height; j += totalHeight) {
    pushMatrix();
    translate(0, j);
    println(sequence[0].w);
    for (int i = 0; i <= width/sequence[0].w; i++) {
      int pos = i*sequence[0].w;
      sequence[0].playWithOffset(pos, 0, i);
    }
    for (int i = 0; i <= width/sequence[1].w; i++) {
      int pos = i*sequence[1].w;
      sequence[1].playWithOffset(pos, sequence[0].h, i);
    }
    popMatrix();
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
          if (dirList[i].indexOf("._") < 0) {
            fileNames.append(dir + dirList[i]);
          }
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

  Sequence(String seq_name) {
    String folder = sketchPath() + "/data/" + seq_name + "/";
    StringList listOfFrames = listFrames(folder);
    //println(listOfFrames);
    frame = new PImage[listOfFrames.size()];
    for (int i = 0; i < frame.length; i++) {
      frame[i] = loadImage(listOfFrames.get(i));
    }
    w = frame[0].width;
    h = frame[0].height;
    println(seq_name, w+"x"+h);
  }

  void resizeSequence(float scale) {
    scale = 1/scale;
    for (int i = 0; i < frame.length; i++) {
      frame[i].resize(int(frame[i].width/scale), int(frame[i].height/scale));
      w = frame[0].width;
      h = frame[0].height;
    }
  }

  void resizeSequence(int newX, int newY) {
    for (int i = 0; i < frame.length; i++) {
      frame[i].resize(newX, newY);
      w = frame[0].width;
      h = frame[0].height;
    }
  }

  void crop(int x, int y, int wCrop, int hCrop) {
    for (int i = 0; i < frame.length; i++) {
      PImage crop = frame[i].get(x, y, wCrop, hCrop);
      frame[i] = crop;
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
    if (frameNumber >= frame.length) {
      int multiply = int(frameNumber/frame.length);
      frameNumber = frameNumber - (frame.length * multiply);
    }
    image(frame[frameNumber], x, y);
  }
}
