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

`ifndef __i2c__
`define __i2c__

module i2c#(MST_ADDR, SLV_DATA) (
  input i2c_scl_i,
  output i2c_scl_o,
  output i2c_scl_e,
  input i2c_sda_i,
  output i2c_sda_o,
  output i2c_sda_e,
  input preset_n,
  input pclk,
  output mst_psel,
  output mst_penable,
  output [2:0] mst_pprot,
  output [MST_ADDR-1:0] mst_paddr,
  output mst_pwrite,
  output [31:0] mst_pwdata,
  output [3:0] mst_pstrb,
  input [31:0] mst_prdata,
  input mst_pslverr,
  input mst_pready,
  input slv_psel,
  input slv_penable,
  input [2:0] slv_pprot,
  input [11:0] slv_paddr,
  input slv_pwrite,
  input [SLV_DATA-1:0] slv_pwdata,
  input [(SLV_DATA>>3)-1:0] slv_pstrb,
  output [SLV_DATA-1:0] slv_prdata,
  output slv_pslverr,
  output slv_pready
);
endmodule

`endif

