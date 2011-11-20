# Makefile for JamesM's kernel tutorials.
# The C and C++ rules are already setup by default.
# The only one that needs changing is the assembler 
# rule, as we use nasm instead of GNU as.

SOURCES=boot.o main.o monitor.o kernelMain.o common.o

#-nostdinc - Do not search the standard system directories for header.
# Only the directories you have specified with -I options (and the 
# directory of the current file, if appropriate) are searched.


CFLAGS=-m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector
CXXFLAGS=$(CFLAGS) -fno-rtti -fno-exceptions
#LDFLAGS=-melf_i386 --oformat=elf32-i386 -Tlink.ld ../toolchain/druntime/lib/libdruntime.a
LDFLAGS=-melf_i386 --oformat=elf32-i386 -Tlink.ld
ASFLAGS=-felf
#DFLAGS=-m32 -noboundscheck -nofloat -c
DFLAGS=-m32 -c

all: $(SOURCES) link 

clean:
	-rm *.o kernel

link:
	ld $(LDFLAGS) -o kernel $(SOURCES)

#.d is an unknown suffix add it to the known suffixes list
.SUFFIXES: .d

.s.o:
	nasm $(ASFLAGS) $<

.d.o:
	dmd $(DFLAGS) $<
