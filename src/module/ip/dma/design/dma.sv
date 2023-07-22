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

`ifndef __dma__
`define __dma__

module dma (
  input reset_n,
  input clk,
  output [1:0] htrans,
  output [2:0] hburst,
  output [2:0] hsize,
  output [3:0] hprot,
  output hmastlock,
  output [31:0] haddr,
  output hwrite,
  output [31:0] hwdata,
  input [31:0] hrdata,
  input hresp,
  input hready,
  input psel,
  input penable,
  input [2:0] pprot,
  input [11:0] paddr,
  input pwrite,
  input [31:0] pwdata,
  input [3:0] pstrb,
  output [31:0] prdata,
  output pslverr,
  output pready
);
endmodule

`endif

