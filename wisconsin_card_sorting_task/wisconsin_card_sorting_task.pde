//
//
WisconsinCardSortingTask exptask = new WisconsinCardSortingTask();



void setup(){
  size(400, 400);
  frameRate(1);
  // float[][][] a = generateReferenceCards(3,4,4);
}

void update(){

  // exptask.tick();
}

void draw(){
  // float[][] card = {{0,0,1,0}, {0,0,0,1}, {0,0,0,1}};
  float[][] card = exptask.getNewCard();
  background(51);
  //fill(200);
  //circle(width/2, height/2, 100);
  translate(100,100);
  scale(0.5, 0.5);
  pushMatrix();
    //translate(100, 100);
    //drawShape(0,0);
    //translate(0, 100);
    //drawShape(1,1);
    //translate(0, 100);
    //drawShape(2,2);
    //translate(0, 100);
    //drawShape(3,3);
    drawCard(card);
  popMatrix();
}

void drawCard(float[][] card){
  // number, shape, color
  int num = argmax(card[0]);
  int shape = argmax(card[1]);
  int col = argmax(card[2]);
  for (int i = 1; i <= num+1; ++i) {
    drawShape(shape, col);
    translate(0, 100);
  }

}

void drawShape(int ashape, int acolor){
  color col;
  switch (acolor) {
    case 0:
      col = #ff0000;
      break;
    case 1:
      col = #00ff00;
      break;
    case 2: 
      col = #0000ff;
      break;
    case 3:
    default:
      col = #ff00ff;
    
  }
  fill(col);
  switch (ashape) {
    case 0:
      square(0,0,100);
      break;
    case 1:
      pushMatrix();
      rotate(QUARTER_PI);
      square(0,0,100);
      popMatrix();
      break;
    case 2:
      circle(0,0, 100);
      break;
    case 3:
    default:
      triangle(0, -50, -50, 50, 50, 50);
      break;

  }

}

float[][][] generateReferenceCards(int adims, int afeatures, int atemplates){
        float[][][] retval = new float[atemplates][adims][afeatures];
        for (int i = 0; i < atemplates; ++i) {
            for (int j = 0; j < adims; ++j) {
                retval[i][j][i] = 1.f;
            }
        }
        return retval; 
    }
