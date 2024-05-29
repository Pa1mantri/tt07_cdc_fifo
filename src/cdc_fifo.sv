// FIFO for passing registers across clock domains

//`include "dpram.sv"
//`include "synchronizer.sv"
//`include "cdc_fifo_read_state.sv"
//`include "cdc_fifo_write_state.sv"
//`include "binary_to_gray.sv"
//`include "gray_to_binary.sv"

module cdc_fifo #(
  parameter DATA_WIDTH = 8,
  parameter ADDRESS_WIDTH = 4
) (
  // Sender side signals/buses
  input logic write_clock,
  input logic write_reset,
  input logic [DATA_WIDTH-1:0] write_data,
  input logic write_increment,
  output logic full,

  // Receiver side signals/buses
  input logic read_clock,
  input logic read_reset,
  input logic read_increment,
  output logic [DATA_WIDTH-1:0] read_data,
  output logic empty
);

  wire write_enable;
  wire [ADDRESS_WIDTH-1:0] write_address;
  wire [ADDRESS_WIDTH-1:0] write_address_gray_presync;
  wire [ADDRESS_WIDTH-1:0] write_address_gray_postsync;
  wire [ADDRESS_WIDTH-1:0] read_address;
  wire [ADDRESS_WIDTH-1:0] read_address_gray_presync;
  wire [ADDRESS_WIDTH-1:0] read_address_gray_postsync;

  assign write_enable = (!full & write_increment);

  dpram #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDRESS_WIDTH(ADDRESS_WIDTH)
  ) fifo_memory (
    .clock(write_clock),
    .write_address(write_address),
    .write_data(write_data),
    .write_enable(write_enable),
    .read_address(read_address),
    .read_data(read_data)
  );

  cdc_fifo_write_state #(
    .ADDRESS_WIDTH(ADDRESS_WIDTH)
  ) writestate (
    .clock(write_clock),
    .reset(write_reset),
    .increment(write_increment),
    .read_address_gray(read_address_gray_postsync),
    .write_address(write_address),
    .write_address_gray(write_address_gray_presync),
    .full(full)
  );

  cdc_fifo_read_state #(
    .ADDRESS_WIDTH(ADDRESS_WIDTH)
  ) readstate (
   .clock(read_clock),
   .reset(read_reset),
   .increment(read_increment),
   .write_address_gray(write_address_gray_postsync),
   .read_address(read_address),
   .read_address_gray(read_address_gray_presync),
   .empty(empty)
  );

  synchronizer #(
    .WIDTH(ADDRESS_WIDTH)
  ) write_address_sync (
    .clock(read_clock),
    .reset(read_reset),
    .in(write_address_gray_presync),
    .out(write_address_gray_postsync)
  );

  synchronizer #(
    .WIDTH(ADDRESS_WIDTH)
  ) read_address_sync (
    .clock(write_clock),
    .reset(write_reset),
    .in(read_address_gray_presync),
    .out(read_address_gray_postsync)
  );

endmodule
