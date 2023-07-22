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

`ifndef __gpio_stub__
`define __gpio_stub__
// A stub module def file is always read before its real counterpart, so a predefined __module_name__ token allows the stub to be compiled instead. Unless the __module_name_stub__ token is also predefined, in which case
// no module def is compiled at all. That might be appropriate if e.g. a parent module higher in the design hierarchy is stubbed out, and then either def of the lower module would be a nuisance implicit top-level instance.
`ifdef __gpio__

module gpio#(GPIO = 32) ( // Stub ignores instance width param(s), uses proj max width param(s).
  input preset_n,
  input pclk,
  input psel,
  input penable,
  input pprot,
  input [gpio_verif_param_pkg::PADDR-1:0] paddr,
  input pwrite,
  input [gpio_verif_param_pkg::PDATA-1:0] pwdata,
  input [(gpio_verif_param_pkg::PDATA>>3)-1:0] pstrb,
  output [gpio_verif_param_pkg::PDATA-1:0] prdata,
  output pslverr,
  output pready,
  input [gpio_verif_param_pkg::GPIO-1:0] gpio_i,
  output [gpio_verif_param_pkg::GPIO-1:0] gpio_o,
  output [gpio_verif_param_pkg::GPIO-1:0] gpio_e
);

  assign (pull1, pull0) prdata = '0;
  assign (pull1, pull0) pslverr = '0;
  assign (pull1, pull0) pready = '1;
  assign (pull1, pull0) gpio_o = '0;
  assign (pull1, pull0) gpio_e = '0;
endmodule

`endif
`endif

