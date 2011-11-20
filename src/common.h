//Common.h -- defines typedefs and some global functions.

#ifndef COMMON_H
#define COMMON_H

//integral typedefs
typedef unsigned int uint32;
typedef 		 int int32;
typedef unsigned short uint16;
typedef 		 short int16;
typedef unsigned char uint8;
typedef 		 short int8;

void out8(uint16 port, uint8 value);
uint8 in8(uint16 port);
uint16 in16(uint16 port);

#endif
