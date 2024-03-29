
#include "common.h"

void out8(uint16 port, uint8 value)
{
    asm volatile("outb %1, %0" : : "dN" (port), "a" (value));
}

uint8 in8(uint16 port)
{
    uint8 ret;
    asm volatile("inb %1, %0" : "=a" (ret) : "dN" (port));
    return ret;
}

uint16 in16(uint16 port)
{
    uint16 ret;
    asm volatile ("inw %1, %0" : "=a" (ret) : "dN" (port));
    return ret;
}
