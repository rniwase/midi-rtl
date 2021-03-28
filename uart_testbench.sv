`timescale 1 ns / 1 ns

module uart_testbench;

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
  end

  parameter CLK_CYCLE = 20;  // 50MHz

  logic clk, reset_n, tx_valid;
  logic [7:0] tx_d_in;
  logic uart_loop, tx_ready, rx_valid, rx_f_error;
  logic [7:0] rx_d_out;
  logic uart_loop_mask;

  uart_tx uart_tx_i (
    .clk     (clk       ),  // System clock input
    .reset_n (reset_n   ),  // Reset input
    .tx_out  (uart_loop ),  // UART TX output
    .valid   (tx_valid  ),  // Data valid input
    .ready   (tx_ready  ),  // Data ready output
    .d_in    (tx_d_in   )   // Data input
  );

  uart_rx uart_rx_i (
    .clk     (clk       ),  // System clock input
    .reset_n (reset_n   ),  // Reset input
    .rx_in   (uart_loop & uart_loop_mask),  // UART RX input
    .valid   (rx_valid  ),  // Data valid output
    .d_out   (rx_d_out  ),  // Data output
    .f_error (rx_f_error)   // Flaming error output
  );

  initial begin
    clk <= 1'b1;
    forever
      #(CLK_CYCLE/2) clk <= ~clk;
  end

  integer i;
  initial begin
    tx_d_in <= 8'h10;
    tx_valid <= 1'b0;
    uart_loop_mask <= 1'b1;
    reset_n <= 1'b0;
    repeat (3) @(posedge clk);
    reset_n <= 1'b1;
    repeat (3) @(posedge clk);
    tx_valid <= 1'b1;

    for (i=0; i<10; i=i+1) begin
      wait (tx_ready);
      tx_d_in <= 8'h10 + i;
      if (i==9)
        tx_valid <= 1'b0;
      repeat (3) @(posedge clk);
    end

    repeat (100) @(posedge clk);

    $finish;
  end

endmodule
