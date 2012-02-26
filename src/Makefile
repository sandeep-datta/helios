# Makefile for JamesM's kernel tutorials.
# The C and C++ rules are already setup by default.
# The only one that needs changing is the assembler 
# rule, as we use nasm instead of GNU as.

OUT_DIR=../out
SRC_DIR=.

#List of all object files required to generate the kernel image
#_OBJS=boot.o main.o monitor.o kernelMain.o common.o console.o
_OBJS=boot.o main.o monitor.o kernelMain.o common.o _Dmodule_ref.o

#rewrite the object list so that OUT_DIR is prepended to each obj file name
OBJS=$(patsubst %,$(OUT_DIR)/%,$(_OBJS))

#-nostdinc - Do not search the standard system directories for header.
# Only the directories you have specified with -I options (and the 
# directory of the current file, if appropriate) are searched.


CFLAGS=-m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector -c -g
CXXFLAGS=$(CFLAGS) -fno-rtti -fno-exceptions

LDFLAGS=-melf_i386 --oformat=elf32-i386 -Tkernel.ld -L../lib -L../lib/newlib/lib
#LIBS=-lkruntime -lc -lm

#LIBS=-lkruntime

ASFLAGS=-felf
#DFLAGS=-m32 -noboundscheck -nofloat -c
DFLAGS=-m32 -c -g

#OUT_DIR must be present first, required object files should be generated next. 
#Lastly all obj files should be linked together
all: $(OUT_DIR)/ $(OBJS) link 

clean:
	-rm $(OUT_DIR)/*.o $(OUT_DIR)/kernel

#ld $(LDFLAGS) -o $(OUT_DIR)/kernel $(OBJS) ../tools/lib/kruntime/lib/libdruntime.a ../tools/lib/newlib/lib/32/libc.a ../tools/lib/newlib/lib/32/libm.a
link:
	ld $(LDFLAGS) -o $(OUT_DIR)/kernel $(OBJS) $(LIBS)

#Make OUT_DIR if it does not exist already
#note the / at the end of the following prerequisite
$(OUT_DIR)/:
	mkdir -p $(OUT_DIR)

#NOTE: $@ is the object file which must be generated from the $< source file

#make .o files from .c files
$(OUT_DIR)/%.o: $(SRC_DIR)/%.c
	gcc -o $@ $< $(CFLAGS) 

#make .o files from .nasm files
$(OUT_DIR)/%.o: $(SRC_DIR)/%.nasm
	nasm -o $@ $< $(ASFLAGS)

#make .o files from .d files
$(OUT_DIR)/%.o: $(SRC_DIR)/%.d
	dmd -od$(OUT_DIR) $< $(DFLAGS)
