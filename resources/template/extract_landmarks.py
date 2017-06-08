#!/usr/bin/env python

import argparse
import os

# parse command line arguments
parser = argparse.ArgumentParser()
parser.add_argument('--input', required=True, help='input template blend file')
parser.add_argument('--output', required=True, help='output json file containing landmarks')
args = parser.parse_args()

# set environment variables
os.putenv('input_file', args.input)
os.putenv('output_file', args.output)

# start blender and process core script
path = os.path.dirname(os.path.realpath(__file__))
os.system('blender -b --python %s/extract_landmarks/core.py' % path)
