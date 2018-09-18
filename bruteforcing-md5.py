#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# just brute-forcing md5 
#
# usage: python3 bruteforcing-md5.y <hash>

__author__ = "@jartigag"
__version__ = "0.1"

import hashlib
import string

# just getting nicer:
import argparse
import signal
import sys

def md5(var):
	return hashlib.md5(var.encode('utf-8')).hexdigest()

def force(hash):
	x = 'aB0'
	characters = string.digits+string.ascii_letters

	for length in range(1,7):
		for char in characters:

			#WIP
			
			x = char
			flag = 'flag{{{}}}'.format(x)

			if md5(flag)==hash:
				print('found! the flag is',flag)

# just getting nicer:
def sigint_handler(signal, frame):
	print("bye!")
	sys.exit(0)

if __name__ == '__main__':

	# just getting nicer:
	signal.signal(signal.SIGINT, sigint_handler)

	parser = argparse.ArgumentParser(description="just brute-forcing md5,\
	 v%s by @jartigag" % __version__)
	parser.add_argument('hash')
	args = parser.parse_args()

	force(args.hash)
