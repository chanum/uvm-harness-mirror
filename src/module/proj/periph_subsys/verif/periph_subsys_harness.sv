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

`ifndef __periph_subsys_harness__
`define __periph_subsys_harness__
// Harness files are read before stub files. The only reason a stub compile token would already be defined is if the real and stub module defs are both being suppressed, in which case the harness def must also be suppressed, since it will have nowhere to bind.
`ifndef __periph_subsys_stub__

interface periph_subsys_harness();

  import periph_subsys_pkg::*;

  clk_rst_interface pclk_rst_if (
    .reset_n (periph_subsys.preset_n),
    .clk (periph_subsys.pclk)
  );

  apb_interface proc_apb_if (
    .preset_n (periph_subsys.preset_n),
    .pclk     (periph_subsys.pclk),
    .psel     (periph_subsys.proc_psel),
    .penable  (periph_subsys.proc_penable),
    .pprot    (periph_subsys.proc_pprot),
    .paddr    (periph_subsys.proc_paddr),
    .pwrite   (periph_subsys.proc_pwrite),
    .pstrb    (periph_subsys.proc_pstrb),
    .pwdata   (periph_subsys.proc_pwdata),
    .prdata   (periph_subsys.proc_prdata),
    .pslverr  (periph_subsys.proc_pslverr),
    .pready   (periph_subsys.proc_pready)
  );

  apb_interface dma_apb_if (
    .preset_n (periph_subsys.preset_n),
    .pclk     (periph_subsys.pclk),
    .psel     (periph_subsys.dma_psel),
    .penable  (periph_subsys.dma_penable),
    .pprot    (periph_subsys.dma_pprot),
    .paddr    (periph_subsys.dma_paddr),
    .pwrite   (periph_subsys.dma_pwrite),
    .pstrb    (periph_subsys.dma_pstrb),
    .pwdata   (periph_subsys.dma_pwdata),
    .prdata   (periph_subsys.dma_prdata),
    .pslverr  (periph_subsys.dma_pslverr),
    .pready   (periph_subsys.dma_pready)
  );

  i2c_interface i2c_if (
    .i2c_scl_i (periph_subsys.i2c_scl_i),
    .i2c_scl_o (periph_subsys.i2c_scl_o),
    .i2c_scl_e (periph_subsys.i2c_scl_e),
    .i2c_sda_i (periph_subsys.i2c_sda_i),
    .i2c_sda_o (periph_subsys.i2c_sda_o),
    .i2c_sda_e (periph_subsys.i2c_sda_e)
  );

  gpio_interface gpio_if (
    .gpio_i (periph_subsys.gpio_i),
    .gpio_o (periph_subsys.gpio_o),
    .gpio_e (periph_subsys.gpio_e)
  );

  class periph_subsys_pharness extends periph_subsys_pharness_base;
    function new(string name = "periph_subsys_pharness");
      super.new(name);
    endfunction
  endclass
  periph_subsys_pharness pharness = new($sformatf("%m"));

  initial begin
    automatic string path = autopublish_path(pharness.get_name());
    publish_vifs(path);
  end

  function automatic void publish_vifs(string path);
    uvm_config_db#(virtual clk_rst_interface)::set(null, path, "pclk_rst_if", pclk_rst_if);
    uvm_config_db#(virtual apb_interface)::set(null, path, "dma_ahb_if", dma_apb_if);
    uvm_config_db#(virtual apb_interface)::set(null, path, "proc_ahb_if", proc_apb_if);
    uvm_config_db#(virtual i2c_interface)::set(null, path, "i2c_if", i2c_if);
    uvm_config_db#(virtual gpio_interface)::set(null, path, "gpio_if", gpio_if);
    uvm_config_db#(periph_subsys_pharness_base)::set(null, path, "harness", pharness);
  endfunction
endinterface

bind periph_subsys periph_subsys_harness harness();

`endif
`endif

