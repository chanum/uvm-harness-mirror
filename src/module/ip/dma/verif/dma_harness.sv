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

`ifndef __dma_harness__
`define __dma_harness__
// Harness files are read before stub files. The only reason a stub compile token would already be defined is if the real and stub module defs are both being suppressed, in which case the harness def must also be suppressed, since it will have nowhere to bind.
`ifndef __dma_stub__

interface dma_harness();

  import dma_pkg::*;

  clk_rst_interface clk_rst_if (
    .reset_n (dma.reset_n),
    .clk     (dma.clk)
  );

  assign (pull0, pull1) ahb_if.hsel = 1'b1;
  assign (pull0, pull1) dma.hready = ahb_if.hreadyout;
  ahb_interface ahb_if(
    .hreset_n  (dma.reset_n),
    .hclk      (dma.clk),
    .htrans    (dma.htrans),
    .hburst    (dma.hburst),
    .hsize     (dma.hsize),
    .hmastlock (dma.hmastlock),
    .hprot     (dma.hprot),
    .haddr     (dma.haddr),
    .hwrite    (dma.hwrite),
    .hwdata    (dma.hwdata),
    .hrdata    (dma.hrdata),
    .hresp     (dma.hresp),
    .hready    (dma.hready)
  );

  apb_interface apb_if (
    .preset_n (dma.reset_n),
    .pclk     (dma.clk),
    .psel     (dma.psel),
    .penable  (dma.penable),
    .pprot    (dma.pprot),
    .paddr    (dma.paddr),
    .pwrite   (dma.pwrite),
    .pstrb    (dma.pstrb),
    .pwdata   (dma.pwdata),
    .prdata   (dma.prdata),
    .pslverr  (dma.pslverr),
    .pready   (dma.pready)
  );

  class dma_pharness extends dma_pharness_base;
    function new(string name = "dma_pharness");
      super.new(name);
    endfunction
  endclass
  dma_pharness pharness = new($sformatf("%m"));

  initial begin
    automatic string path = autopublish_path(pharness.get_name());
    publish_vifs(path);
  end

  function automatic void publish_vifs(string path);
    uvm_config_db#(virtual clk_rst_interface)::set(null, path, "clk_rst_if", clk_rst_if);
    uvm_config_db#(virtual apb_interface)::set(null, path, "apb_if", apb_if);
    uvm_config_db#(virtual ahb_interface)::set(null, path, "ahb_if", ahb_if);
    uvm_config_db#(dma_pharness_base)::set(null, path, "harness", pharness);
  endfunction
endinterface

bind dma dma_harness harness();

`endif
`endif

