`timescale 1 ns / 1 ns

module midi_parser_testbench;

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
  end

  parameter CLK_CYCLE = 20;  // 50MHz

  logic        clk;
  logic        reset_n;
  logic [ 7:0] d_in;
  logic        d_valid;
  logic        f_error;

  logic        v_valid;
  logic [ 3:0] v_channel;

  logic        v_note_off;
  logic        v_note_on;
  logic [ 6:0] v_note_num;
  logic [ 6:0] v_note_velocity;

  midi_perser midi_perser_i (.*);

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

  integer i;
  initial begin
    d_in <= 8'h00;
    d_valid <= 1'b0;
    f_error <= 1'b0;

    wait (reset_n);
    repeat (10) @(posedge clk);
    d_in <= 8'h91;
    d_valid <= 1'b1;
    @(posedge clk);
    d_valid <= 1'b0;
    repeat (10) @(posedge clk);
    d_in <= 8'h01;
    d_valid <= 1'b1;
    @(posedge clk);
    d_valid <= 1'b0;
    repeat (10) @(posedge clk);
    d_in <= 8'h02;
    d_valid <= 1'b1;
    @(posedge clk);
    d_valid <= 1'b0;
    repeat (10) @(posedge clk);
    d_in <= 8'h03;
    d_valid <= 1'b1;
    @(posedge clk);
    d_valid <= 1'b0;
    repeat (10) @(posedge clk);
    d_in <= 8'h04;
    d_valid <= 1'b1;
    @(posedge clk);
    d_valid <= 1'b0;
    repeat (10) @(posedge clk);
    d_in <= 8'h81;
    d_valid <= 1'b1;
    @(posedge clk);
    d_valid <= 1'b0;
    repeat (10) @(posedge clk);
    d_in <= 8'h03;
    d_valid <= 1'b1;
    @(posedge clk);
    d_valid <= 1'b0;
    repeat (10) @(posedge clk);
    d_in <= 8'h00;
    d_valid <= 1'b1;
    @(posedge clk);
    d_valid <= 1'b0;

    repeat (10) @(posedge clk);

    $finish;
  end

endmodule
