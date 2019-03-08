#include <SoftwareSerial.h>

// Pins an dnenen der Encoder hängt
#define encoderA 6
#define encoderB 7

// Varibalen um Encoder zu interprätieren
int aLastState;  
 
 
SoftwareSerial bluetooth(10, 11);


void setup() {
  bluetooth.begin(9600);

  pinMode(LED_BUILTIN, OUTPUT);
  pinMode (encoderA,INPUT);
  pinMode (encoderB,INPUT);
  
  aLastState = digitalRead(encoderA);   

}

void loop() {
  lese_command_vom_arduino_und_sende_es_an_das_programm();
  lese_command_vom_programm_und_fuere_es_aus();
}


// Hier interprätieren wir die Nachricht von dem Programm:
// P200 -- fahre 200mm vom Zentrum nach rechts
// P-200 -- fahre 200mm vom Zentrum nach links
void lese_command_vom_programm_und_fuere_es_aus(){
  if(bluetooth.available()) {
    String command = getCommand();    
    if(command.indexOf("P") == 0){
      fahre(command);
    }
  }  

}


// Hier interprätieren wir den Encoder:
// Nach rechts gedreht -- wird der nächste Ziegel (Distanz) angefordert
// Nach links gedreht -- wird der vorherige Ziegel (Distanz) angefordert
void  lese_command_vom_arduino_und_sende_es_an_das_programm(){
  int aState = digitalRead(encoderA); // Reads the "current" state of the encoderA
  // If the previous and the current state of the encoderA are different, that means a Pulse has occured
  if (aState != aLastState){     

   // If the encoderB state is different to the encoderA state, that means the encoder is rotating clockwise
   if (digitalRead(encoderB) != aState) { 
     naechsterZiegel();
   } else {
     vorherigerZiegel(); 
   }
  } 
  aLastState = aState; // Updates the previous state of the encoderA with the current state
}


// Empfängt Nachricht von dem Programm
String getCommand(){
  String command = "";
  while(bluetooth.available()) {
    char character = bluetooth.read();
    command += character;
    delay(10);
  }
  return command;
}


void fahre(String befehlZumFahren) {
  int distanz = befehlZumFahren.substring(1).toInt();
  for (int i = 0; i < abs(distanz); i++){
    // wir blinken mit dem LED, weil wir keine Maschine hier haben
    digitalWrite(LED_BUILTIN, !digitalRead(LED_BUILTIN));
    delay(10);
  }
  digitalWrite(LED_BUILTIN, LOW);  
}

// fordert Angaben zum nächsten Ziegel von dem Programm an
void naechsterZiegel(){
    send_text("naechster");
}


// fordert Angaben zum vorherigen Ziegel von dem Programm an
void vorherigerZiegel(){
    send_text("vorheriger");
}

// sendet Nachricht an das Programm
void send_text(String text){
   bluetooth.print("{");
   bluetooth.print(text);
   bluetooth.println("}");
}
