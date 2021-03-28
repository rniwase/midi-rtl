#!/bin/sh

iverilog -g2012 top_testbench.sv uart_tx.sv top.sv midi_parser.sv uart_rx.sv ptcam.sv dsm.sv poly2mono.sv && vvp a.out

