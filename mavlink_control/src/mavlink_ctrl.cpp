// Standard include s
#include <iostream>
#include <cstdlib>
#include <unistd.h>
#include <cmath>
#include <string.h>
#include <inttypes.h>
#include <fstream>
// Serial includes
#include <stdio.h>   /* Standard input/output definitions */
#include <string.h>  /* String function definitions */
#include <unistd.h>  /* UNIX standard function definitions */
#include <fcntl.h>   /* File control definitions */
#include <errno.h>   /* Error number definitions */
#include <termios.h> /* POSIX terminal control definitions */
#ifdef __linux
#include <sys/ioctl.h>
#endif

//other includes
#include "c_library/common/mavlink.h"
#include "serial_port.h"
#include "pixhawk_interface.h"

// Latency Benchmarking
#include <sys/time.h>
#include <time.h>


//Raspberry Pi include
#include <pthread.h>	//for eclipse only
//#include <wiringPi.h>	//for Rpi only

using std::string;
using namespace std;

//struct timeval tv;		  ///< System time

//-----------------------------------------------------
//--------------- GLOBAL VARIABLES --------------------
//-----------------------------------------------------

int start_thread = 0;
int roll = 1000;

//-----------------------------------------------------
//------------------- THREAD --------------------------
//-----------------------------------------------------

pthread_t readThread;

void *read_thread(void *args)
{

	while (!start_thread){delay(10);}
	int sys_id = 255;
	int comp_id = 1;
	//Pixhawk_Interface p(serial_port1, sys_id, comp_id);

	Pixhawk_Interface* p = (Pixhawk_Interface*) args;
	while (1)
	{

		if (roll > 2000)	roll = 1000;
		roll++;
		//p->read_msg();

		mavlink_message_t msg;
		p->send_heartbeat(msg);
		printf("what's up\n");
		delay(1000);
	}

}



int main(int argc, char **argv)
{
	//============= device config ================
	char *uart_name = (char*) "/dev/ttyUSB0";
	int baudrate = 57600;
	int sys_id = 255;
	int comp_id = 1;
	//============= device config ================

	printf("starting system\n");

	parse_commandline(argc, argv, uart_name, baudrate);

	//Serial port setup
	Serial_Port serial_port(uart_name, baudrate);

	Pixhawk_Interface pilot(&serial_port, sys_id, comp_id);

	serial_port.start();



	pilot.start();

	//threading stuff
	if(pthread_create(&readThread, NULL, read_thread, &pilot)) {

	fprintf(stderr, "Error creating thread\n");
	return 1;

	}

	mavlink_message_t msg_rc;
	pilot.arm_quad(msg_rc, 1);


	pilot.write_RC_command(msg_rc, roll,1700);


	start_thread = 1;

	while (1)
	{

		//pilot.read_msg();

		mavlink_message_t rc_raw;
		//pilot.read_RC_raw(rc_raw);

		//pilot.write_RC_command(msg_rc, roll,1666);


	}// end while


	//THE END - DO NOT COME HERE
	serial_port.stop();
	return 0;
}//end main




