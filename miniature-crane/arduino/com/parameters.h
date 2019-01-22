#ifndef PARAMETERS_H
#define PARAMETERS_H

#define SERIAL_BAUD 9600  // Baudrate
#define MOTOR_ROT_PIN 3
#define MOTOR_ICA_PIN 4
#define DIRECTION_ROT_PIN 5
#define DIRECTION_ICA_PIN 6
#define ENCODER_ROT_PIN 7
#define ENCODER_ICA_PIN 8
#define INITIAL_ROT_THETA 110  // Initial angle of rotation
#define INITIAL_ICA_THETA 110  // Initial angle of lifting

// Min and max values for motors
#define THETA_MIN 60
#define THETA_MAX 150

// If DEBUG is set to true, the arduino will send back all the received messages
#define DEBUG false

#endif
