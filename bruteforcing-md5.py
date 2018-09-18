#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# just brute-forcing md5 
#
# usage: python3 bruteforcing-md5.y <hash>

#FIXME: not all combinations are generated
#("found! the flag is flag{a99}", but flag{aa9} isn't found)

__author__ = "@jartigag"
__version__ = "0.1"

import hashlib
import string

#EXTRA just getting nicer:
import argparse
import signal
import sys

def md5(var):
	return hashlib.md5(var.encode('utf-8')).hexdigest()

def check(var,hash):
	flag = 'flag{{{}}}'.format(''.join(var))
							# ''.join(var) to get it as string
	#print(flag)#DEBUGGING
	if md5(flag)==hash:
		print('found! the flag is',flag)
		bye(0,0)

def force(hash):
	x = ['a'] # treated as a list
	characters = string.ascii_letters+string.digits

	maxChars = 7
	for length in range(1,maxChars+1):
		for char in characters:
			#initial value:
			x = [char]*length # x = [a],[b],...,[a,a],[b,b],...
			check(x,hash)
			#TODO: (a,aa,aaa,... will be checked twice)
			for currentPos in range(0,length-1):
				for char in characters:
					x[currentPos] = char
					check(x,hash)
					# aa,ba,...,9a,9a,9b,...,99,ab,bb,cb,

#EXTRA just getting nicer:
def bye(signal, frame):
	#this function is a handler for SIGINT
	print("bye!")
	sys.exit(0)

if __name__ == '__main__':

	#EXTRA just getting nicer:
	signal.signal(signal.SIGINT, bye)

	parser = argparse.ArgumentParser(description="just brute-forcing md5,\
	 v%s by @jartigag" % __version__)
	parser.add_argument('hash')
	args = parser.parse_args()

	force(args.hash)
