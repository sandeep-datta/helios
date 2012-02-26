import subprocess
import re
import shutil
import os
from os.path import join
from pprint import pprint


dirStack = []

def pushd(path):
    curDir = os.getcwd()
    os.chdir(os.path.abspath(path))
    #print "PUSHD=", os.getcwd()
    dirStack.append(os.path.abspath(curDir)) #it is safe to push the old value to the stack since chdir was successful
    
def popd():
    os.chdir(dirStack[-1])
    #print "POPD=", os.getcwd()
    dirStack.pop() #it is safe to pop since chdir and access to last element in the stack was successful

def run(*cmd):
    """
    run("Command line", args)
    returns the stdout+stderr streams one line at a time
    """
    l=[]
    for i, x in enumerate(cmd):
        if i == 0:
            l.extend(str(x).split())
        else:
            l.append(x)
    
    #print "l:", l
    return subprocess.Popen(l, stdout=subprocess.PIPE, stderr=subprocess.STDOUT).communicate()[0].split("\n")