#!/usr/bin/python
from sys import argv

script,filename  = argv

print "file:" ,script
print "filename", filename

txt = open(filename)

print txt.read()

target = open(filename,'w')
target.truncate()

print "three line:"
line1 = raw_input("line 1:")
line2 = raw_input("line 2:")
line3 = raw_input("line 3:")

target.write(line1)
target.write('\n')
target.write(line2)
target.write('\n')


target.close()
