// Dual-ported parameterized RAM module
module dpram #(
  parameter DATA_WIDTH = 8,
  parameter ADDRESS_WIDTH = 4
) (
  input logic clock,

  input logic [ADDRESS_WIDTH-1:0] write_address,
  input logic [DATA_WIDTH-1:0] write_data,
  input logic write_enable,

  input logic [ADDRESS_WIDTH-1:0] read_address,
  output logic [DATA_WIDTH-1:0] read_data
);

  logic [DATA_WIDTH-1:0] memory [0:(1<<ADDRESS_WIDTH)-1];

  assign read_data = memory[read_address];

  always_ff @ (posedge clock) begin
    if (write_enable) begin
      memory[write_address] <= write_data;
    end
  end

endmodule
