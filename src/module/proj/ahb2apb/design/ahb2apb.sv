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

`ifndef __ahb2apb__
`define __ahb2apb__

module ahb2apb #(ADDR = 32, HDATA = 32, PDATA = 32) (
  input reset_n,
  input clk,
  input   hsel,
  input  [1:0] htrans,
  input  [2:0] hburst,
  input  [2:0] hsize,
  input  [3:0] hprot,
  input   hmastlock,
  input  [ADDR-1:0] haddr,
  input   hwrite,
  input  [HDATA-1:0] hwdata,
  output [HDATA-1:0] hrdata,
  output  hresp,
  output  hreadyout,
  input   hready,
  output  psel,
  output  penable,
  output [2:0] pprot,
  output [ADDR-1:0] paddr,
  output  pwrite,
  output [(PDATA>>3)-1:0] pstrb,
  output [PDATA-1:0] pwdata,
  input  [PDATA-1:0] prdata,
  input   pslverr,
  input   pready
);

  import apb_names_pkg::*;
  import ahb_names_pkg::*;
endmodule

`endif

