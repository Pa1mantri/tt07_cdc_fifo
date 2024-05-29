# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")
    write_clock_port = dut.ui_in[0]
    write_increment = dut.ui_in[1]
    read_clock_port = dut.ui_in[2]
    read_increment = dut.ui_in[3]
    write_data = [
    dut.ui_in[4],
    dut.ui_in[5],
    dut.ui_in[6],
    dut.ui_in[7]
  ]
    empty = dut.uo_out[0]
    full = dut.uo_out[1]
    read_data = [
    dut.uo_out[4],
    dut.uo_out[5],
    dut.uo_out[6],
    dut.uo_out[7]
  ]
    write_reset = dut.uio_in[0]
    read_reset = dut.uio_in[1]
    write_increment.value = 0
    read_increment.value = 0
    for i in write_data:
    	i.value = 0

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())
    write_clock = Clock(write_clock_port, 10, units="us")
    read_clock = Clock(read_clock_port, 25, units="us")
    cocotb.start_soon(read_clock.start())
    cocotb.start_soon(write_clock.start())

    # Reset
    dut._log.info("Reset")
    write_reset.value = 0
    read_reset.value = 0
    await ClockCycles(dut.clk, 10)
    write_reset.value = 1
    read_reset.value = 1
    await ClockCycles(dut.clk, 10)
  
   # Set the input values, wait one clock cycle, and check the output
    dut._log.info("Test")
    assert empty.value == 1
    assert full.value == 0

    write_increment.value = 1
    await ClockCycles(dut.clk, 2)
    write_increment.value = 0
    await ClockCycles(dut.clk, 10)
    assert empty.value == 0

