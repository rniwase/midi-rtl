module dsm #(
  parameter DEPTH = 8
)(
  input  logic             clk,
  input  logic             reset_n,
  input  logic             enable,
  input  logic [DEPTH-1:0] data_in,
  output logic             dsm_out_p,
  output logic             dsm_out_n
);

  logic [DEPTH-1:0] dse;
  logic [DEPTH  :0] add;

  assign add = data_in + dse;

  always_ff @(posedge clk) begin
    if (~reset_n)
      dse <= 0;
    else if (enable)
      dse <= add[DEPTH-1:0];
  end

  always_ff @(posedge clk) begin
    dsm_out_p <=  add[DEPTH];
    dsm_out_n <= ~add[DEPTH];
  end

endmodule
