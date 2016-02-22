/*
 * pixhawk_interface.cpp
 *
 *  Created on: 20 Feb 2016
 *      Author: Calvin Vong
 */

#include "pixhawk_interface.h"

//general function
void delay(unsigned int howLong)
{
	struct timespec sleeper, dummy ;

	sleeper.tv_sec  = (time_t)(howLong / 1000) ;
	sleeper.tv_nsec = (long)(howLong % 1000) * 1000000 ;

	nanosleep (&sleeper, &dummy) ;
}//end delay

unsigned int millis()
{
	struct timeval tv;
	uint64_t now;


	gettimeofday (&tv, NULL) ;
	now  = (uint64_t)tv.tv_sec * (uint64_t)1000 + (uint64_t)(tv.tv_usec / 1000) ;

	return (uint32_t) now ;
}




//---------------------------------------------------------------------
//				Pixhawk Interface Class
//---------------------------------------------------------------------
Pixhawk_Interface::
Pixhawk_Interface(){}

Pixhawk_Interface::
Pixhawk_Interface(Serial_Port *serial_port_, int sys_id, int comp_id)
{
	id.sysid = sys_id;
	id.compid = comp_id;

	serial_port = serial_port_;
}

Pixhawk_Interface::
~Pixhawk_Interface()
{}




void Pixhawk_Interface::
read_msg()
{
	bool success;
	//printf("come first\n");
	mavlink_message_t msg;
	success = serial_port->read_message(msg);
	//printf("come here\n");
	if (success)
	{

		switch (msg.msgid)
		{
			case MAVLINK_MSG_ID_HEARTBEAT:
			{
				if (msg.sysid == 1)
				{
					static int count = 0;

					//send back an heartbeat
					//mavlink_message_t msg_heartbeat;
					//send_heartbeat(msg_heartbeat);

					//print out
					printf("<3 beat %d, sys_ID: %d\n", count, msg.sysid);
					count++;
				}
				break;
			}

			case MAVLINK_MSG_ID_SYS_STATUS:
			{
				mavlink_sys_status_t sys_status;
				mavlink_msg_sys_status_decode(&msg, &sys_status);

				//print

				break;
			}

			case COMMAND_ACK:	//COMMAND_ACK #77
			{
				mavlink_command_ack_t ack;
				mavlink_msg_command_ack_decode(&msg, &ack);

				//print out
				printf("Received command: %d, result: %d\n", ack.command, ack.result);

				break;
			}

			case MAVLINK_MSG_ID_PARAM_REQUEST_LIST:
			{
				//dont need to do anything
				break;
			}

			case MAVLINK_MSG_ID_RC_CHANNELS_RAW:
			{
				mavlink_rc_channels_raw_t rc_raw;
				mavlink_msg_rc_channels_raw_decode(&msg, &rc_raw);

				printf("rc1 %d, rc2 %d, rc3 %d, rc4 %d\n", rc_raw.chan1_raw,rc_raw.chan2_raw,rc_raw.chan3_raw,rc_raw.chan4_raw);

				break;
			}

			case MAVLINK_MSG_ID_SERVO_OUTPUT_RAW:	//#36 from data stream RC_CHANNELS
			{

				break;
			}

			default:
			{
				/*
				 * 125: POWER_STATUS
				 * 253: STATUTEXT
				 */

				//print
				//printf("Other messages - msg ID: %d\n", msg.msgid);
				break;
			}
		}

	}

}// end read_msg


// ----------------------------------------------------------------------------
//	Sending some heartbeat
// ----------------------------------------------------------------------------
void Pixhawk_Interface::
send_heartbeat(mavlink_message_t msg)
{
	mavlink_msg_heartbeat_pack(id.sysid, id.compid, &msg, MAV_TYPE_GCS, MAV_AUTOPILOT_INVALID,0, 0, 0);

	serial_port->write_message(msg);

}


// ----------------------------------------------------------------------------
//	Overwriting the RC channels
// ----------------------------------------------------------------------------
void Pixhawk_Interface::
write_RC_command(mavlink_message_t msg, int roll, int yaw)
{


	// MSG: #70 RC_CHANNELS_OVERRIDE
	//									                       target ID       pitch  throttle      ch5  6  7  8
	mavlink_msg_rc_channels_override_pack(id.sysid, id.compid, &msg,   1, 1,    roll,  0,       0,    yaw,  0, 0, 0, 0);

	serial_port->write_message(msg);

	//debug print
	//printf("RC override sys ID %d, comp ID %d\n", id.sysid, id.compid);

}// end write RC command



// ----------------------------------------------------------------------------
//	Arming the quad
// ----------------------------------------------------------------------------
void Pixhawk_Interface::
arm_quad(mavlink_message_t msg, int arm)
{
	// MAV_CMD: #400 ARM/DISARM
	//													     target ID                                ARM_CMD  unused param
	mavlink_msg_command_long_pack(id.sysid, id.compid, &msg,   1, 1,    MAV_CMD_COMPONENT_ARM_DISARM,   arm,   1,1,1,1,1,1,1);


	serial_port->write_message(msg);

	printf("ARM sys ID %d, comp ID %d\n", id.sysid, id.compid);

}// end arm quad


void Pixhawk_Interface::
read_RC_raw(mavlink_message_t msg)
{
	mavlink_msg_request_data_stream_pack(id.sysid, id.compid, &msg, 1, 1, MAV_DATA_STREAM_RC_CHANNELS, 10, 1);
	serial_port->write_message(msg);

}


void Pixhawk_Interface::
start()
{
	//creating threads
	if ( pthread_create(&read_tid,NULL, &start_PI_read_thread, this) )
		printf("Error creating read thread!!\n");

	if ( pthread_create(&heartbeat_tid,NULL, &start_PI_heartbeat_thread, this) )
		printf("Error creating <3 beat thread!!\n");

	printf("hi\n");
}

void Pixhawk_Interface::
read_thread()
{
	int time = 0;

	while (1)
	{

		read_msg();

		printf("read msg time: %d ms\n", millis()-time);
		time = millis();
		//printf("hi\n");
		delay(500);

	}
}

void Pixhawk_Interface::
heartbeat_thread()
{
	printf("hi134\n");
	int time = 0;
	while (1)
	{
		printf("h21afsfsi\n");
		mavlink_message_t msg;
		send_heartbeat(msg);

		printf("<3 time: %d ms\n", millis()-time);
		time = millis();
		delay(1000);
	}
}

//------------------------------------------
//              THREAD
//------------------------------------------
void* start_PI_read_thread(void* args)
{

	Pixhawk_Interface* pilot = (Pixhawk_Interface*) args;

	pilot->read_thread();

	return NULL;
}

void* start_PI_heartbeat_thread(void* args)
{
	Pixhawk_Interface* pilot = (Pixhawk_Interface*) args;

	pilot->read_thread();

	return NULL;
}

