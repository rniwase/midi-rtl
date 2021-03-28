`timescale 1 ns / 1 ns

module poly2mono_testbench;

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
  end

  parameter CLK_CYCLE = 20;  // 50MHz

  logic       clk;
  logic       reset_n;
  logic       ready;

  logic       valid_in;
  logic       note_on_in;
  logic [6:0] note_num_in;
  logic [6:0] velocity_in;

  logic       note_on_out;
  logic [6:0] note_num_out;
  logic [6:0] velocity_out;

  poly2mono poly2mono_i (.*);

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
    valid_in <= 1'b0;
    note_on_in <= 1'b0;
    note_num_in <= 7'h0;
    velocity_in <= 7'h0;

    wait (reset_n);
    repeat (10) @(posedge clk);
    valid_in <= 1'b1;
    note_on_in <= 1'b1;
    note_num_in <= 7'h01;
    velocity_in <= 7'h01;
    @(posedge clk);
    valid_in <= 1'b0;
    @(posedge clk);
    wait (ready);

    repeat (10) @(posedge clk);
    valid_in <= 1'b1;
    note_on_in <= 1'b1;
    note_num_in <= 7'h01;
    velocity_in <= 7'h02;
    @(posedge clk);
    valid_in <= 1'b0;
    @(posedge clk);
    wait (ready);

    repeat (10) @(posedge clk);
    valid_in <= 1'b1;
    note_on_in <= 1'b1;
    note_num_in <= 7'h02;
    velocity_in <= 7'h03;
    @(posedge clk);
    valid_in <= 1'b0;
    @(posedge clk);
    wait (ready);

    repeat (10) @(posedge clk);
    valid_in <= 1'b1;
    note_on_in <= 1'b1;
    note_num_in <= 7'h03;
    velocity_in <= 7'h04;
    @(posedge clk);
    valid_in <= 1'b0;
    @(posedge clk);
    wait (ready);

    repeat (10) @(posedge clk);
    valid_in <= 1'b1;
    note_on_in <= 1'b1;
    note_num_in <= 7'h03;
    velocity_in <= 7'h00;
    @(posedge clk);
    valid_in <= 1'b0;
    @(posedge clk);
    wait (ready);

    repeat (10) @(posedge clk);
    valid_in <= 1'b1;
    note_on_in <= 1'b1;
    note_num_in <= 7'h03;
    velocity_in <= 7'h04;
    @(posedge clk);
    valid_in <= 1'b0;
    @(posedge clk);
    wait (ready);

    repeat (10) @(posedge clk);
    valid_in <= 1'b1;
    note_on_in <= 1'b1;
    note_num_in <= 7'h02;
    velocity_in <= 7'h00;
    @(posedge clk);
    valid_in <= 1'b0;
    @(posedge clk);
    wait (ready);

    repeat (10) @(posedge clk);
    valid_in <= 1'b1;
    note_on_in <= 1'b1;
    note_num_in <= 7'h02;
    velocity_in <= 7'h03;
    @(posedge clk);
    valid_in <= 1'b0;
    @(posedge clk);
    wait (ready);

    repeat (10) @(posedge clk);
    valid_in <= 1'b1;
    note_on_in <= 1'b1;
    note_num_in <= 7'h02;
    velocity_in <= 7'h00;
    @(posedge clk);
    valid_in <= 1'b0;
    @(posedge clk);
    wait (ready);

    repeat (10) @(posedge clk);
    valid_in <= 1'b1;
    note_on_in <= 1'b1;
    note_num_in <= 7'h04;
    velocity_in <= 7'h05;
    @(posedge clk);
    valid_in <= 1'b0;
    @(posedge clk);
    wait (ready);

    repeat (10) @(posedge clk);
    valid_in <= 1'b1;
    note_on_in <= 1'b1;
    note_num_in <= 7'h04;
    velocity_in <= 7'h00;
    @(posedge clk);
    valid_in <= 1'b0;
    @(posedge clk);
    wait (ready);

    repeat (10) @(posedge clk);
    valid_in <= 1'b1;
    note_on_in <= 1'b1;
    note_num_in <= 7'h01;
    velocity_in <= 7'h00;
    @(posedge clk);
    valid_in <= 1'b0;
    @(posedge clk);
    wait (ready);

    repeat (10) @(posedge clk);
    valid_in <= 1'b1;
    note_on_in <= 1'b1;
    note_num_in <= 7'h03;
    velocity_in <= 7'h00;
    @(posedge clk);
    valid_in <= 1'b0;
    @(posedge clk);
    wait (ready);

    for (i = 0; i<=16; i=i+1) begin
      repeat (10) @(posedge clk);
      valid_in <= 1'b1;
      note_on_in <= 1'b1;
      note_num_in <= 7'h10 + i;
      velocity_in <= 7'h20 + i;
      @(posedge clk);
      valid_in <= 1'b0;
      @(posedge clk);
      wait (ready);
    end

    for (i = 0; i<=16; i=i+1) begin
      repeat (10) @(posedge clk);
      valid_in <= 1'b1;
      note_on_in <= 1'b0;
      note_num_in <= 7'h10 + i;
      velocity_in <= 7'h0;
      @(posedge clk);
      valid_in <= 1'b0;
      @(posedge clk);
      wait (ready);
    end

    for (i = 0; i<=16; i=i+1) begin
      repeat (10) @(posedge clk);
      valid_in <= 1'b1;
      note_on_in <= 1'b1;
      note_num_in <= 7'h10 + i;
      velocity_in <= 7'h20 + i;
      @(posedge clk);
      valid_in <= 1'b0;
      @(posedge clk);
      wait (ready);
    end

    for (i = 16; i>=0; i=i-1) begin
      repeat (10) @(posedge clk);
      valid_in <= 1'b1;
      note_on_in <= 1'b0;
      note_num_in <= 7'h10 + i;
      velocity_in <= 7'h0;
      @(posedge clk);
      valid_in <= 1'b0;
      @(posedge clk);
      wait (ready);
    end


    repeat (10) @(posedge clk);

    $finish;
  end

endmodule
