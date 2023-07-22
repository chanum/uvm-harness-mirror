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

`ifndef __proc_subsys_stub__
`define __proc_subsys_stub__
// A stub module def file is always read before its real counterpart, so a predefined __module_name__ token allows the stub to be compiled instead. Unless the __module_name_stub__ token is also predefined, in which case
// no module def is compiled at all. That might be appropriate if e.g. a parent module higher in the design hierarchy is stubbed out, and then either def of the lower module would be a nuisance implicit top-level instance.
`ifdef __proc_subsys__

module proc_subsys (
  input reset_n,
  input clk,
  output [1:0] periph_htrans,
  output [2:0] periph_hburst,
  output [2:0] periph_hsize,
  output [3:0] periph_hprot,
  output periph_hmastlock,
  output [proc_subsys_verif_param_pkg::HADDR-1:0] periph_haddr,
  output periph_hwrite,
  output [proc_subsys_verif_param_pkg::HDATA-1:0] periph_hwdata,
  input [proc_subsys_verif_param_pkg::HDATA-1:0] periph_hrdata,
  input periph_hresp,
  input periph_hready,
  input dma_psel,
  input dma_penable,
  input [2:0] dma_pprot,
  input [proc_subsys_verif_param_pkg::PADDR-1:0] dma_paddr,
  input dma_pwrite,
  input [proc_subsys_verif_param_pkg::PDATA-1:0] dma_pwdata,
  input [(proc_subsys_verif_param_pkg::PDATA>>3)-1:0] dma_pstrb,
  output [proc_subsys_verif_param_pkg::PDATA-1:0] dma_prdata,
  output dma_pslverr,
  output dma_pready
);

  // Weak default drives on all output ports.
  assign (pull1, pull0) periph_htrans = '0;
  assign (pull1, pull0) periph_hburst = '0;
  assign (pull1, pull0) periph_hsize = '0;
  assign (pull1, pull0) periph_hprot = '0;
  assign (pull1, pull0) periph_hmastlock = '0;
  assign (pull1, pull0) periph_haddr = '0;
  assign (pull1, pull0) periph_hwrite = '0;
  assign (pull1, pull0) periph_hwdata = '0;
  assign (pull1, pull0) dma_prdata = '0;
  assign (pull1, pull0) dma_pslverr = '0;
  assign (pull1, pull0) dma_pready = '0;

`ifdef __proc_subsys_stub_lumpy__
  cpu cpu_0 ();

  dma dma_0 ();

  mem#(.ADDR(18), .DATA(32)) mem_0 ();

  ahb_fabric#(.MST(2), .SLV(2), .MST_ADDR(32), .SLV_ADDR(24), .DATA(32), .BURST_LOCK(0)) ahb_fabric_0 ();
`endif
endmodule

`endif
`endif
