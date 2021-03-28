#!/bin/sh

iverilog -g2012 ptcam.sv ptcam_testbench.sv && vvp a.out
