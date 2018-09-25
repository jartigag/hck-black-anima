#!/bin/bash
# -*- coding: utf-8 -*-
# some quick ssh config lines
#
# usage: bash s.sh USER HOST

ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub | ssh $1@$2 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys" 
