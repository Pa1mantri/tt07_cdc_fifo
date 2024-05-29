module binary_to_gray #(
  parameter WIDTH = 8
) (
  input logic [WIDTH-1:0] binary,
  output logic [WIDTH-1:0] gray
);

  assign gray = (binary >> 1) ^ binary;

endmodule
