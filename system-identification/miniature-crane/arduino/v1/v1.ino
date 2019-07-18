/*
Programa para controle de rotação do motor
*/



// These constants won't change. They're used to give names to the pins used:
const int analogInPin = A0;  // Analog input pin that the potentiometer is attached to
const int AO9 = 9; // Analog output pin that the LED is attached to
const int AO10 =10;
const int ID2=2;
//Comando interface
bool iEncoder;
int movM1;
int Velocidade;

void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600);
}

void loop() {


 //Velocidade definida para o motor entre 0-255 
//movM1=Serial.read(); 
if (Serial.available() > 0) {
                // read the incoming byte:
                movM1 = Serial.read();
}

if (movM1==50){
  Velocidade=70;
  analogWrite(AO9, Velocidade);
  analogWrite(AO10, 0);
 }

if (movM1==49){
  Velocidade=70;
  analogWrite(AO9, 0);
  analogWrite(AO10, Velocidade);
 }
 
if (movM1==48){
  digitalWrite(AO9,HIGH);
  digitalWrite(AO10,HIGH);

}

iEncoder=digitalRead(ID2) ;


Serial.print(iEncoder);
Serial.print("\n");


 delay(1000);

}
