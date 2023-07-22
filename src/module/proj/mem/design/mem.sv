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

`ifndef __mem__
`define __mem__

module mem #(ADDR = 32, DATA = 32) (
  input hreset_n,
  input hclk,
  input hsel,
  input [1:0] htrans,
  input [2:0] hburst,
  input [2:0] hsize,
  input [3:0] hprot,
  input hmastlock,
  input [ADDR-1:0] haddr,
  input hwrite,
  input [DATA-1:0] hwdata,
  output [DATA-1:0] hrdata,
  output hresp,
  output hreadyout,
  input hready
);
endmodule

`endif

