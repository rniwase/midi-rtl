module top (
  input  logic clk,  // 50MHz
  input  logic reset_n_in,
  input  logic midi_in,
  output logic note_cv_p,
  output logic note_cv_n
);

  logic [9:0] reset_n_buf;
  always_ff @(posedge clk)
    reset_n_buf <= {reset_n_buf[8:0], reset_n_in};

  logic reset_n;
  always_ff @(posedge clk)
    reset_n <= &reset_n_buf;

  logic [5:0] dsm_enable_count;
  logic dsm_enable_count_match;
  assign dsm_enable_count_match = dsm_enable_count == 6'd49;  // 1MHz

  always_ff @(posedge clk) begin
    if (~reset_n)
      dsm_enable_count <= 6'd0;
    else if (dsm_enable_count_match)
      dsm_enable_count <= 6'd0;
    else
      dsm_enable_count <= dsm_enable_count + 6'd1;
  end

  logic dsm_enable;
  always_ff @(posedge clk)
    dsm_enable <= dsm_enable_count_match;

  logic rx_valid, rx_f_error;
  logic [7:0] rx_data;

  uart_rx uart_rx_i (
    .rx_in   (midi_in   ),
    .valid   (rx_valid  ),
    .d_out   (rx_data   ),
    .f_error (rx_f_error),
    .*
  );

  logic v_valid, v_note_off, v_note_on;
  logic [3:0] v_channel;
  logic [6:0] v_note_num;
  logic [6:0] v_note_velocity;

  midi_perser midi_perser_i (
    .d_in    (rx_data   ),
    .d_valid (rx_valid  ),
    .f_error (rx_f_error),
    .*
  );

  logic [6:0] note_num_out_mono;

  poly2mono poly2mono_i (
    .ready (),
    .valid_in (v_valid & (v_note_off | v_note_on)),
    .note_on_in (v_note_on),
    .note_num_in (v_note_num),
    .velocity_in (v_note_velocity),
    .note_on_out (),
    .note_num_out (note_num_out_mono),
    .velocity_out (),
    .*
  );

  logic [6:0] note_num_wrap;
  always_ff @(posedge clk) begin
    if (note_num_out_mono >= 7'd60)
      note_num_wrap <= 7'd59;
    else
      note_num_wrap <= note_num_out_mono;
  end

  dsm #(
    .DEPTH   (6)
  ) dsm_i (
    .enable   (dsm_enable          ),
    .data_in  (note_num_wrap[5:0]),
    .dsm_out_p(note_cv_p           ),
    .dsm_out_n(note_cv_n           ),
    .*
  );

endmodule
