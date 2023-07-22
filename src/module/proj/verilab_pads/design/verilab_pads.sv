// Copyright 2017 Verilab Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

`ifndef __verilab_pads__
`define __verilab_pads__

module verilab_pads (
  input reset_n,
  input clk,
  inout i2c_scl,
  inout i2c_sda,
  inout [31:0] gpio,
  output core_reset_n,
  output core_clk,
  output core_i2c_scl_in,
  input core_i2c_scl_out,
  input core_i2c_scl_en,
  output core_i2c_sda_in,
  input core_i2c_sda_out,
  input core_i2c_sda_en,
  output [31:0] core_gpio_in,
  input [31:0] core_gpio_out,
  input [31:0] core_gpio_en
);


  pad_in pad_in_reset_n (
    .I (reset_n),
    .O (core_reset_n)
  );

  pad_in pad_in_clk (
    .I (clk),
    .O (core_clk)
  );

  pad_io pad_io_i2c_scl (
    .I (core_i2c_scl_out),
    .O (core_i2c_scl_in),
    .EN (core_i2c_scl_en),
    .IO (i2c_scl)
  );

  pad_io pad_io_i2c_sda (
    .I (core_i2c_sda_out),
    .O (core_i2c_sda_in),
    .EN (core_i2c_sda_en),
    .IO (i2c_sda)
  );

  pad_io pad_io_gpio[31:0] (
    .I (core_gpio_out),
    .O (core_gpio_in),
    .EN (core_gpio_en),
    .IO (gpio)
  );
endmodule

`endif

