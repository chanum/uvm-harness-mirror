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

`ifndef __i2c_harness__
`define __i2c_harness__
// Harness files are read before stub files. The only reason a stub compile token would already be defined is if the real and stub module defs are both being suppressed, in which case the harness def must also be suppressed, since it will have nowhere to bind.
`ifndef __i2c_stub__

interface i2c_harness#(MST_ADDR, SLV_DATA) (); // Harness doesn't use instance width param(s) itself (uses proj max width param(s)), but makes available to testbench components.

  import i2c_mod_pkg::*;

  clk_rst_interface clk_rst_if (
    .reset_n (i2c.preset_n),
    .clk (i2c.pclk)
  );

  apb_interface mst_apb_if (
    .preset_n (i2c.preset_n),
    .pclk (i2c.pclk),
    .psel (i2c.mst_psel),
    .penable (i2c.mst_penable),
    .pprot (i2c.mst_pprot),
    .paddr (i2c.mst_paddr),
    .pwrite (i2c.mst_pwrite),
    .pwdata (i2c.mst_pwdata),
    .pstrb (i2c.mst_pstrb),
    .prdata (i2c.mst_prdata),
    .pslverr (i2c.mst_pslverr),
    .pready (i2c.mst_pready)
  );

  apb_interface slv_apb_if (
    .preset_n (i2c.preset_n),
    .pclk (i2c.pclk),
    .psel (i2c.slv_psel),
    .penable (i2c.slv_penable),
    .pprot (i2c.slv_pprot),
    .paddr (i2c.slv_paddr),
    .pwrite (i2c.slv_pwrite),
    .pwdata (i2c.slv_pwdata),
    .pstrb (i2c.slv_pstrb),
    .prdata (i2c.slv_prdata),
    .pslverr (i2c.slv_pslverr),
    .pready (i2c.slv_pready)
  );

  i2c_interface i2c_if (
    .i2c_scl_i (i2c.i2c_scl_i),
    .i2c_scl_o (i2c.i2c_scl_o),
    .i2c_scl_e (i2c.i2c_scl_e),
    .i2c_sda_i (i2c.i2c_sda_i),
    .i2c_sda_o (i2c.i2c_sda_o),
    .i2c_sda_e (i2c.i2c_sda_e)
  );

  class i2c_pharness extends i2c_pharness_base;
    function new(string name = "i2c_pharness");
      super.new(name);
      MST_ADDR = i2c_harness.MST_ADDR;
      SLV_DATA = i2c_harness.SLV_DATA;
    endfunction
  endclass
  i2c_pharness pharness = new($sformatf("%m"));

  initial begin
    automatic string path = autopublish_path(pharness.get_name());
    pharness = new($sformatf("%m"));
    publish_vifs(path);
  end

  function automatic void publish_vifs(string path);
    uvm_config_db#(virtual clk_rst_interface)::set(null, path, "clk_rst_if", clk_rst_if);
    uvm_config_db#(virtual apb_interface)::set(null, path, "mst_apb_if", mst_apb_if);
    uvm_config_db#(virtual apb_interface)::set(null, path, "slv_apb_if", slv_apb_if);
    uvm_config_db#(virtual i2c_interface)::set(null, path, "i2c_if", i2c_if);
    uvm_config_db#(i2c_pharness_base)::set(null, path, "harness", pharness);
  endfunction
endinterface

bind i2c i2c_harness#(.MST_ADDR(MST_ADDR), .SLV_DATA(SLV_DATA)) harness();

`endif
`endif

