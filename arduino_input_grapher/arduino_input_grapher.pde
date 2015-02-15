import processing.serial.*;
Serial port;
ArrayList<Signal> signals = new ArrayList<Signal>();
int INPUT_NUM = 5;
int W_ZOOM = 5;

void setup() {
  String target_port = Serial.list()[4];
  println(Serial.list());
  port = new Serial(this, target_port, 19200);
  init_signals();
  size(800, 500);
  fill(255);
  stroke(255);
}

void init_signals() {
  for (int i = 0; i < INPUT_NUM; i++) {
    Signal signal = new Signal(i);
    signals.add(signal);
  }
}

void draw() {
}

void show_signals() {
  background(0);
  for (Signal signal : signals) {
    signal.show();
  }
}

void flush_signals() {
  for (Signal signal : signals ) {
    signal.flushup();
  }
}

float val = 0;
int current_analogIn = 0;
void serialEvent(Serial p) {
  int val = port.read();
  Signal s = signals.get(current_analogIn);
  s.add_val(val);
  current_analogIn++;
  if (current_analogIn > INPUT_NUM - 1) {
    current_analogIn = 0;
  }
  println(val);
  show_signals();
}

class Signal {
  Signal(int index_in) {
    index = index_in;
  }
  int index;
  color c = color((int)random(255),
                  (int)random(255),
                  (int)random(255));
  ArrayList<Float> data = new ArrayList<Float>();
  void add_val(float val) {
    data.add(val);
  }
  void show() {
    if (data.size() < 1) {
      return;
    }
    stroke(c);
    for (int i = 0; i < data.size() - 1; i++) {
      float crr = data.get(i);
      float next = data.get(i+1);
      line(i * W_ZOOM, height - crr, (i+1) * W_ZOOM, height - next);
    }
    Float last = data.get(data.size() - 1);
    text(index + " : " + last, data.size() * W_ZOOM, height - last);
    if (data.size() * W_ZOOM > width) {
      flush_signals();
    }
  }
  void flushup() {
    data = new ArrayList<Float>();
  }
}

void keyPressed() {
  if (key == 'a') {
    flush_signals();
  }
}

/* Arduino
void setup() {
  analogReference(DEFAULT);
  Serial.begin(19200);
}

void loop() {
  Serial.write(10);
  Serial.write(20);
  Serial.write(30);
  Serial.write(40);
  Serial.write(50);
  delay(1000);
}
*/
