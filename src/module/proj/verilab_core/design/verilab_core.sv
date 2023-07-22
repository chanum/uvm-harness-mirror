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

`ifndef __verilab_core__
`define __verilab_core__

module verilab_core (
  input reset_n,
  input clk,
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

  wire [1:0] htrans;
  wire [2:0] hburst;
  wire [2:0] hsize;
  wire [3:0] hprot;
  wire hmastlock;
  wire [23:0] haddr;
  wire hwrite;
  wire [31:0] hwdata;
  wire [31:0] hrdata;
  wire hresp;
  wire hready;
  wire psel;
  wire penable;
  wire [2:0] pprot;
  wire [23:0] paddr;
  wire pwrite;
  wire [31:0] pwdata;
  wire [3:0] pstrb;
  wire [31:0] prdata;
  wire pslverr;
  wire pready;
  wire dma_psel;
  wire dma_penable;
  wire [2:0] dma_pprot;
  wire [7:0] dma_paddr;
  wire dma_pwrite;
  wire [31:0] dma_pwdata;
  wire [3:0] dma_pstrb;
  wire [31:0] dma_prdata;
  wire dma_pslverr;
  wire dma_pready;

  proc_subsys proc_subsys_0 (
    .reset_n (reset_n),
    .clk (clk),
    .periph_htrans (htrans),
    .periph_hburst (hburst),
    .periph_hsize (hsize),
    .periph_hprot (hprot),
    .periph_hmastlock (hmastlock),
    .periph_haddr (haddr),
    .periph_hwrite (hwrite),
    .periph_hwdata (hwdata),
    .periph_hrdata (hrdata),
    .periph_hresp (hresp),
    .periph_hready (hready),
    .dma_psel (dma_psel),
    .dma_penable (dma_penable),
    .dma_pprot (dma_pprot),
    .dma_paddr (dma_paddr),
    .dma_pwrite (dma_pwrite),
    .dma_pwdata (dma_pwdata),
    .dma_pstrb (dma_pstrb),
    .dma_prdata (dma_prdata),
    .dma_pslverr (dma_pslverr),
    .dma_pready (dma_pready)
  );

  ahb2apb#(.ADDR(24), .HDATA(32), .PDATA(32)) ahb2apb_0 (
    .reset_n (reset_n),
    .clk (clk),
    .hsel (1'b1),
    .htrans (htrans),
    .hburst (hburst),
    .hsize (hsize),
    .hprot (hprot),
    .hmastlock (hmastlock),
    .haddr (haddr),
    .hwrite (hwrite),
    .hwdata (hwdata),
    .hrdata (hrdata),
    .hresp (hresp),
    .hreadyout (hready),
    .hready (hready),
    .psel (psel),
    .penable (penable),
    .pprot (pprot),
    .paddr (paddr),
    .pwrite (pwrite),
    .pwdata (pwdata),
    .pstrb (pstrb),
    .prdata (prdata),
    .pslverr (pslverr),
    .pready (pready)
  );

  periph_subsys periph_subsys_0 (
    .preset_n (reset_n),
    .pclk (clk),
    .proc_psel (psel),
    .proc_penable (penable),
    .proc_pprot (pprot),
    .proc_paddr (paddr),
    .proc_pwrite (pwrite),
    .proc_pwdata (pwdata),
    .proc_pstrb (pstrb),
    .proc_prdata (prdata),
    .proc_pslverr (pslverr),
    .proc_pready (pready),
    .dma_psel (dma_psel),
    .dma_penable (dma_penable),
    .dma_pprot (dma_pprot),
    .dma_paddr (dma_paddr),
    .dma_pwrite (dma_pwrite),
    .dma_pwdata (dma_pwdata),
    .dma_pstrb (dma_pstrb),
    .dma_prdata (dma_prdata),
    .dma_pslverr (dma_pslverr),
    .dma_pready (dma_pready),
    .i2c_scl_i (i2c_scl_i),
    .i2c_scl_o (i2c_scl_o),
    .i2c_scl_e (i2c_scl_e),
    .i2c_sda_i (i2c_sda_i),
    .i2c_sda_o (i2c_sda_o),
    .i2c_sda_e (i2c_sda_e),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_e (gpio_e)
  );
endmodule

`endif

