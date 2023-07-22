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

`ifndef __ahb_fabric_stub__
`define __ahb_fabric_stub__
// A stub module def file is always read before its real counterpart, so a predefined __module_name__ token allows the stub to be compiled instead. Unless the __module_name_stub__ token is also predefined, in which case
// no module def is compiled at all. That might be appropriate if e.g. a parent module higher in the design hierarchy is stubbed out, and then either def of the lower module would be a nuisance implicit top-level instance.
`ifdef __ahb_fabric__

module ahb_fabric#(MST = 1, SLV = 1, MST_ADDR = 32, SLV_ADDR = 32, DATA = 32, BURST_LOCK = 0) (
  // BURST_LOCK: 0 = Gnt can be taken away from current owner in the middle of a burst. 1 = Current owner will be given gnt for duration of burst.
  input hreset_n,
  input hclk,
  input  [MST-1:0] mst_hsel,
  input  [MST-1:0][1:0] mst_htrans,
  input  [MST-1:0][2:0] mst_hburst,
  input  [MST-1:0][2:0] mst_hsize,
  input  [MST-1:0][3:0] mst_hprot,
  input  [MST-1:0] mst_hmastlock,
  input  [MST-1:0][ahb_fabric_verif_param_pkg::HADDR-1:0] mst_haddr,
  input  [MST-1:0] mst_hwrite,
  input  [MST-1:0][ahb_fabric_verif_param_pkg::HDATA-1:0] mst_hwdata,
  output [MST-1:0][ahb_fabric_verif_param_pkg::HDATA-1:0] mst_hrdata,
  output [MST-1:0] mst_hresp,
  output [MST-1:0] mst_hreadyout,
  input  [MST-1:0] mst_hready,
  output [SLV-1:0][1:0] slv_htrans,
  output [SLV-1:0][2:0] slv_hburst,
  output [SLV-1:0][2:0] slv_hsize,
  output [SLV-1:0][3:0] slv_hprot,
  output [SLV-1:0] slv_hmastlock,
  output [SLV-1:0][ahb_fabric_verif_param_pkg::HADDR-1:0] slv_haddr,
  output [SLV-1:0] slv_hwrite,
  output [SLV-1:0][ahb_fabric_verif_param_pkg::HDATA-1:0] slv_hwdata,
  input  [SLV-1:0][ahb_fabric_verif_param_pkg::HDATA-1:0] slv_hrdata,
  input  [SLV-1:0] slv_hresp,
  input  [SLV-1:0] slv_hready
  // Every slave port is arbitrated independently, that, is one master only owns one slave at a time.
  // Multiple masters can access multiple slaves in parallel.
);

  assign (pull1, pull0) mst_hrdata = '0;
  assign (pull1, pull0) mst_hresp = {MST{ahb_names_pkg::HRESP_OKAY}};
  assign (pull1, pull0) mst_hreadyout = '1;
  assign (pull1, pull0) slv_htrans = '0;
  assign (pull1, pull0) slv_hburst = '0;
  assign (pull1, pull0) slv_hsize = '0;
  assign (pull1, pull0) slv_hprot = '0;
  assign (pull1, pull0) slv_hmastlock = '0;
  assign (pull1, pull0) slv_haddr = '0;
  assign (pull1, pull0) slv_hwrite = '0;
  assign (pull1, pull0) slv_hwdata = '0;

`ifdef __ahb_fabric_stub_lumpy__
  for (genvar s = 0; s < SLV; ++s) begin : arb
    arb #(.WAY(MST)) arb_0 ();
  end
`endif
endmodule

`endif
`endif
