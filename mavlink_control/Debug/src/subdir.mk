################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/autopilot_interface.cpp \
../src/mavlink_ctrl.cpp \
../src/pixhawk_interface.cpp \
../src/serial_port.cpp 

OBJS += \
./src/autopilot_interface.o \
./src/mavlink_ctrl.o \
./src/pixhawk_interface.o \
./src/serial_port.o 

CPP_DEPS += \
./src/autopilot_interface.d \
./src/mavlink_ctrl.d \
./src/pixhawk_interface.d \
./src/serial_port.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: Cross G++ Compiler'
	g++ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


