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

`ifndef __verilab_pads_stub__
`define __verilab_pads_stub__
// A stub module def file is always read before its real counterpart, so a predefined __module_name__ token allows the stub to be compiled instead. Unless the __module_name_stub__ token is also predefined, in which case
// no module def is compiled at all. That might be appropriate if e.g. a parent module higher in the design hierarchy is stubbed out, and then either def of the lower module would be a nuisance implicit top-level instance.
`ifdef __verilab_pads__

module verilab_pads (
  input reset_n,
  input clk,
  inout i2c_scl,
  inout i2c_sda,
  inout [verilab_pads_verif_param_pkg::GPIO-1:0] gpio,
  output core_reset_n,
  output core_clk,
  output core_i2c_scl_in,
  input core_i2c_scl_out,
  input core_i2c_scl_en,
  output core_i2c_sda_in,
  input core_i2c_sda_out,
  input core_i2c_sda_en,
  output [verilab_pads_verif_param_pkg::GPIO-1:0] core_gpio_in,
  input [verilab_pads_verif_param_pkg::GPIO-1:0] core_gpio_out,
  input [verilab_pads_verif_param_pkg::GPIO-1:0] core_gpio_en
);

  assign (pull1, pull0) i2c_scl = '1;
  assign (pull1, pull0) i2c_sda = '1;
  assign (pull1, pull0) gpio = '0;
  assign (pull1, pull0) core_reset_n = '0;
  assign (pull1, pull0) core_clk = '0;
  assign (pull1, pull0) core_i2c_scl_in = '1;
  assign (pull1, pull0) core_i2c_sda_in = '1;
  assign (pull1, pull0) core_gpio_in = '0;
endmodule

`endif
`endif
