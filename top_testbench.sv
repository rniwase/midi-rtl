`timescale 1 ns / 1 ns

module top_testbench;

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
  end

  parameter CLK_CYCLE = 20;  // 50MHz

  logic clk, reset_n, midi, note_cv_p, note_cv_n;
  logic tx_valid, tx_ready;
  logic [7:0] tx_d_in;

  uart_tx uart_tx_i (
    .tx_out  (midi      ),
    .valid   (tx_valid  ),
    .ready   (tx_ready  ),
    .d_in    (tx_d_in   ),
    .*
  );

  top top_i (
    .reset_n_in (reset_n),
    .midi_in (midi),
    .*
  );

  initial begin
    clk <= 1'b1;
    forever
      #(CLK_CYCLE/2) clk <= ~clk;
  end

  initial begin
    reset_n <= 1'b0;
    repeat (10) @(posedge clk);
    reset_n <= 1'b1;
  end

  initial begin
    tx_d_in <= 8'h00;
    tx_valid <= 1'b0;

    wait (reset_n);
    repeat (20) @(posedge clk);

    tx_d_in <= 8'h91;
    tx_valid <= 1'b1;
    @(posedge clk);
    tx_valid <= 1'b0;
    @(posedge clk);
    wait (tx_ready);
    repeat (20) @(posedge clk);

    tx_d_in <= 8'h30;
    tx_valid <= 1'b1;
    @(posedge clk);
    tx_valid <= 1'b0;
    @(posedge clk);
    wait (tx_ready);
    repeat (20) @(posedge clk);

    tx_d_in <= 8'h01;
    tx_valid <= 1'b1;
    @(posedge clk);
    tx_valid <= 1'b0;
    @(posedge clk);
    wait (tx_ready);
    repeat (20) @(posedge clk);

    repeat (10000) @(posedge clk);

    tx_d_in <= 8'h91;
    tx_valid <= 1'b1;
    @(posedge clk);
    tx_valid <= 1'b0;
    @(posedge clk);
    wait (tx_ready);
    repeat (20) @(posedge clk);

    tx_d_in <= 8'h40;
    tx_valid <= 1'b1;
    @(posedge clk);
    tx_valid <= 1'b0;
    @(posedge clk);
    wait (tx_ready);
    repeat (20) @(posedge clk);

    tx_d_in <= 8'h01;
    tx_valid <= 1'b1;
    @(posedge clk);
    tx_valid <= 1'b0;
    @(posedge clk);
    wait (tx_ready);
    repeat (20) @(posedge clk);

    repeat (10000) @(posedge clk);

    $finish;
  end

endmodule
