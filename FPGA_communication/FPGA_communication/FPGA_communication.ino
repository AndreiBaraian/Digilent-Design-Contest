/*
 Name:		FPGA_communication.ino
 Created:	5/2/2017 7:22:44 PM
 Author:	bara_
*/

// the setup function runs once when you press reset or power the board
void setup() {
	Serial.begin(9600);
	pinMode(5, INPUT);

}

// the loop function runs over and over again until power down or reset
void loop() {
  
	if (digitalRead(5) == HIGH)
		Serial.println("SIGNAL IS HIGH!");
	else
		Serial.println("low");

}
