/* UART transmitter, num of stop bit: 1, no parity bit */

`timescale 1 ns / 1 ns

module uart_tx #(
  parameter BAUDGEN_PERIOD = 1600  // System clock frequency / UART Baud rate
                                   // (e.g.) 50[MHz] / 31.25[kbps] = 1600
)(
  input  logic       clk,      // System clock input
  input  logic       reset_n,  // Reset input
  output logic       tx_out,   // UART TX output
  input  logic       valid,    // Data valid input
  output logic       ready,    // Data ready output
  input  logic [7:0] d_in      // Data input
);

  logic[7:0] d_storereg;
  always_ff @(posedge clk) begin
    if (~reset_n)
      d_storereg <= 8'd0;
    else if (ready & valid)
      d_storereg <= d_in;
    else
      d_storereg <= d_storereg;
  end

  logic [15:0] baudgen_t_count;
  logic [ 3:0] baudgen_b_count;
  logic baudgen_t_match, endoftx;
  assign baudgen_t_match = baudgen_t_count == BAUDGEN_PERIOD-1;
  assign endoftx = baudgen_t_count == BAUDGEN_PERIOD-2 & baudgen_b_count == 4'd9;

  always_ff @(posedge clk) begin
    if (~reset_n)
      ready <= 1'b1;
    else if (endoftx)
      ready <= 1'b1;
    else if (ready & valid)
      ready <= 1'b0;
    else
      ready <= ready;
  end

  always_ff @(posedge clk) begin
    if (~ready) begin
      if (baudgen_t_match)
        baudgen_t_count <= 16'd0;
      else
        baudgen_t_count <= baudgen_t_count + 16'd1;
    end
    else if (valid & ready)
      baudgen_t_count <= 16'd0;
    else
      baudgen_t_count <= BAUDGEN_PERIOD-1;
  end

  always_ff @(posedge clk) begin
    if (~reset_n)
      baudgen_b_count <= 4'd9;
    else if (ready & valid)
      baudgen_b_count <= 4'd0;
    else if (~ready & baudgen_t_match)
      baudgen_b_count <= baudgen_b_count + 4'd1;
    else
      baudgen_b_count <= baudgen_b_count;
  end

  logic tx_out_buf;
  always_ff @(posedge clk) begin
    case (baudgen_b_count)
      4'd0: tx_out_buf <= 1'b0;
      4'd9: tx_out_buf <= 1'b1;
      default: tx_out_buf <= d_storereg[baudgen_b_count-1];
    endcase
  end

  always_ff @(posedge clk)
    tx_out <= tx_out_buf;

endmodule
