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

`ifndef __periph_subsys_stub__
`define __periph_subsys_stub__
// A stub module def file is always read before its real counterpart, so a predefined __module_name__ token allows the stub to be compiled instead. Unless the __module_name_stub__ token is also predefined, in which case
// no module def is compiled at all. That might be appropriate if e.g. a parent module higher in the design hierarchy is stubbed out, and then either def of the lower module would be a nuisance implicit top-level instance.
`ifdef __periph_subsys__

module periph_subsys (
  input preset_n,
  input pclk,
  input proc_psel,
  input proc_penable,
  input [2:0] proc_pprot,
  input [periph_subsys_verif_param_pkg::PADDR-1:0] proc_paddr,
  input proc_pwrite,
  input [periph_subsys_verif_param_pkg::PDATA-1:0] proc_pwdata,
  input [(periph_subsys_verif_param_pkg::PDATA>>3)-1:0] proc_pstrb,
  output [periph_subsys_verif_param_pkg::PDATA-1:0] proc_prdata,
  output proc_pslverr,
  output proc_pready,
  output dma_psel,
  output dma_penable,
  output [2:0] dma_pprot,
  output [periph_subsys_verif_param_pkg::PADDR-1:0] dma_paddr,
  output dma_pwrite,
  output [periph_subsys_verif_param_pkg::PDATA-1:0] dma_pwdata,
  output [(periph_subsys_verif_param_pkg::PDATA>>3)-1:0] dma_pstrb,
  input [periph_subsys_verif_param_pkg::PDATA-1:0] dma_prdata,
  input dma_pslverr,
  input dma_pready,
  input i2c_scl_i,
  output i2c_scl_o,
  output i2c_scl_e,
  input i2c_sda_i,
  output i2c_sda_o,
  output i2c_sda_e,
  input [31:0] gpio_i,
  output [31:0] gpio_o,
  output [31:0] gpio_e
);

  assign (pull1, pull0)  proc_prdata = '0;
  assign (pull1, pull0)  proc_pslverr = '0;
  assign (pull1, pull0)  proc_pready = '0;
  assign (pull1, pull0)  dma_psel = '0;
  assign (pull1, pull0)  dma_penable = '0;
  assign (pull1, pull0)  dma_pprot = '0;
  assign (pull1, pull0)  dma_paddr = '0;
  assign (pull1, pull0)  dma_pwrite = '0;
  assign (pull1, pull0)  dma_pwdata = '0;
  assign (pull1, pull0)  dma_pstrb = '0;
  assign (pull1, pull0)  i2c_scl_o = '0;
  assign (pull1, pull0)  i2c_scl_e = '0;
  assign (pull1, pull0)  i2c_sda_o = '0;
  assign (pull1, pull0)  i2c_sda_e = '0;
  assign (pull1, pull0)  gpio_o = '0;
  assign (pull1, pull0)  gpio_e = '0;

`ifdef __periph_subsys_stub_lumpy__
  apb_fabric#(.MST(2), .SLV(3), .MST_ADDR(24), .SLV_ADDR(16), .DATA(32)) apb_fabric_0 ();

  i2c#(.MST_ADDR(24), .SLV_DATA(32)) i2c_0 ();

  gpio#(.GPIO(32)) gpio_0 ();
`endif
endmodule

`endif
`endif
