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

`ifndef __i2c_stub__
`define __i2c_stub__
// A stub module def file is always read before its real counterpart, so a predefined __module_name__ token allows the stub to be compiled instead. Unless the __module_name_stub__ token is also predefined, in which case
// no module def is compiled at all. That might be appropriate if e.g. a parent module higher in the design hierarchy is stubbed out, and then either def of the lower module would be a nuisance implicit top-level instance.
`ifdef __i2c__

module i2c#(MST_ADDR, SLV_DATA) ( // Stub ignores instance width param(s), uses proj max width param(s).
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
  output [i2c_verif_param_pkg::PADDR-1:0] mst_paddr,
  output mst_pwrite,
  output [i2c_verif_param_pkg::PDATA-1:0] mst_pwdata,
  output [(i2c_verif_param_pkg::PDATA>>3)-1:0] mst_pstrb,
  input [i2c_verif_param_pkg::PDATA-1:0] mst_prdata,
  input mst_pslverr,
  input mst_pready,
  input slv_psel,
  input slv_penable,
  input [2:0] slv_pprot,
  input [i2c_verif_param_pkg::PADDR-1:0] slv_paddr,
  input slv_pwrite,
  input [i2c_verif_param_pkg::PDATA-1:0] slv_pwdata,
  input [(i2c_verif_param_pkg::PDATA>>3)-1:0] slv_pstrb,
  output [i2c_verif_param_pkg::PDATA-1:0] slv_prdata,
  output slv_pslverr,
  output slv_pready
);

  assign (pull1, pull0) i2c_scl_o = '0;
  assign (pull1, pull0) i2c_scl_e = '0;
  assign (pull1, pull0) i2c_sda_o = '0;
  assign (pull1, pull0) i2c_sda_e = '0;
  assign (pull1, pull0) mst_psel = '0;
  assign (pull1, pull0) mst_penable = '0;
  assign (pull1, pull0) mst_pprot = '0;
  assign (pull1, pull0) mst_paddr = '0;
  assign (pull1, pull0) mst_pwrite = '0;
  assign (pull1, pull0) mst_pwdata = '0;
  assign (pull1, pull0) mst_pstrb = '0;
  assign (pull1, pull0) slv_prdata = '0;
  assign (pull1, pull0) slv_pslverr = '0;
  assign (pull1, pull0) slv_pready = '1;
endmodule

`endif
`endif

