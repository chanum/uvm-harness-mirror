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

`ifndef __mem_stub__
`define __mem_stub__
// A stub module def file is always read before its real counterpart, so a predefined __module_name__ token allows the stub to be compiled instead. Unless the __module_name_stub__ token is also predefined, in which case
// no module def is compiled at all. That might be appropriate if e.g. a parent module higher in the design hierarchy is stubbed out, and then either def of the lower module would be a nuisance implicit top-level instance.
`ifdef __mem__

module mem#(ADDR = 32, DATA = 32) ( // Stub ignores instance width param(s), uses max width param(s).
  input hreset_n,
  input hclk,
  input hsel,
  input [1:0] htrans,
  input [2:0] hburst,
  input [2:0] hsize,
  input [3:0] hprot,
  input hmastlock,
  input [mem_verif_param_pkg::ADDR-1:0] haddr,
  input hwrite,
  input [mem_verif_param_pkg::DATA-1:0] hwdata,
  output [mem_verif_param_pkg::DATA-1:0] hrdata,
  output hresp,
  output hreadyout,
  input hready
);

  assign (pull1, pull0) hrdata = '0;
  assign (pull1, pull0) hresp = ahb_names_pkg::HRESP_OKAY;
  assign (pull1, pull0) hreadyout = '1;
endmodule

`endif
`endif

