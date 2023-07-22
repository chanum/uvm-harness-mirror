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

`ifndef __verilab_chip__
`define __verilab_chip__

module verilab_chip (
  input reset_n,
  input clk,
  inout i2c_scl,
  inout i2c_sda,
  inout [31:0] gpio
);

  wire core_reset_n;
  wire core_clk;
  wire core_i2c_scl_in;
  wire core_i2c_scl_out;
  wire core_i2c_scl_en;
  wire core_i2c_sda_in;
  wire core_i2c_sda_out;
  wire core_i2c_sda_en;
  wire [31:0] core_gpio_in;
  wire [31:0] core_gpio_out;
  wire [31:0] core_gpio_en;

  verilab_pads verilab_pads_0 (
    .reset_n (reset_n),
    .clk (clk),
    .i2c_scl (i2c_scl),
    .i2c_sda (i2c_sda),
    .gpio (gpio),
    .core_reset_n (core_reset_n),
    .core_clk (core_clk),
    .core_i2c_scl_in (core_i2c_scl_in),
    .core_i2c_scl_out (core_i2c_scl_out),
    .core_i2c_scl_en (core_i2c_scl_en),
    .core_i2c_sda_in (core_i2c_sda_in),
    .core_i2c_sda_out (core_i2c_sda_out),
    .core_i2c_sda_en (core_i2c_sda_en),
    .core_gpio_in (core_gpio_in),
    .core_gpio_out (core_gpio_out),
    .core_gpio_en (core_gpio_en)
  );

  verilab_core verilab_core_0 (
    .reset_n (core_reset_n),
    .clk (core_clk),
    .i2c_scl_i (core_i2c_scl_in),
    .i2c_scl_o (core_i2c_scl_out),
    .i2c_scl_e (core_i2c_scl_en),
    .i2c_sda_i (core_i2c_sda_in),
    .i2c_sda_o (core_i2c_sda_out),
    .i2c_sda_e (core_i2c_sda_en),
    .gpio_i (core_gpio_in),
    .gpio_o (core_gpio_out),
    .gpio_e (core_gpio_en)
  );
endmodule

`endif

