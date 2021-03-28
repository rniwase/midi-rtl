#!/bin/sh

iverilog -g2012 uart_tx.sv uart_rx.sv uart_testbench.sv && vvp a.out
