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

`ifndef __ahb2apb_stub__
`define __ahb2apb_stub__
// A stub module def file is always read before its real counterpart, so a predefined __module_name__ token allows the stub to be compiled instead. Unless the __module_name_stub__ token is also predefined, in which case
// no module def is compiled at all. That might be appropriate if e.g. a parent module higher in the design hierarchy is stubbed out, and then either def of the lower module would be a nuisance implicit top-level instance.
`ifdef __ahb2apb__

module ahb2apb #(ADDR = 32, HDATA = 32, PDATA = 32) (
  input reset_n,
  input clk,
  input   hsel,
  input  [1:0] htrans,
  input  [2:0] hburst,
  input  [2:0] hsize,
  input  [3:0] hprot,
  input   hmastlock,
  input  [ahb2apb_verif_param_pkg::HADDR-1:0] haddr,
  input   hwrite,
  input  [ahb2apb_verif_param_pkg::HDATA-1:0] hwdata,
  output [ahb2apb_verif_param_pkg::HDATA-1:0] hrdata,
  output  hresp,
  output  hreadyout,
  input   hready,
  output  psel,
  output  penable,
  output [2:0] pprot,
  output [ahb2apb_verif_param_pkg::PADDR-1:0] paddr,
  output  pwrite,
  output [(ahb2apb_verif_param_pkg::PDATA>>3)-1:0] pstrb,
  output [ahb2apb_verif_param_pkg::PDATA-1:0] pwdata,
  input  [ahb2apb_verif_param_pkg::PDATA-1:0] prdata,
  input   pslverr,
  input   pready
);

  assign (pull1, pull0) hrdata = '0;
  assign (pull1, pull0) hresp = ahb_names_pkg::HRESP_OKAY;
  assign (pull1, pull0) hreadyout = '1;
  assign (pull1, pull0) psel = '0;
  assign (pull1, pull0) penable = '0;
  assign (pull1, pull0) pprot = '0;
  assign (pull1, pull0) paddr = '0;
  assign (pull1, pull0) pwrite = '0;
  assign (pull1, pull0) pstrb = '0;
  assign (pull1, pull0) pwdata = '0;
endmodule

`endif
`endif

