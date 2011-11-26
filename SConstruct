

#NOTE: librt.a is required for clock_getres() and clock_gettime
#TODO: remove references to librt.a and prevent linking to all standard libraries

#CFLAGS=-m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector -c -g
#CXXFLAGS=$(CFLAGS) -fno-rtti -fno-exceptions
#LDFLAGS=-melf_i386 --oformat=elf32-i386 -Tlink.ld -L../lib -L../lib/newlib/lib #Do not force scons to use ld instead of gcc
#LIBS=-lkruntime

import os

def SymLink(target, source, env):
    os.symlink(str(source[0]), str(target[0]))

env32 = Environment(CFLAGS='-m32', DFLAGS='-m32', LINKFLAGS='-m32', LIBS=['rt'])

#env = Environment(CC="gcc", CFLAGS="-m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector -g", LDFLAGS="-melf_i386 --oformat=elf32-i386")

Export('env32')

sub_projects = {
    "src/SConscript" : "",
}

for project in sub_projects.keys():
    env32.SConscript(project, variant_dir="out/objs" + sub_projects[project], duplicate=0)

env32.Command("out/kernel", "out/objs/kernel", SymLink)
