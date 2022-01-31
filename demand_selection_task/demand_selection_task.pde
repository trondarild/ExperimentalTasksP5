//
//
DemandSelectionTask dst = new DemandSelectionTask(10, 0.9, 0.1);
float[] card;
int stack;
color orange = #E89F00;
color green = #60E800;
color white = #D6D6D6;
color blue = #8188FF;
color purple = #C681FF;
boolean drawcard = false;

void setup(){
  size(400, 400);
  frameRate(10);
  //card = dst.getNewCard(0);

}

void draw(){
  dst.tick();
  background(51);
  //fill(200);
  //circle(width/2, height/2, 100);
  if(drawcard){
    int transl = stack == 0 ? 100 : 300;
    pushMatrix();
    translate(transl,100);
    scale(5.5);
    drawCard(card);
    popMatrix();
  }
  // draw decks
  int[] rem = dst.getStackRemainingCounts();
  int maxtrials = dst.getTrials();
  pushMatrix();
  translate(100, 300);
  drawStack(orange, rem[0], maxtrials);
  translate(0,80);
  text("b", 0, 0);
  popMatrix();

  pushMatrix();
  translate(300, 300);
  drawStack(green, rem[1], maxtrials);
  translate(0,80);
  text("n", 0, 0);
  popMatrix();
}

void drawStack(color col, float remaining, float max){
  fill(col);
  rectMode(CENTER);
  rect(0, 0, 100, 100 * remaining/max);
}

void drawCard(float[] card){
  int num = argmax(card, 0, 10);
  color col = blue;
  if(card[11] == 1)
    col = purple;
   
  fill(white);
  rectMode(CENTER);
  rect(0,0,20,30);  
  fill(col);
  text(num, -5, 5);
}


void keyPressed() {
  int keyIndex = -1;
  if (key == 'b') {
    stack = 0; // easy
    card = dst.getNewCard(stack);
    drawcard = sumArray(card) > 0;
  } else if (key == 'n') {
    stack = 1; // hard
    card = dst.getNewCard(stack);
    drawcard = sumArray(card) > 0;
  }
  else if (key == 'h' && drawcard) { // yes
    dst.setAnswer(1.0);
    card = zeros(12);
    drawcard = false;
  }
  else if (key == 'g' && drawcard) { // no
    dst.setAnswer(0.0);
    card = zeros(12);
    drawcard = false;
  }
}
