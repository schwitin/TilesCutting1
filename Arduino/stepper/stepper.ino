#include <AccelStepper.h>
#include <SoftwareSerial.h>
#include <Encoder.h>

// microstep
// geschwindigkeit um/s
// beschleunigung umdrehungen bis max speed

long letzteEncoderPosition = 0;
long positionMM = 10; //44 schritte pro mm
long schrittePerMM = 18;
float beschleunigung = 500; // шаги в секунду за секуну
float maxGeschwindigkeit = 2000;

long minPosEncoder = 0;
long maxPosEncoder = 0;
long minPosMotor = 0;
long maxPosMotor = 0;
long minPosMM = 0;
long maxPosMM = 0; 


// Nachricht, die gerade Zeichen für Zeichen empfangen wird.
String nachricht = "";

// Parameter, die wir zuletzt vom Programm empfangen haben
//int distanz = 1000;

const byte rxPin = 10;
const byte txPin = 11;
const byte motorEinAusPin = 6;
const byte encoderAPin = 2;
const byte encoderBPin = 4;

SoftwareSerial bluetooth(rxPin, txPin);

// https://www.pjrc.com/teensy/td_libs_Encoder.html
Encoder encoder(encoderAPin, encoderBPin);


// https://www.pjrc.com/teensy/td_libs_AccelStepper.html
// http://www.airspayce.com/mikem/arduino/AccelStepper/classAccelStepper.html#a7468f91a925c689c3ba250f8d074d228ad604e0047f7cb47662c5a1cf6999337c

AccelStepper motor(1, 13, 12); // pin 3 = step, pin 6 = direction

void setup() {
  Serial.begin(9600);
  bluetooth.begin(9600);
  motor.setMaxSpeed(maxGeschwindigkeit);
  motor.setAcceleration(beschleunigung);
  pinMode(motorEinAusPin, OUTPUT);
  encoder.write(0);
  delay(100);
  kalibriere();
}

void loop() {
  motor.run(); 
  empangeDistanz();
  aktualisiereEncoderPosition();
  //motorAusschaltenWennMotorStopped();
}


void kalibriere(){

  Serial.println("Kalibrierung...");
  
  motor.setSpeed(500 * 1);
  while (true) {
    aktualisiereEncoderPosition();
    for(int i = 0; i < 800; i++){
      motor.runSpeed();
    }
    long aktuellePosition = encoder.read();
    if(abs(letzteEncoderPosition - aktuellePosition) == 0){
      Serial.print("letzte:");
      Serial.println(letzteEncoderPosition);
      Serial.print("aktuelle:");
      Serial.println(aktuellePosition);
      Serial.println("----------------");
      motorAusschalten();
      encoder.write(0);
      motor.setCurrentPosition(0);
      break;
    }    
  }

  Serial.println("Ende 1 gefunden");

  motor.setSpeed(500 * -1);
  motorEinschalten();

  for(int i = 0; i < 800; i++){
     motor.runSpeed();
  }
  
  while (true) {
    aktualisiereEncoderPosition();
    for(int i = 0; i < 800; i++){
      motor.runSpeed();
    }
    long aktuellePosition = encoder.read();
    if(abs(letzteEncoderPosition - aktuellePosition) == 0){
      Serial.print("letzte:");
      Serial.println(letzteEncoderPosition);
      Serial.print("aktuelle:");
      Serial.println(aktuellePosition);
      Serial.println("----------------");
      motorAusschalten();      
      break;
    }    
  }

  Serial.println("Ende 2 gefunden");
  
  long aktuelleMotorPos = motor.currentPosition();
  long aktuelleEncoderPos = encoder.read();

  Serial.print("Aktuelle Motor Position: ");
  Serial.println(aktuelleMotorPos);
  Serial.print("Aktuelle Encoder Position: ");
  Serial.println(aktuelleEncoderPos);

  maxPosEncoder = (aktuelleEncoderPos / 2) ;
  maxPosMotor = (aktuelleMotorPos / 2) ;
  maxPosMM = minPosMotor / schrittePerMM - 10;

  minPosEncoder = -minPosEncoder;
  minPosMotor = -minPosMotor;
  minPosMM = -minPosMM;

  motorEinschalten();
  motor.setCurrentPosition(maxPosMotor);
  encoder.write(maxPosEncoder);
  
  motor.moveTo(0);
 
}


void aktualisiereEncoderPosition(){
  letzteEncoderPosition = encoder.read();
}

void empangeDistanz() {
  if (bluetooth.available()) {
    char c = bluetooth.read();

    // Wir schmeissen möglichen Müll vor der Nachicht weg
    if (c == '{') {
      nachricht = "";
    }

    // Nachricht ggf. unvollständig => wir verwerfen diese
    if (c == '}' && !nachricht.startsWith("{")) {
      nachricht = "";
      return;
    }
    nachricht += c;
  }
  else if (nachricht.endsWith("}")) {
    // Wir haben die erwartete Nachricht empfangen. Das ist unsere Distanz.
    nachricht.replace("{", "");
    nachricht.replace("}", "");
    long distanz = nachricht.toInt();
    nachricht = "";
    Serial.println(distanz);
    //motorEinschalten();
    Serial.print("Encoder: ");
    Serial.println(letzteEncoderPosition);
    Serial.print("Schritte:");
    Serial.print(motor.currentPosition());
    motor.moveTo(distanz * schrittePerMM);
  }

  

}

void motorAusschaltenWennMotorStopped(){
  if(false == motor.isRunning()){
      motorAusschalten();
  }
}

void motorEinschalten(){
  digitalWrite(motorEinAusPin, LOW);
  delay(50);
}

void motorAusschalten(){
  digitalWrite(motorEinAusPin, HIGH);  
}
