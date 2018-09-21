#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# just brute-forcing md5 
#
# usage: python3 bruteforcing-md5.py <hash>
#
# testing: echo -n "flag{xx}" | md5sum | xargs -tn 1 python3 bruteforcing-md5.py

__author__ = "@jartigag"
__version__ = "0.1"

import hashlib
import argparse
import signal #EXTRA(just better looking)
import sys #EXTRA(just better looking)

def increment(var):
	# this script was really helpful: https://gist.github.com/pazdera/1121315
	if len(var) <= 0: # increment(var[1:]) -> if len(var[1:]) <= 0
	#                                         (eventually it's -1)
		var.append(chars[0])
	else:
		var[0] = chars[(chars.index(var[0]) + 1) % len(chars)]
		if chars.index(var[0]) is 0:
			return list(var[0]) + increment(var[1:])
	return var

def md5(var):
	return hashlib.md5(var.encode('utf-8')).hexdigest()

def check(var,hash,verbose,reallyVerbose,reverse):
	flag = 'flag{{{}}}'.format(''.join(var)) # ''.join(var) to get it as string
	if reverse:
		flag = 'flag{{{}}}'.format(''.join(reversed(var)))
	if reallyVerbose:
		print(flag)
	elif verbose and ''.join(var)==len(var)*'a': # flag{a},flag{aa},flag{aaa},..
		print(flag)
	if md5(flag)==hash:
		print('found! the flag is',flag)
		bye(0,0)
	else:
		return True

def bye(signal, frame):	#this function is a handler for SIGINT
	print("\nbye!")
	sys.exit(0)

if __name__ == '__main__':

	signal.signal(signal.SIGINT, bye) #EXTRA(just better looking)

	parser = argparse.ArgumentParser(
		description="just brute-forcing md5 hashes\n\
from 'flag{xxxxxxx}' strings, by %s" % __author__,
		formatter_class=argparse.RawTextHelpFormatter)
	parser.add_argument('hash')
	parser.add_argument('-m','--minFlagChars',type=int,default=1)
	parser.add_argument('-M','--maxFlagChars',type=int,default=7)
	parser.add_argument('-r','--reversed',action='store_true')
	parser.add_argument('-v','--verbose',action='store_true')
	parser.add_argument('-V','--reallyVerbose',action='store_true')
	args = parser.parse_args()

	chars = [chr(i) for i in range(ord('0'),ord('z')+1)]

	# validate user input:
	try:
		int(args.hash,16)
	except:
		print('please enter a valid hash (32 hex digits)')
		sys.exit(0)
	if len(args.hash)!=32:
		print('please enter a valid hash (32 hex digits)')
		sys.exit(0)

	# initiate the flag variable:
	x = []
	if args.minFlagChars>1:
		x=['a']*args.minFlagChars
		check(x,args.hash,args.verbose,args.reallyVerbose,args.reversed)

	# the real job:
	while len(x)<=args.maxFlagChars:
		x = increment(x)
		check(x,args.hash,args.verbose,args.reallyVerbose,args.reversed)
	print('tried until {} chars and finished without success..'\
		.format(args.maxFlagChars))
