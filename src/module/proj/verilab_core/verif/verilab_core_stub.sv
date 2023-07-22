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

`ifndef __verilab_core_stub__
`define __verilab_core_stub__
// A stub module def file is always read before its real counterpart, so a predefined __module_name__ token allows the stub to be compiled instead. Unless the __module_name_stub__ token is also predefined, in which case
// no module def is compiled at all. That might be appropriate if e.g. a parent module higher in the design hierarchy is stubbed out, and then either def of the lower module would be a nuisance implicit top-level instance.
`ifdef __verilab_core__

// All output ports of a stub module must be "net" (not var - reg, logic, bit, ...) type.
// All vector ports of a stub module must be PROJ (max) width.
module verilab_core (
  input reset_n,
  input clk,
  input i2c_scl_i,
  output i2c_scl_o,
  output i2c_scl_e,
  input i2c_sda_i,
  output i2c_sda_o,
  output i2c_sda_e,
  input [verilab_core_verif_param_pkg::GPIO-1:0] gpio_i,
  output [verilab_core_verif_param_pkg::GPIO-1:0] gpio_o,
  output [verilab_core_verif_param_pkg::GPIO-1:0] gpio_e
);

  // Weak default drives on all output ports.
  assign (pull1, pull0) i2c_scl_o = '0;
  assign (pull1, pull0) i2c_scl_e = '0;
  assign (pull1, pull0) i2c_sda_o = '0;
  assign (pull1, pull0) i2c_sda_e = '0;
  assign (pull1, pull0) gpio_o = '0;
  assign (pull1, pull0) gpio_e = '0;

`ifdef __verilab_core_stub_lumpy__
  proc_subsys proc_subsys_0 ();

  ahb2apb#(.ADDR(24), .HDATA(32), .PDATA(32)) ahb2apb_0 ();

  periph_subsys periph_subsys_0 ();
`endif
endmodule

`endif
`endif
