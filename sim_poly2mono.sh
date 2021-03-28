#!/bin/sh

iverilog -g2012 poly2mono_testbench.sv poly2mono.sv ptcam.sv && vvp a.out
