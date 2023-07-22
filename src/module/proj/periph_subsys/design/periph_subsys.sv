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

`ifndef __periph_subsys__
`define __periph_subsys__

module periph_subsys (
  input preset_n,
  input pclk,
  input proc_psel,
  input proc_penable,
  input [2:0] proc_pprot,
  input [23:0] proc_paddr,
  input proc_pwrite,
  input [31:0] proc_pwdata,
  input [3:0] proc_pstrb,
  output [31:0] proc_prdata,
  output proc_pslverr,
  output proc_pready,
  output dma_psel,
  output dma_penable,
  output [2:0] dma_pprot,
  output [15:0] dma_paddr,
  output dma_pwrite,
  output [31:0] dma_pwdata,
  output [3:0] dma_pstrb,
  input [31:0] dma_prdata,
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

  wire i2c_mst_psel;
  wire i2c_mst_penable;
  wire [2:0] i2c_mst_pprot;
  wire [23:0] i2c_mst_paddr;
  wire i2c_mst_pwrite;
  wire [31:0] i2c_mst_pwdata;
  wire [3:0] i2c_mst_pstrb;
  wire [31:0] i2c_mst_prdata;
  wire i2c_mst_pslverr;
  wire i2c_mst_pready;
  wire i2c_slv_psel, gpio_psel;
  wire i2c_slv_penable, gpio_penable;
  wire [2:0] i2c_slv_pprot, gpio_pprot;
  wire [15:0] i2c_slv_paddr, gpio_paddr;
  wire i2c_slv_pwrite, gpio_pwrite;
  wire [31:0] i2c_slv_pwdata, gpio_pwdata;
  wire [3:0] i2c_slv_pstrb, gpio_pstrb;
  wire [31:0] i2c_slv_prdata, gpio_prdata;
  wire i2c_slv_pslverr, gpio_pslverr;
  wire i2c_slv_pready, gpio_pready;

  apb_fabric#(.MST(2), .SLV(3), .MST_ADDR(24), .SLV_ADDR(16), .DATA(32)) apb_fabric_0 (
    .preset_n (preset_n),
    .pclk (pclk),
    .mst_psel ({proc_psel, i2c_mst_psel}),
    .mst_penable ({proc_penable, i2c_mst_penable}),
    .mst_pprot ({proc_pprot, i2c_mst_pprot}),
    .mst_paddr ({proc_paddr, i2c_mst_paddr}),
    .mst_pwrite ({proc_pwrite, i2c_mst_pwrite}),
    .mst_pwdata ({proc_pwdata, i2c_mst_pwdata}),
    .mst_pstrb ({proc_pstrb, i2c_mst_pstrb}),
    .mst_prdata ({proc_prdata, i2c_mst_prdata}),
    .mst_pslverr ({proc_pslverr, i2c_mst_pslverr}),
    .mst_pready ({proc_pready, i2c_mst_pready}),
    .slv_psel ({dma_psel, i2c_slv_psel, gpio_psel}),
    .slv_penable ({dma_penable, i2c_slv_penable, gpio_penable}),
    .slv_pprot ({dma_pprot, i2c_slv_pprot, gpio_pprot}),
    .slv_paddr ({dma_paddr, i2c_slv_paddr, gpio_paddr}),
    .slv_pwrite ({dma_pwrite, i2c_slv_pwrite, gpio_pwrite}),
    .slv_pwdata ({dma_pwdata, i2c_slv_pwdata, gpio_pwdata}),
    .slv_pstrb ({dma_pstrb, i2c_slv_pstrb, gpio_pstrb}),
    .slv_prdata ({dma_prdata, i2c_slv_prdata, gpio_prdata}),
    .slv_pslverr ({dma_pslverr, i2c_slv_pslverr, gpio_pslverr}),
    .slv_pready ({dma_pready, i2c_slv_pready, gpio_pready})
  );

  i2c#(.MST_ADDR(24), .SLV_DATA(32)) i2c_0 (
    .i2c_scl_i (i2c_scl_i),
    .i2c_scl_o (i2c_scl_o),
    .i2c_scl_e (i2c_scl_e),
    .i2c_sda_i (i2c_sda_i),
    .i2c_sda_o (i2c_sda_o),
    .i2c_sda_e (i2c_sda_e),
    .preset_n (preset_n),
    .pclk (pclk),
    .mst_psel (i2c_mst_psel),
    .mst_penable (i2c_mst_penable),
    .mst_pprot (i2c_mst_pprot),
    .mst_paddr (i2c_mst_paddr),
    .mst_pwrite (i2c_mst_pwrite),
    .mst_pwdata (i2c_mst_pwdata),
    .mst_pstrb (i2c_mst_pstrb),
    .mst_prdata (i2c_mst_prdata),
    .mst_pslverr (i2c_mst_pslverr),
    .mst_pready (i2c_mst_pready),
    .slv_psel (i2c_slv_psel),
    .slv_penable (i2c_slv_penable),
    .slv_pprot (i2c_slv_pprot),
    .slv_paddr (i2c_slv_paddr),
    .slv_pwrite (i2c_slv_pwrite),
    .slv_pwdata (i2c_slv_pwdata),
    .slv_pstrb (i2c_slv_pstrb),
    .slv_prdata (i2c_slv_prdata),
    .slv_pslverr (i2c_slv_pslverr),
    .slv_pready (i2c_slv_pready)
  );

  gpio#(.GPIO(32)) gpio_0 (
    .preset_n (preset_n),
    .pclk (pclk),
    .psel (gpio_psel),
    .penable (gpio_penable),
    .pprot (gpio_pprot),
    .paddr (gpio_paddr),
    .pwrite (gpio_pwrite),
    .pwdata (gpio_pwdata),
    .pstrb (gpio_pstrb),
    .prdata (gpio_prdata),
    .pslverr (gpio_pslverr),
    .pready (gpio_pready),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_e (gpio_e)
  );
endmodule

`endif

