/**
  draws a 2 x 2 grid
*/
void draw2x2() {
  fill(255, 0, 0); //red button
  rect(width/2, height/2, sizeOfInputArea/2, sizeOfInputArea/2); //draw left red button
  fill(0, 255, 0); //green button
  rect(width/2, height/2-sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2); //draw right green button
  fill(0, 0, 255); //blue button
  rect(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2, sizeOfInputArea/2, sizeOfInputArea/2);
  fill(255, 192, 203); //pink button
  rect(width/2-sizeOfInputArea/2, height/2, sizeOfInputArea/2, sizeOfInputArea/2);
}

/**
  draws a 2 x 3 grid
*/
void draw2x3() {
  fill(255, 0, 0); //red button
  rect(width/2, height/2+sizeOfInputArea/6, sizeOfInputArea/2, sizeOfInputArea/3); 
  fill(0, 255, 0); //green button
  rect(width/2, height/2+sizeOfInputArea/6-sizeOfInputArea/3, sizeOfInputArea/2, sizeOfInputArea/3); //draw right green button
  fill(128, 0, 128); // purple button
  rect(width/2, height/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3, sizeOfInputArea/2, sizeOfInputArea/3); 
  fill(0, 0, 255); //blue button
  rect(width/2-sizeOfInputArea/2, height/2+sizeOfInputArea/6-sizeOfInputArea/3, sizeOfInputArea/2, sizeOfInputArea/3);
  fill(255, 192, 203); //pink button
  rect(width/2-sizeOfInputArea/2, height/2+sizeOfInputArea/6, sizeOfInputArea/2, sizeOfInputArea/3);
  fill(255, 165, 0); // orange button
  rect(width/2-sizeOfInputArea/2, height/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3, sizeOfInputArea/2, sizeOfInputArea/3);
}

/**
  draws the void
*/
void draw_void() {
  fill(0, 0, 0);
  rect(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2, sizeOfInputArea, sizeOfInputArea);
  
  fill(100);
  rect(width/2-sizeOfInputArea/2, height/2+sizeOfInputArea/4, sizeOfInputArea/2, sizeOfInputArea/4);
  fill(255);
  text("space", width/2-sizeOfInputArea/16*6, height/2+sizeOfInputArea/32*13);
  
  fill(0,0,255);
  rect(width/2,height/2+sizeOfInputArea/4,sizeOfInputArea/2, sizeOfInputArea/4);
  fill(255);
  text("<-", width/2 + sizeOfInputArea/16*3, height/2+sizeOfInputArea/32*13);
}

void draw_void_no_text_entry() {
  fill(0, 0, 0);
  rect(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2, sizeOfInputArea, sizeOfInputArea);
  
  fill(100);
  rect(width/2-sizeOfInputArea/2, height/2+sizeOfInputArea/4-sizeOfInputArea/16*2, sizeOfInputArea/2, sizeOfInputArea/4);
  fill(255);
  text("space", width/2-sizeOfInputArea/16*6, height/2+sizeOfInputArea/32*9);
  
  fill(0,0,255);
  rect(width/2,height/2+sizeOfInputArea/4-sizeOfInputArea/8,sizeOfInputArea/2, sizeOfInputArea/4);
  fill(255);
  text("<-", width/2 + sizeOfInputArea/16*3, height/2+sizeOfInputArea/32*9);
  
  fill(255,0,0);
  rect(width/2+sizeOfInputArea/6-sizeOfInputArea/3*2, height/2+sizeOfInputArea/16*6, sizeOfInputArea, sizeOfInputArea/8);
  fill(255);
  text("suggestion", width/2-sizeOfInputArea/2, height/2+sizeOfInputArea/32*15);
}

void draw_quert() {
  fill(0);
  rect(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2, sizeOfInputArea, sizeOfInputArea);
  
  fill(255,0,0);
  rect(width/2+sizeOfInputArea/6-sizeOfInputArea/3*2, height/2+sizeOfInputArea/6, sizeOfInputArea/3, sizeOfInputArea/3);
  fill(255);
  text("q",width/2+sizeOfInputArea/3-sizeOfInputArea/3*2, height/2+sizeOfInputArea/3);
  
  fill(100);
  rect(width/2+sizeOfInputArea/6-sizeOfInputArea/3, height/2+sizeOfInputArea/6, sizeOfInputArea/3, sizeOfInputArea/3);
  fill(255);
  text("w",width/2+sizeOfInputArea/3-sizeOfInputArea/3, height/2+sizeOfInputArea/3);
  
  fill(255,0,0);
  rect(width/2+sizeOfInputArea/6, height/2+sizeOfInputArea/6, sizeOfInputArea/3, sizeOfInputArea/3);
  fill(255);
  text("e",width/2+sizeOfInputArea/3, height/2+sizeOfInputArea/3);
  
  fill(100);
  rect(width/2+sizeOfInputArea/6, height/2+sizeOfInputArea/6-sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
  fill(255);
  text("r",width/2+sizeOfInputArea/3, height/2+sizeOfInputArea/3-sizeOfInputArea/3);
  
  fill(255,0,0);
  rect(width/2+sizeOfInputArea/6, height/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
  fill(255);
  text("t",width/2+sizeOfInputArea/3, height/2+sizeOfInputArea/3-sizeOfInputArea/3-sizeOfInputArea/3);
}

void draw_zxcv() {
  fill(0);
  rect(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2, sizeOfInputArea, sizeOfInputArea);
  
  fill(255,0,0);
  rect(width/2+sizeOfInputArea/6, height/2+sizeOfInputArea/6, sizeOfInputArea/3, sizeOfInputArea/3);
  fill(255);
  text("v",width/2+sizeOfInputArea/3, height/2+sizeOfInputArea/3);
  
  fill(100);
  rect(width/2+sizeOfInputArea/6, height/2+sizeOfInputArea/6-sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
  fill(255);
  text("c",width/2+sizeOfInputArea/3, height/2+sizeOfInputArea/3-sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
  
  fill(255,0,0);
  rect(width/2+sizeOfInputArea/6-sizeOfInputArea/3, height/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
  fill(255);
  text("x",width/2+sizeOfInputArea/3-sizeOfInputArea/3, height/2+sizeOfInputArea/3-sizeOfInputArea/3-sizeOfInputArea/3);
  
  fill(100);
  rect(width/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3, height/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/3);
  fill(255);
  text("z",width/2+sizeOfInputArea/3-sizeOfInputArea/3-sizeOfInputArea/3, height/2+sizeOfInputArea/3-sizeOfInputArea/3-sizeOfInputArea/3);
}

void draw_hjkl() {
  fill(0);
  rect(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2, sizeOfInputArea, sizeOfInputArea);
  
  fill(255,0,0);
  rect(width/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3,height/2+sizeOfInputArea/6,sizeOfInputArea/3,sizeOfInputArea/3);
  fill(255);
  text("j", width/2+sizeOfInputArea/3-sizeOfInputArea/3-sizeOfInputArea/3, height/2+sizeOfInputArea/3);
  
  fill(100);
  rect(width/2+sizeOfInputArea/6-sizeOfInputArea/3,height/2+sizeOfInputArea/6,sizeOfInputArea/3,sizeOfInputArea/3);
  fill(255);
  text("k", width/2+sizeOfInputArea/3-sizeOfInputArea/3,height/2+sizeOfInputArea/3);
  
  fill(255,0,0);
  rect(width/2+sizeOfInputArea/6,height/2+sizeOfInputArea/6,sizeOfInputArea/3,sizeOfInputArea/3);
  fill(255);
  text("l", width/2+sizeOfInputArea/3,height/2+sizeOfInputArea/3);
  
  fill(255,0,0);
  rect(width/2+sizeOfInputArea/6-sizeOfInputArea/3,height/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3,sizeOfInputArea/3,sizeOfInputArea/3);
  fill(255);
  text("h",width/2+sizeOfInputArea/3-sizeOfInputArea/3,height/2+sizeOfInputArea/3-sizeOfInputArea/3-sizeOfInputArea/3);
}

void draw_yuiop() {
  fill(0);
  rect(width/2-sizeOfInputArea/2,height/2-sizeOfInputArea/2, sizeOfInputArea, sizeOfInputArea);
  
  fill(255,0,0);
  rect(width/2+sizeOfInputArea/6,height/2+sizeOfInputArea/6,sizeOfInputArea/3,sizeOfInputArea/3);
  fill(255);
  text("p",width/2+sizeOfInputArea/3,height/2+sizeOfInputArea/3);
  
  fill(100);
  rect(width/2+sizeOfInputArea/6-sizeOfInputArea/3,height/2+sizeOfInputArea/6,sizeOfInputArea/3,sizeOfInputArea/3);
  fill(255);
  text("o",width/2+sizeOfInputArea/3-sizeOfInputArea/3,height/2+sizeOfInputArea/3);
  
  fill(255,0,0);
  rect(width/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3,height/2+sizeOfInputArea/6,sizeOfInputArea/3,sizeOfInputArea/3);
  fill(255);
  text("i",width/2+sizeOfInputArea/3-sizeOfInputArea/3-sizeOfInputArea/3,height/2+sizeOfInputArea/3);
  
  fill(100);
  rect(width/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3,height/2+sizeOfInputArea/6-sizeOfInputArea/3,sizeOfInputArea/3,sizeOfInputArea/3);
  fill(255);
  text("u",width/2+sizeOfInputArea/3-sizeOfInputArea/3-sizeOfInputArea/3,height/2+sizeOfInputArea/3-sizeOfInputArea/3);
  
  fill(255,0,0);
  rect(width/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3,height/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3,sizeOfInputArea/3,sizeOfInputArea/3);
  fill(255);
  text("y",width/2+sizeOfInputArea/3-sizeOfInputArea/3-sizeOfInputArea/3,height/2+sizeOfInputArea/3-sizeOfInputArea/3-sizeOfInputArea/3);
}

void draw_asdfg() {
  fill(0);
  rect(width/2-sizeOfInputArea/2,height/2-sizeOfInputArea/2, sizeOfInputArea, sizeOfInputArea);
  
  fill(100);
  rect(width/2+sizeOfInputArea/6-sizeOfInputArea/3,height/2+sizeOfInputArea/6,sizeOfInputArea/3,sizeOfInputArea/3);
  fill(255);
  text("g",width/2+sizeOfInputArea/3-sizeOfInputArea/3,height/2+sizeOfInputArea/3);
  
  fill(255,0,0);
  rect(width/2+sizeOfInputArea/6,height/2+sizeOfInputArea/6,sizeOfInputArea/3,sizeOfInputArea/3);
  fill(255);
  text("f",width/2+sizeOfInputArea/3,height/2+sizeOfInputArea/3);
  
  fill(100);
  rect(width/2+sizeOfInputArea/6,height/2+sizeOfInputArea/6-sizeOfInputArea/3,sizeOfInputArea/3,sizeOfInputArea/3);
  fill(255);
  text("d",width/2+sizeOfInputArea/3,height/2+sizeOfInputArea/3-sizeOfInputArea/3);
  
  fill(255,0,0);
  rect(width/2+sizeOfInputArea/6,height/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3,sizeOfInputArea/3,sizeOfInputArea/3);
  fill(255);
  text("s",width/2+sizeOfInputArea/3,height/2+sizeOfInputArea/3-sizeOfInputArea/3-sizeOfInputArea/3);
  
  fill(100);
  rect(width/2+sizeOfInputArea/6-sizeOfInputArea/3,height/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3,sizeOfInputArea/3,sizeOfInputArea/3);
  fill(255);
  text("a",width/2+sizeOfInputArea/3-sizeOfInputArea/3,height/2+sizeOfInputArea/3-sizeOfInputArea/3-sizeOfInputArea/3);
}

void draw_bnm() {
  fill(0);
  rect(width/2-sizeOfInputArea/2,height/2-sizeOfInputArea/2, sizeOfInputArea, sizeOfInputArea);
  
  fill(255,0,0);
  rect(width/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3,height/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3,sizeOfInputArea/3,sizeOfInputArea/3);
  fill(255);
  text("b",width/2+sizeOfInputArea/3-sizeOfInputArea/3-sizeOfInputArea/3,height/2+sizeOfInputArea/3-sizeOfInputArea/3-sizeOfInputArea/3);
  
  fill(100);
  rect(width/2+sizeOfInputArea/6-sizeOfInputArea/3,height/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3,sizeOfInputArea/3,sizeOfInputArea/3);
  fill(255);
  text("n",width/2+sizeOfInputArea/3-sizeOfInputArea/3,height/2+sizeOfInputArea/3-sizeOfInputArea/3-sizeOfInputArea/3);
  
  fill(255,0,0);
  rect(width/2+sizeOfInputArea/6,height/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3,sizeOfInputArea/3,sizeOfInputArea/3);
  fill(255);
  text("m",width/2+sizeOfInputArea/3,height/2+sizeOfInputArea/3-sizeOfInputArea/3-sizeOfInputArea/3);
  
  fill(255,0,0);
  rect(width/2+sizeOfInputArea/6-sizeOfInputArea/3-sizeOfInputArea/3,height/2-sizeOfInputArea/6+sizeOfInputArea/3,sizeOfInputArea/3*2,sizeOfInputArea/3);
  fill(255);
  text("space",width/2+sizeOfInputArea/3-sizeOfInputArea/3-sizeOfInputArea/3,height/2+sizeOfInputArea/3);
}