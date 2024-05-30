<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This is a FIFO that can pass data asynchronously across clock domains.

## How to test

Hold write_reset and read_reset LOW while running the clock for a bit to reset, then raise to initialize the module.

writing to the fifo: Prepare your data on the 4-bit write_data bus, ensure the full state is low and then raise write_increment for 1 cycle of write_clock to write data into the FIFO memory.

Reading from the fifo: The FIFO will present the current output on the read_data bus. If empty is low, this output should be valid and you can acknowledge receive of this vallue by raising read_increment for 1 cycle of read_clock.

## External hardware

NO external hardware is used.
