/*
 * pixhawk_interface.h
 *
 *  Created on: 20 Feb 2016
 *      Author: rbot
 */

#ifndef PIXHAWK_INTERFACE_H_
#define PIXHAWK_INTERFACE_H_

#include "c_library/pixhawk/mavlink.h"
#include "serial_port.h"
#include <time.h>
#include <sys/time.h>

#define COMMAND_ACK 77

typedef struct ID{
	int sysid;
	int compid;

}ID;

//helper functions
unsigned int millis();
void delay(unsigned int howLong);

//threads
void* start_PI_read_thread(void* args);
void* start_PI_heartbeat_thread(void* args);


//--------------------------------------------------
//            Pixhawk Interface Class
//--------------------------------------------------
class Pixhawk_Interface
{

public:
	//general function


	//Pichawk_Interface class
	Pixhawk_Interface();
	Pixhawk_Interface(Serial_Port *serial_port_, int sys_id, int comp_id);
	~Pixhawk_Interface();

	ID id;


	void read_msg();
	void send_heartbeat(mavlink_message_t msg);
	void write_RC_command(mavlink_message_t msg, int roll, int yaw);
	void arm_quad(mavlink_message_t msg, int arm);
	void read_RC_raw(mavlink_message_t);


	void start();
	void read_thread();
	void heartbeat_thread();

private:

	Serial_Port *serial_port;

	pthread_t read_tid;
	pthread_t heartbeat_tid;



};

#endif /* PIXHAWK_INTERFACE_H_ */
