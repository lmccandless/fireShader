/**
 *  Fire Shader Copyright (C) 2018 Logan McCandless
 *  MIT License: https://opensource.org/licenses/MIT
 */
PShader fire, fireColor;
PGraphics buffer1,buffer2, cooling;
int w = 400, h = 400;
float ystart = 0.0;
int speed = 1000;

void setup() {
  size(400, 400, P2D);
  buffer1 = createGraphics(w, h, P2D);
  buffer2 = createGraphics(w, h, P2D);
  cooling = createGraphics(w, h, P2D);
  cool();
  fire = loadShader("fire.glsl");
  fireColor = loadShader("fireColor.glsl");
  fire.set("resolution", w*2, h);
  fire.set("buffer1", buffer1);
  fire.set("buffer2", buffer2);
  fire.set("cooling", cooling);
  frameRate(100);
}

void cool() {
  cooling.loadPixels();
  float xoff = 31.1; 
  float increment = 0.12;
  noiseDetail(3, 1.06);
  for (int x = 0; x < w; x++) {
    xoff += increment; 
    float yoff = ystart; 
    for (int y = 0; y < h; y++) {
      yoff += increment; 
      float n = noise(xoff, yoff);     
      float bright = pow(n, 2) * 22;
      cooling.pixels[x+y*w] = color(bright);
    }
  }
  cooling.updatePixels();
  ystart += increment;
}

void startFire() {
  buffer1.beginDraw();
  buffer1.resetShader();
  buffer1.noStroke();
  buffer1.fill(255);
  buffer1.rect(0,h-4,w,4);
  buffer1.textSize(48);
  buffer1.text("get the fire \n  extinguisher",mouseX,mouseY);
  buffer1.endDraw();
}

void swapBuffers(){  
  PGraphics temp = buffer1;
  buffer1 = buffer2;
  buffer2 = temp;
}

void draw() {
  fire.set("time", (frameCount % speed)/(float)speed);
  fireColor.set("time",  frameCount/1000.0);// (frameCount % speed)/(float)speed);
  startFire();
  background(0);
  buffer2.beginDraw();
  buffer2.shader(fire);
  buffer2.rect(0, 0, w, h);
  buffer2.endDraw();
  swapBuffers();
  
  image(buffer2, 0, 0);
  filter(fireColor);
  image(cooling, w, 0);
}