#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# just brute-forcing md5 
#
# usage: python3 bruteforcing-md5.py <hash>
#
# testing: echo -n "flag{xx}" | md5sum | xargs -tn 1 python3 bruteforcing-md5.py

#FIXME: not all combinations are generated
#("found! the flag is flag{99a}", but flag{aab} isn't found)

__author__ = "@jartigag"
__version__ = "0.1"

import hashlib
import string
# from time import sleep#DEBUGGING

#EXTRA just getting nicer:
import argparse
import signal
import sys

def md5(var):
	return hashlib.md5(var.encode('utf-8')).hexdigest()

def check(var,hash):
	flag = 'flag{{{}}}'.format(''.join(var))
							# ''.join(var) to get it as string
	# print(flag)#DEBUGGING
	if md5(flag)==hash:
		print('found! the flag is',flag)
		bye(0,0)
	else:
		return True

def force(hash):
	pos=0
	# short=0.001#DEBUGGING
	# long=1#DEBUGGING
	# slower=100#DEBUGGING
	while check(x,hash):
		x[pos] = chars[ (chars.index(x[pos])+1) % len(chars) ]
		if x[pos]=='a': #iterated through all chars in this position
			if len(x)>1:
				x[pos+1] = chars[ (chars.index(x[pos+1])+1) % len(chars) ]
				if x[pos+1]=='a':
					x.append('a')
					# sleep(long)#DEBUGGING
					# short=short*slower#DEBUGGING
			else:
				pos+=1
				x.append('a')
				pos=0
		# sleep(short)#DEBUGGING
	print('finished without success..')

#EXTRA just getting nicer:
def bye(signal, frame):
	#this function is a handler for SIGINT
	print("\nbye!")
	sys.exit(0)

if __name__ == '__main__':

	#EXTRA just getting nicer:
	signal.signal(signal.SIGINT, bye)

	parser = argparse.ArgumentParser(description="just brute-forcing md5,\
	 v%s by @jartigag" % __version__)
	parser.add_argument('hash')
	args = parser.parse_args()

	x = ['a'] # the target string is treated as a list
	chars = string.ascii_letters+string.digits
	maxChars = 7

	for c in args.hash:
		if c not in chars:
			print(c,'is an invalid character')
			bye(0,0)

	force(args.hash)
