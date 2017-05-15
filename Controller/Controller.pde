import processing.serial.*;
import java.util.Scanner; 

// ===========================
// Variables
// ===========================
int userOption = 0;

String arduinoPortName = "";
Serial port = null;
CNCTask cncTask;

// CNC listener
CNCListener cncListener = new CNCListener() {
  public void onStop() {
    cncTask = cncTask.getMovePenBackTask();

    if (cncTask == null) {
      displayUserOptionsMenu();
    }
    else {
      cncTask.start();
    }

    // try {
    //   cncTask.start();
    // }
    // catch (Exception e) {
    //   cncTask = null;
    // }
  }

  public void onError(String errorMessage) {
    System.err.println(errorMessage);

    cncTask = cncTask.getMovePenBackTask();

    if (cncTask == null) {
      displayUserOptionsMenu();
    }
    else {
      cncTask.start();
    }
  }
};

void setup() {
  System.out.println("Please enter Arduino port number:");

  // Get port number from user
  Scanner scanner = new Scanner(System.in);
  int portNumber = 5;

  // do {
  //   // Display all ports
  //   for (int i = 0; i < Serial.list().length; ++i) {
  //     System.out.println(i + "." + Serial.list()[i]);
  //   }
    
  //   portNumber = scanner.nextInt();

  // } while (portNumber >= Serial.list().length || portNumber < 0);
  
  arduinoPortName = Serial.list()[portNumber];
  
  System.out.println("Arduino port: " + arduinoPortName  + " is selected!");
  
  // Conenct to port
  port = new Serial(this, Serial.list()[portNumber], 9600);
  port.clear();

  delay(3000);

  scanner.close();
  
  displayUserOptionsMenu();
}

// Application main loop function
void draw() {
  if (cncTask == null) {
    return;
  }

  cncTask.execute();
}

void getUserOption() {
  int userSelectedOption = userOption;
  userOption = 0;

  // Perform user action
  switch (userSelectedOption) {
  case Constants.USER_OPTIONS_FLOW_SOLVER:
    cncTask = new FlowSolvingTask();
    break;

  case Constants.USER_OPTIONS_PAPER_PAINT:
    cncTask = new PaintingTask();
    break;

  case Constants.USER_OPTIONS_PHONE_PAINT:
    break;

  case Constants.USER_OPTIONS_PIANO:
    cncTask = new PianoTask();
    break;

  case Constants.USER_OPTIONS_CALIBRATION:
    cncTask = new CalibrationTask();
    break;

  case Constants.USER_OPTIONS_QUIT_SYSTEM:
    System.out.println("Bye!");
    exit();
  }

  if (cncTask != null) {
    cncTask.setListener(cncListener);
    cncTask.start();
  }
}

// Get user main option input 
void displayUserOptionsMenu () {
  System.out.println("Enter a number: ");
  System.out.println("[" + Constants.USER_OPTIONS_FLOW_SOLVER + "] : Solve flow free game");
  System.out.println("[" + Constants.USER_OPTIONS_PAPER_PAINT + "] : Paint photo on paper");
  System.out.println("[" + Constants.USER_OPTIONS_PHONE_PAINT + "] : Paint photo on tablet");
  System.out.println("[" + Constants.USER_OPTIONS_PIANO + "] : Piano!");
  System.out.println("[" + Constants.USER_OPTIONS_CALIBRATION + "] : Cailbrate!");
  System.out.println("[" + Constants.USER_OPTIONS_QUIT_SYSTEM + "] : Quit the system!");
}

// Catch user input
void keyPressed() {
  if (cncTask == null) {
    userOption = key - '0';
  } else {
    cncTask.setKeyStatus(key, true);

    if (key == 'T' || key == 't') {
      System.out.println("Log :: Terminatting ...  ");

      cncTask.stop();
    }
  }
}

void keyReleased() {
  if (cncTask != null) {
    cncTask.setKeyStatus(key, false);
  }
}