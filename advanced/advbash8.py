#!/usr/bin/python

import sys
count=len(sys.argv)
name=''
if (count == 1):
  name=raw_input("enter a file name: ")
else:
  name=sys.argv[1]

log=open("/tmp/files","a")
log.write("the file" + name + "has been written")
log.close()


