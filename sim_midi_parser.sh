#!/bin/sh

iverilog -g2012 midi_parser_testbench.sv midi_parser.sv && vvp a.out

