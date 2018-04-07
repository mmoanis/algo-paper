#!/usr/bin/env python

import argparse

def main(args):
    with open(args.input_file,'r') as inFile:
        with open(args.output_file, 'w') as outFile:
            lines = inFile.readlines()
            outFile.write("loc = [\n")
            for line in lines:
                tokens = line.split()
                if len(tokens) != 2:
                    raise "Exit"
                string = '\t' + tokens[0] + ', ' + tokens[1] + ';\n'
                outFile.write(string)
            outFile.write("];\n")



if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("input_file")
    parser.add_argument("output_file")
    args = parser.parse_args()
    main(args)
