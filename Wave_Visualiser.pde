int RES = 6, step = 0;
float THRESHOLD_VALUE = 0;
ArrayList<Wave_Source> sources = new ArrayList<Wave_Source>();

void setup(){
  size(960, 600);
  noStroke();
  int noOfSources = 3;  // Can be changed for anywhere between 1 and 5
  for (int i = 0; i < noOfSources; i++){
    float displacement = 0.1*(i%2 - 0.5);
    if ((i == 0)||(i == noOfSources-1)){ displacement = 0; }
    float x = width*(0.1*(6 - noOfSources)+0.2*i), y = height*(0.5-displacement), o = 0.1;
    Wave_Source source = new Wave_Source(x, y, o);
    source.setK(0.1);
    sources.add(source);
  }
}

void draw(){
  clear();
  fill(55, 55, 200);
  
  // Draw each square
  for (int y = 0; y <= height-RES; y+=RES){
    for (int x = 0; x <= width-RES; x+=RES){
      drawSquare(x, y);
    }
  }
  
  // Draw the sources
  for (Wave_Source s : sources){
    s.draw();
  }
  
  step++;
}

/** Returns a value to be used in drawing the 'marching squares' */
float getValue(float xf, float yf){
  float value = 0;
  for (Wave_Source s : sources){
    value += s.getValue(xf, yf, step);
  }
  return value;
}

/** Returns a unique int to represent the 'state' of the square */
int getState(float nw, float ne, float sw, float se){
  int state = 0;
  if (nw > THRESHOLD_VALUE){ state += 8; }
  if (ne > THRESHOLD_VALUE){ state += 4; }
  if (se > THRESHOLD_VALUE){ state += 2; }
  if (sw > THRESHOLD_VALUE){ state++; }
  return state;
}

/** Fills this 'marching square' with a shape to represent part of the field, represented by getValue(x, y) */
void drawSquare(float x, float y){
  float nw = getValue(x, y), ne = getValue(x+RES, y), sw = getValue(x, y+RES), se = getValue(x+RES, y+RES);
  int state = getState(nw, ne, sw, se);
  float nMid = (nw - THRESHOLD_VALUE)/(nw - ne), sMid = (sw - THRESHOLD_VALUE)/(sw - se);
  float wMid = (nw - THRESHOLD_VALUE)/(nw - sw), eMid = (ne - THRESHOLD_VALUE)/(ne - se);
  
  // Create a shape within a given 'marching' square
  beginShape();
  switch(state){
    case 0:
      // No fill, so no lines
      break;
    case 1:
      // Fill triangle in the south-west corner
      vertex(x, y + wMid*RES);
      vertex(x, y + RES);
      vertex(x + sMid*RES, y + RES);
      break;
    case 2:
      // Fill triangle in the south-east corner
      vertex(x + RES, y + eMid*RES);
      vertex(x + sMid*RES, y + RES);
      vertex(x + RES, y + RES);
      break;
    case 3:
      // Fill rectangle in the south half
      vertex(x + RES, y + eMid*RES);
      vertex(x, y + wMid*RES);
      vertex(x, y + RES);
      vertex(x + RES, y + RES);
      break;
    case 4:
      // Fill triangle in the north-east corner
      vertex(x + nMid*RES, y);
      vertex(x + RES, y);
      vertex(x + RES, y + eMid*RES);
      break;
    case 5:
    // Fill triangle in the south-west corner
      vertex(x, y + wMid*RES);
      vertex(x, y + RES);
      vertex(x + sMid*RES, y + RES);
      // If the value at the center is above the THRESHOLD_VALUE, break the shape into triangles 
      // else, if the value is below the THRESHOLD_VALUE, keep the polygon linked
      if (getValue(x + 0.5*RES, y + 0.5*RES) > THRESHOLD_VALUE){
        endShape(CLOSE);
        beginShape();
      }
      // Fill triangle in the south-east corner
      vertex(x + RES, y + eMid*RES);
      vertex(x + RES, y);
      vertex(x + nMid*RES, y);
      break;
    case 6:
      // Fill rectangle in the east half
      vertex(x + sMid*RES, y + RES);
      vertex(x + nMid*RES, y);
      vertex(x + RES, y);
      vertex(x + RES, y + RES);
      break;
    case 7:
      // Fill the whole square except in the north-west corner
      vertex(x + nMid*RES, y);
      vertex(x, y + wMid*RES);
      vertex(x, y + RES);
      vertex(x + RES, y + RES);
      vertex(x + RES, y);
      break;
    case 8:
      // Fill triangle in the north-west corner
      vertex(x + nMid*RES, y);
      vertex(x, y + wMid*RES);
      vertex(x, y);
      break;
    case 9:
      // Fill rectangle in the north half
      vertex(x + sMid*RES, y + RES);
      vertex(x + nMid*RES, y);
      vertex(x, y);
      vertex(x, y + RES);
      break;
    case 10:
      // Fill triangle in the south-east corner
      vertex(x + RES, y + eMid*RES);
      vertex(x + RES, y + RES);
      vertex(x + sMid*RES, y + RES);
      // If the value at the center is above the THRESHOLD_VALUE, break the shape into triangles 
      // else, if the value is below the THRESHOLD_VALUE, keep the polygon linked
      if (getValue(x + 0.5*RES, y + 0.5*RES) > THRESHOLD_VALUE){
        endShape(CLOSE);
        beginShape();
      }
      // Fill triangle in the north-west corner
      vertex(x, y + wMid*RES);
      vertex(x, y);
      vertex(x + nMid*RES, y);
      break;
    case 11:
      // Fill the whole square except in the north-east corner
      vertex(x + nMid*RES, y);
      vertex(x, y);
      vertex(x, y + RES);
      vertex(x + RES, y + RES);
      vertex(x + RES, y + eMid*RES);
      break;
    case 12:
      // Fill rectangle in the north half
      vertex(x + RES, y + eMid*RES);
      vertex(x, y + wMid*RES);
      vertex(x, y);
      vertex(x + RES, y);
      break;
    case 13:
      // Fill the whole square except in the south-east corner
      vertex(x + sMid*RES, y + RES);
      vertex(x + RES, y + eMid*RES);
      vertex(x + RES, y);
      vertex(x, y);
      vertex(x, y + RES);
      break;
    case 14:
      // Fill the whole square except in the south-west corner
      vertex(x + sMid*RES, y + RES);
      vertex(x, y + wMid*RES);
      vertex(x, y);
      vertex(x + RES, y);
      vertex(x + RES, y + RES);
      break;
    case 15:
      // All filled, so no lines
      rect(x, y, RES, RES);
      break;
  }
  endShape(CLOSE);
}
