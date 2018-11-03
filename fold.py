#!/usr/bin/env python3

import argparse
import sys
import itertools

parser = argparse.ArgumentParser(description='Fold input data to intervals of the given width')
parser.add_argument(
    '--width',
    default = 300,
    type = int,
    help = 'width (in seconds) of the time intervals to fold data into'
)
parser.add_argument(
    '--foldtype',
    default = 'sum',
    choices = ['sum', 'max'],
    help='how to fold'
)

args = parser.parse_args(sys.argv[1:])

class Max:
    def __init__(self):
        self.default = -sys.maxsize + 1
        self._max = self.default

    def value(self, val):
        if self._max < val:
            self._max = val

    def flush(self):
        result = self._max
        self._max = self.default
        return result

class Sum:
    def __init__(self):
        self.default = 0.
        self._sum = self.default

    def value(self, val):
        self._sum += val

    def flush(self):
        result = self._sum
        self._sum = self.default
        return result

folder = Sum() if args.foldtype == 'sum' else Max()
first_line = sys.stdin.readline()
interval_start = float(first_line.split()[0])

for line in itertools.chain([first_line], sys.stdin):
    time, val = line.split()
    time, val = float(time), float(val)
    while time - interval_start >= args.width:
        print('%f %f' % (interval_start, folder.flush()))
        interval_start += args.width
    folder.value(val)
