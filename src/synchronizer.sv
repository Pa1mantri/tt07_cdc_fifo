module synchronizer #(
  parameter WIDTH = 1
) (
  input logic clock,
  input logic reset,
  input logic [WIDTH-1:0] in,
  output logic [WIDTH-1:0] out);

  logic [WIDTH-1:0] data;

  always_ff @ (posedge clock or posedge reset) begin
    if (reset) begin
        out <= 0;
        data <= 0;
    end else begin
        {out, data} <= {data, in};
    end
  end
endmodule
