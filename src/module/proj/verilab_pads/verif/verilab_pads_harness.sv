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

`ifndef __verilab_pads_harness__
`define __verilab_pads_harness__
// Harness files are read before stub files. The only reason a stub compile token would already be defined is if the real and stub module defs are both being suppressed, in which case the harness def must also be suppressed, since it will have nowhere to bind.
`ifndef __verilab_pads_stub__

interface verilab_pads_harness();

  import verilab_pads_pkg::*;

  clk_rst_interface clk_rst_if(
    .reset_n (verilab_pads.reset_n),
    .clk (verilab_pads.clk)
  );

  //gpioz_interface gpioz_if (
  //  .gpio (verilab_chip.gpio)
  //);

  //i2cz_interface i2cz_if (
  //  .i2c_scl (verilab_chip.i2c_scl),
  //  .i2c_sda (verilab_chip.i2c_sda)
  //);

  clk_rst_interface core_clk_rst_if(
    .reset_n (verilab_pads.core_reset_n),
    .clk (verilab_pads.core_clk)
  );

  gpio_interface gpio_if(
    .gpio_i (verilab_pads.core_gpio_in),
    .gpio_o (verilab_pads.core_gpio_out),
    .gpio_e (verilab_pads.core_gpio_en)
  );

  i2c_interface i2c_if (
    .i2c_scl_i (verilab_pads.core_i2c_scl_in),
    .i2c_scl_o (verilab_pads.core_i2c_scl_out),
    .i2c_scl_e (verilab_pads.core_i2c_scl_en),
    .i2c_sda_i (verilab_pads.core_i2c_sda_in),
    .i2c_sda_o (verilab_pads.core_i2c_sda_out),
    .i2c_sda_e (verilab_pads.core_i2c_sda_en)
  );

  class verilab_pads_pharness extends verilab_pads_pharness_base;
    function new(string name = "verilab_pads_pharness");
      super.new(name);
    endfunction
  endclass
  verilab_pads_pharness pharness = new($sformatf("%m"));

  initial begin
    automatic string path = autopublish_path(pharness.get_name());
    publish_vifs(path);
  end

  function automatic void publish_vifs(string path);
    uvm_config_db#(virtual clk_rst_interface)::set(null, path, "clk_rst_if", clk_rst_if);
    //uvm_config_db#(virtual gpioz_interface)::set(null, path, "gpioz_if", gpioz_if);
    //uvm_config_db#(virtual i2cz_interface)::set(null, path, "i2cz_if", i2cz_if);
    uvm_config_db#(virtual clk_rst_interface)::set(null, path, "core_clk_rst_if", core_clk_rst_if);
    uvm_config_db#(virtual gpio_interface)::set(null, path, "gpio_if", gpio_if);
    uvm_config_db#(virtual i2c_interface)::set(null, path, "i2c_if", i2c_if);
    uvm_config_db#(verilab_pads_pharness_base)::set(null, path, "harness", pharness);
  endfunction
endinterface

bind verilab_pads verilab_pads_harness harness();

`endif
`endif

