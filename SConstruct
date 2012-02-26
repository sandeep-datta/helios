
#NOTE: librt.a is required for clock_getres() and clock_gettime
#TODO: remove references to librt.a and prevent linking to all standard libraries

#CFLAGS=-m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector -c -g
#CXXFLAGS=$(CFLAGS) -fno-rtti -fno-exceptions
#LDFLAGS=-melf_i386 --oformat=elf32-i386 -Tlink.ld -L../lib -L../lib/newlib/lib #Do not force scons to use ld instead of gcc
#LIBS=-lkruntime

import os
from os import path

def SymLink(target, source, env):
    os.symlink(path.abspath(str(source[0])), path.abspath(str(target[0])))
    
#ENVIRONMENT CREATION
#Note: We are simulating a windows environment since replacing the windows functions will be much easier (for me)
env32_ut = Environment(CFLAGS=['-m32', '-nostdlib', '-nostdinc', '-fno-builtin', '-fno-stack-protector', '-g']
                       , CXXFLAGS=['-fno-rtti', '-fno-exceptions']
                       , CPPFLAGS=['-Ilib/krt/libc/include']
                       , DFLAGS=['-m32', '-g', '-release', '-nofloat', '-w', '-d', '-Ilib/kruntime/src', '-Ilib/kruntime/import']
                       , LINKFLAGS=['-m32', '-nostdlib', '-Tsrc/kernel.ld', '-Lout/objs/lib/kruntime', '-Lout/objs/lib/krt'] #-nostdlib will prevent the default crt0 from being linked in
                       , LIBPATH=[''] #This also removes default lib paths set by scons
                       , LIBS = ['kruntime', 'krt']) #This also removes some default libraries (added by scons) from the linker command line

env32_ut.Tool('nasm') #Load the nasm tool to compile .nasm files
env32 = env32_ut.Clone()
env32.AppendUnique(DFLAGS='-inline')

Export("env32 env32_ut")

#TARGETS
sub_projects = [
    "src" ,
    "lib"
]

out = []

for project in sub_projects:
    SConscript(path.join(project, "SConscript")
                , variant_dir=path.join("out/objs", project)
                , duplicate=0)

#Depends("out/kernel", "lib/krt")

#Depends("out/objs/kernel", out)
#Depends("out/kernel", "out/objs/kernel")
#env32.Command("out/kernel", "out/objs/kernel", SymLink)
