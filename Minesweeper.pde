import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private static final int NUM_ROWS = 20;
private static final int NUM_COLS = 20;
private static final int NUM_MINES = 40;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined


void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }


  setMines();
}
public void setMines()
{
  //your code
  while (mines.size() < NUM_MINES) {
    int row = (int)(Math.random() * NUM_ROWS);
    int col = (int)(Math.random() * NUM_COLS);
    if (!mines.contains(buttons[row][col])) {
      mines.add(buttons[row][col]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  //your code here
  int count = 0;
  for (int i = 0; i < NUM_MINES; i++) {
    if (mines.get(i).flagged == true) {
      count++;
    }
  }
  if (count == NUM_MINES) {
    return true;
  }
  return false;
}
public void displayLosingMessage()
{
  //your code here
  for (int i = 0; i < NUM_MINES; i++) {
    mines.get(i).clicked = true;
  }
  buttons[NUM_ROWS/2][(NUM_COLS/2)-4].setLabel("Y");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-3].setLabel("O");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-2].setLabel("U");
  buttons[NUM_ROWS/2][(NUM_COLS/2)].setLabel("L");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+1].setLabel("O");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+2].setLabel("S");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+3].setLabel("E");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+4].setLabel("!");
}
public void displayWinningMessage()
{
  //your code here
  buttons[NUM_ROWS/2][(NUM_COLS/2)-4].setLabel("Y");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-3].setLabel("O");
  buttons[NUM_ROWS/2][(NUM_COLS/2)-2].setLabel("U");
  buttons[NUM_ROWS/2][(NUM_COLS/2)].setLabel("W");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+1].setLabel("I");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+2].setLabel("N");
  buttons[NUM_ROWS/2][(NUM_COLS/2)+3].setLabel("!");
}
public boolean isValid(int r, int c)
{
  //your code here
  if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS) {
    return true;
  } else return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  //your code here
  for (int r = row - 1; r <= row + 1; r++) {
    for (int c = col - 1; c <= col + 1; c++) {
      if (isValid(r, c) == true && mines.contains(buttons[r][c])) {
        numMines++;
      }
    }
  }
  if (mines.contains(buttons[row][col])) {
    numMines--;
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    //your code here
    if (mouseButton == RIGHT) {
      flagged = !flagged;
      if (flagged == false) {
        clicked = false;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      myLabel = "" + countMines(myRow, myCol);
    } else {
      if (isValid(myRow-1, myCol-1) && buttons[myRow-1][myCol-1].clicked == false) {
        buttons[myRow-1][myCol-1].mousePressed();
      }
      if (isValid(myRow-1, myCol) && buttons[myRow-1][myCol].clicked == false) {
        buttons[myRow-1][myCol].mousePressed();
      }
      if (isValid(myRow-1, myCol+1) && buttons[myRow-1][myCol+1].clicked == false) {
        buttons[myRow-1][myCol+1].mousePressed();
      }
      if (isValid(myRow, myCol-1) && buttons[myRow][myCol-1].clicked == false) {
        buttons[myRow][myCol-1].mousePressed();
      }
      if (isValid(myRow, myCol+1) && buttons[myRow][myCol+1].clicked == false) {
        buttons[myRow][myCol+1].mousePressed();
      }
      if (isValid(myRow+1, myCol-1) && buttons[myRow+1][myCol-1].clicked == false) {
        buttons[myRow+1][myCol-1].mousePressed();
      }
      if (isValid(myRow+1, myCol) && buttons[myRow+1][myCol].clicked == false) {
        buttons[myRow+1][myCol].mousePressed();
      }
      if (isValid(myRow+1, myCol+1) && buttons[myRow+1][myCol+1].clicked == false) {
        buttons[myRow+1][myCol+1].mousePressed();
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = "" + newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
