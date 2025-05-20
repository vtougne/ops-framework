#!/usr/bin/env python

from __future__ import print_function

try:
    input = raw_input  # Python 2
except NameError:
    pass  # Python 3

def greet(name):
    print("Hello, {}!".format(name))

if __name__ == "__main__":
    name = input("Enter your name: ")
    greet(name)
