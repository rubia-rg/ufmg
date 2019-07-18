#ifndef ORDER_H
#define ORDER_H

// Define the orders that can be sent and received
enum Order {
  HELLO = 0,
  SERVO = 1,
  MOTOR_ROT = 2,
  MOTOR_ICA = 3,
  DIRECTION_ROT = 4,
  DIRECTION_ICA = 5,
  ENCODER_ROT = 6,
  ENCODER_ICA = 7,
  ALREADY_CONNECTED = 8,
  ERROR = 9,
  RECEIVED = 10,
  STOP = 11,
};

typedef enum Order Order;

#endif