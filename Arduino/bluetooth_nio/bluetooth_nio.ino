#include <SoftwareSerial.h>

// Pins an dnenen der Encoder hängt
#define encoderA 6
#define encoderB 7

// Varibalen um Encoder zu interprätieren
int aLastState;

// Nachricht, die gerade Zeichen für Zeichen empfangen wird.
String nachricht = "";

// Parameter, die wir zuletzt vom Programm empfangen haben
String ziegelParameter;



// Benutzer-Eingaben
const int BEFEHL_NAECHSTER_ZIEGEL = 0;
const int BEFEHL_VORHERIGER_ZIEGEL = 1;
const int BEFEHL_FAHRE_AUF_DIE_POS = 2;
const int BEFEHL_FAHRE_ZUM_ZENTRUM = 3;
const int BEFEHL_REFERENZFAHRT = 4;
const int BEFEHL_STOP = 5;
int aktuellerBefehl = -1;

// Was die Maschine gerade tut
const int MASCHINE_STATUS_FAHRE_AUF_DIE_POS = 0;
const int MASCHINE_STATUS_FAHRE_ZUM_ZENTRUM = 1;
const int MASCHINE_STATUS_REFERENZFAHRT = 2;
const int MASCHINE_STATUS_STOP = 3;
int aktuellerMaschineStatus = MASCHINE_STATUS_STOP;



SoftwareSerial bluetooth(10, 11);


void setup() {
  bluetooth.begin(9600);
  Serial.begin(9600);    
  pinMode (encoderA,INPUT);
  pinMode (encoderB,INPUT);

  pinMode(LED_BUILTIN, OUTPUT);

  digitalWrite(LED_BUILTIN, LOW); 
  aLastState = digitalRead(encoderA);   

}

void loop() {
  // kein delay!
  leseBenutzerBefehl();
  fuehreBenutzerBefehlAus();
  empangeZiegelParameter();
}


// Hier interprätieren wir die Nachricht von dem Programm.
// Nachrichtenformat: {T<Schnitttyp G=Grat, K=Kehle>;W<Winkel>;Z<Ziegelnummer>;D<Distanz vom Zentrum in mm>}
// Beispiel: {TG;W23;Z1;D-200}
void empangeZiegelParameter(){
  if (bluetooth.available()) {
    char c = bluetooth.read();

    // Wir schmeissen möglichen Müll vor der Nachicht weg
    if (c == '{'){
      nachricht = "";
    }
    
    // Nachricht ggf. unvollständig => wir verwerfen diese
    // TODO: ggf. Anfrage erneut senden. Aktuell muss der Benutzter erneut anfordern.
    if (c == '}' && !nachricht.startsWith("{")){
      nachricht = "";
      return;
    }
    nachricht += c;

  } 
  else if (nachricht.endsWith("}")){
    // Wir haben die erwartete Nachricht empfangen. Das sind
    // unsere Ziegel-Parameter, die wir angefordert haben.
    ziegelParameter = nachricht;
    nachricht = "";
    digitalWrite(LED_BUILTIN, LOW); 
    Serial.println(ziegelParameter);
  }

}


// Hier interprätieren wir den Encoder:
// Nach rechts gedreht -- wird der nächste Ziegel angefordert
// Nach links gedreht -- wird der vorherige Ziegel angefordert
void  leseBenutzerBefehl(){

  int aState = digitalRead(encoderA); // Reads the "current" state of the encoderA
  // If the previous and the current state of the encoderA are different, that means a Pulse has occured
  if (aState != aLastState){     

    // If the encoderB state is different to the encoderA state, that means the encoder is rotating clockwise
    if (digitalRead(encoderB) != aState) {
        aktuellerBefehl = BEFEHL_NAECHSTER_ZIEGEL;
    } 
    else {
        aktuellerBefehl = BEFEHL_VORHERIGER_ZIEGEL;
    }
  } 
  aLastState = aState; // Updates the previous state of the encoderA with the current state

}

void fuehreBenutzerBefehlAus(){
  switch (aktuellerBefehl) {

  case BEFEHL_NAECHSTER_ZIEGEL:
    send_text("naechster");
    aktuellerBefehl = -1;
    break;

  case BEFEHL_VORHERIGER_ZIEGEL:
    send_text("vorheriger");
    aktuellerBefehl = -1;
    break;
    // weitere Befehle...

  default:
    // unbekannter Befehl oder -1
    break;
  }

}


// sendet Nachricht an das Programm
void send_text(String text){
  bluetooth.print("{");
  bluetooth.print(text);
  bluetooth.println("}");
  digitalWrite(LED_BUILTIN, HIGH);  
}


