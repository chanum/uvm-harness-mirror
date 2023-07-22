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

`ifndef __proc_subsys_harness__
`define __proc_subsys_harness__
// Harness files are read before stub files. The only reason a stub compile token would already be defined is if the real and stub module defs are both being suppressed, in which case the harness def must also be suppressed, since it will have nowhere to bind.
`ifndef __proc_subsys_stub__

interface proc_subsys_harness();

  import proc_subsys_pkg::*;

  clk_rst_interface clk_rst_if (
    .reset_n (proc_subsys.reset_n),
    .clk (proc_subsys.clk)
  );

  ahb_interface periph_ahb_if(
    .hreset_n  (proc_subsys.reset_n),
    .hclk      (proc_subsys.clk),
    .htrans    (proc_subsys.periph_htrans),
    .hburst    (proc_subsys.periph_hburst),
    .hsize     (proc_subsys.periph_hsize),
    .hmastlock (proc_subsys.periph_hmastlock),
    .hprot     (proc_subsys.periph_hprot),
    .haddr     (proc_subsys.periph_haddr),
    .hwrite    (proc_subsys.periph_hwrite),
    .hwdata    (proc_subsys.periph_hwdata),
    .hrdata    (proc_subsys.periph_hrdata),
    .hresp     (proc_subsys.periph_hresp),
    .hready    (proc_subsys.periph_hready)
  );

  apb_interface dma_apb_if (
    .preset_n (proc_subsys.reset_n),
    .pclk     (proc_subsys.clk),
    .psel     (proc_subsys.dma_psel),
    .penable  (proc_subsys.dma_penable),
    .pprot    (proc_subsys.dma_pprot),
    .paddr    (proc_subsys.dma_paddr),
    .pwrite   (proc_subsys.dma_pwrite),
    .pwdata   (proc_subsys.dma_pwdata),
    .pstrb    (proc_subsys.dma_pstrb),
    .prdata   (proc_subsys.dma_prdata),
    .pslverr  (proc_subsys.dma_pslverr),
    .pready   (proc_subsys.dma_pready)
  );

  class proc_subsys_pharness extends proc_subsys_pharness_base;
    function new(string name = "proc_subsys_pharness");
      super.new(name);
    endfunction
  endclass
  proc_subsys_pharness pharness = new($sformatf("%m"));

  initial begin
    automatic string path = autopublish_path(pharness.get_name());
    publish_vifs(path);
  end

  function automatic void publish_vifs(string path);
    uvm_config_db#(virtual clk_rst_interface)::set(null, path, "clk_rst_if", clk_rst_if);
    uvm_config_db#(virtual ahb_interface)::set(null, path, "periph_ahb_if", periph_ahb_if);
    uvm_config_db#(virtual apb_interface)::set(null, path, "dma_apb_if", dma_apb_if);
    uvm_config_db#(proc_subsys_pharness_base)::set(null, path, "harness", pharness);
  endfunction
endinterface

bind proc_subsys proc_subsys_harness harness();

`endif
`endif

