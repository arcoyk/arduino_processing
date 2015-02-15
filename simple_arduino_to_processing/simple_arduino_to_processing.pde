import processing.serial.*;
Serial port;

void setup() {
  String target_port = Serial.list()[4];
  println(Serial.list());
  port = new Serial(this, target_port, 19200);
}

void draw() {
}

float val = 0;
void serialEvent(Serial p) {
  println(port.read());
}

/* Arduino
void setup() {
  analogReference(DEFAULT);
  Serial.begin(19200);
}

void loop() {
  Serial.write(analogRead(0));
}
*/
