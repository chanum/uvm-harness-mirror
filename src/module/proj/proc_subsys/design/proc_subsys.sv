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

`ifndef __proc_subsys__
`define __proc_subsys__

module proc_subsys (
  input reset_n,
  input clk,
  output [1:0] periph_htrans,
  output [2:0] periph_hburst,
  output [2:0] periph_hsize,
  output [3:0] periph_hprot,
  output periph_hmastlock,
  output [23:0] periph_haddr,
  output periph_hwrite,
  output [31:0] periph_hwdata,
  input [31:0] periph_hrdata,
  input periph_hresp,
  input periph_hready,
  input dma_psel,
  input dma_penable,
  input [2:0] dma_pprot,
  input [7:0] dma_paddr,
  input dma_pwrite,
  input [31:0] dma_pwdata,
  input [3:0] dma_pstrb,
  output [31:0] dma_prdata,
  output dma_pslverr,
  output dma_pready
);

  wire [1:0] cpu_htrans, dma_htrans;
  wire [2:0] cpu_hburst, dma_hburst;
  wire [2:0] cpu_hsize, dma_hsize;
  wire [3:0] cpu_hprot, dma_hprot;
  wire cpu_hmastlock, dma_hmastlock;
  wire [31:0] cpu_haddr, dma_haddr;
  wire cpu_hwrite, dma_hwrite;
  wire [31:0] cpu_hwdata, dma_hwdata;
  wire [31:0] cpu_hrdata, dma_hrdata;
  wire cpu_hresp, dma_hresp;
  wire cpu_hready, dma_hready;
  wire [1:0] mem_htrans;
  wire [2:0] mem_hburst;
  wire [2:0] mem_hsize;
  wire [3:0] mem_hprot;
  wire mem_hmastlock;
  wire [23:0] mem_haddr;
  wire mem_hwrite;
  wire [31:0] mem_hwdata;
  wire [31:0] mem_hrdata;
  wire mem_hresp;
  wire mem_hready;

  cpu cpu_0 (
    .hreset_n (reset_n),
    .hclk (clk),
    .htrans (cpu_htrans),
    .hburst (cpu_hburst),
    .hsize (cpu_hsize),
    .hprot (cpu_hprot),
    .hmastlock (cpu_hmastlock),
    .haddr (cpu_haddr),
    .hwrite (cpu_hwrite),
    .hwdata (cpu_hwdata),
    .hrdata (cpu_hrdata),
    .hresp (cpu_hresp),
    .hready (cpu_hready)
  );

  dma dma_0 (
    .hreset_n (reset_n),
    .hclk (clk),
    .htrans (dma_htrans),
    .hburst (dma_hburst),
    .hsize (dma_hsize),
    .hprot (dma_hprot),
    .hmastlock (dma_hmastlock),
    .haddr (dma_haddr),
    .hwrite (dma_hwrite),
    .hwdata (dma_hwdata),
    .hrdata (dma_hrdata),
    .hresp (dma_hresp),
    .hready (dma_hready),
    .psel (dma_psel),
    .penable (dma_penable),
    .pprot (dma_pprot),
    .paddr (dma_paddr),
    .pwrite (dma_pwrite),
    .pwdata (dma_pwdata),
    .pstrb (dma_pstrb),
    .prdata (dma_prdata),
    .pslverr (dma_pslverr),
    .pready (dma_pready)
  );

  mem#(.ADDR(18), .DATA(32)) mem_0 (
    .hreset_n (reset_n),
    .hclk (clk),
    .hsel (1'b1),
    .htrans (mem_htrans),
    .hburst (mem_hburst),
    .hsize (mem_hsize),
    .hprot (mem_hprot),
    .hmastlock (mem_hmastlock),
    .haddr (mem_haddr),
    .hwrite (mem_hwrite),
    .hwdata (mem_hwdata),
    .hrdata (mem_hrdata),
    .hresp (mem_hresp),
    .hreadyout (mem_hready),
    .hready (mem_hready)
  );

  ahb_fabric#(.MST(2), .SLV(2), .MST_ADDR(32), .SLV_ADDR(24), .DATA(32), .BURST_LOCK(0)) ahb_fabric_0 (
    .hreset_n (reset_n),
    .hclk (clk),
    .mst_hsel ({2{1'b1}}),
    .mst_htrans ({cpu_htrans, dma_htrans}),
    .mst_hburst ({cpu_hburst, dma_hburst}),
    .mst_hsize ({cpu_hsize, dma_hsize}),
    .mst_hprot ({cpu_hprot, dma_hprot}),
    .mst_hmastlock ({cpu_hmastlock, dma_hmastlock}),
    .mst_haddr ({cpu_haddr, dma_haddr}),
    .mst_hwrite ({cpu_hwrite, dma_hwrite}),
    .mst_hwdata ({cpu_hwdata, dma_hwdata}),
    .mst_hrdata ({cpu_hrdata, dma_hrdata}),
    .mst_hresp ({cpu_hresp, dma_hresp}),
    .mst_hreadyout ({cpu_hready, dma_hready}),
    .mst_hready ({cpu_hready, dma_hready}),
    .slv_htrans ({mem_htrans, periph_htrans}),
    .slv_hburst ({mem_hburst, periph_hburst}),
    .slv_hsize ({mem_hsize, periph_hsize}),
    .slv_hprot ({mem_hprot, periph_hprot}),
    .slv_hmastlock ({mem_hmastlock, periph_hmastlock}),
    .slv_haddr ({mem_haddr, periph_haddr}),
    .slv_hwrite ({mem_hwrite, periph_hwrite}),
    .slv_hwdata ({mem_hwdata, periph_hwdata}),
    .slv_hrdata ({mem_hrdata, periph_hrdata}),
    .slv_hresp ({mem_hresp, periph_hresp}),
    .slv_hready ({mem_hready, periph_hready})
  );
endmodule

`endif

