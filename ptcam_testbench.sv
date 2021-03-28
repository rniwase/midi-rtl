`timescale 1 ns / 1 ns

module ptcam_testbench;

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
  end

  parameter CLK_CYCLE = 20;  // 50MHz

  logic clk, reset_n;

  logic [3:0] w_addr;
  logic [18:0] w_din;
  logic [18:0] w_mask;
  logic w_en;
  logic [3:0] r_addr;
  logic [18:0] r_dout;
  logic [18:0] search_din;
  logic [18:0] search_mask;
  logic search_en;
  logic search_valid;
  logic [18:0] search_dout;
  logic [3:0] search_addr_out;
  logic search_notfound;

  ptcam ptcam_i (.*);

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
    w_addr <= 4'h0;
    r_addr <= 4'h0;
    w_mask <= ~19'h0;
    w_en <= 1'b0;
    w_din <= 19'h0;
    search_din <= 19'h0;
    search_mask <= ~19'h0;
    search_en <= 1'b0;

    wait (reset_n);
    repeat (10) @(posedge clk);
    search_en <= 1'b1;
    @(posedge clk);
    search_en <= 1'b0;
    wait (search_valid);
    @(posedge clk);
    search_din <= 19'hABC;
    search_en <= 1'b1;
    @(posedge clk);
    search_en <= 1'b0;
    wait (search_valid);
    @(posedge clk);
    w_en <= 1'b1;
    w_addr <= 4'h7;
    w_din <= 19'hABC;
    @(posedge clk);
    w_addr <= 4'hF;
    w_din <= 19'hDEF;
    @(posedge clk);
    w_en <= 1'b0;
    @(posedge clk);
    search_din <= 19'hABC;
    search_en <= 1'b1;
    @(posedge clk);
    search_en <= 1'b0;
    wait (search_valid);
    @(posedge clk);
    search_din <= 19'hDEF;
    search_en <= 1'b1;
    @(posedge clk);
    search_en <= 1'b0;
    wait (search_valid);
    @(posedge clk);
    search_din <= 19'hC;
    search_mask <= 19'hF;
    search_en <= 1'b1;
    @(posedge clk);
    search_en <= 1'b0;
    wait (search_valid);

    @(posedge clk);
    r_addr <= 4'h7;
    @(posedge clk);
    r_addr <= 4'hF;

    @(posedge clk);
    w_en <= 1'b1;
    w_addr <= 4'hF;
    w_din <= 19'h123;
    w_mask <= 19'h00F;
    @(posedge clk);
    w_en <= 1'b0;

    repeat (10) @(posedge clk);

    $finish;
  end

endmodule
