module gray_to_binary #(
  parameter WIDTH = 8
) (
  input logic [WIDTH-1:0] gray,
  output logic [WIDTH-1:0] binary
);

  always_comb begin
    for (int i = 0; i < WIDTH; i++) begin
      binary[i] = ^(gray >> i);
    end
  end

endmodule
