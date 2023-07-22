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

`ifndef __verilab_core_harness__
`define __verilab_core_harness__
// Harness files are read before stub files. The only reason a stub compile token would already be defined is if the real and stub module defs are both being suppressed, in which case the harness def must also be suppressed, since it will have nowhere to bind.
`ifndef __verilab_core_stub__

interface verilab_core_harness();

  import verilab_core_pkg::*;

  clk_rst_interface clk_rst_if (
    .reset_n (verilab_core.reset_n),
    .clk (verilab_core.clk)
  );

  gpio_interface gpio_if (
    .gpio_i (verilab_core.gpio_i),
    .gpio_o (verilab_core.gpio_o),
    .gpio_e (verilab_core.gpio_e)
  );

  i2c_interface i2c_if (
    .i2c_scl_i (verilab_core.i2c_scl_i),
    .i2c_scl_o (verilab_core.i2c_scl_o),
    .i2c_scl_e (verilab_core.i2c_scl_e),
    .i2c_sda_i (verilab_core.i2c_sda_i),
    .i2c_sda_o (verilab_core.i2c_sda_o),
    .i2c_sda_e (verilab_core.i2c_sda_e)
  );

  class verilab_core_pharness extends verilab_core_pharness_base;
    function new(string name = "verilab_core_pharness");
      super.new(name);
    endfunction
  endclass
  verilab_core_pharness pharness = new($sformatf("%m"));

  initial begin
    automatic string path = autopublish_path(pharness.get_name());
    publish_vifs(path);
  end

  function automatic void publish_vifs(string path);
    uvm_config_db#(virtual clk_rst_interface)::set(null, path, "clk_rst_if", clk_rst_if);
    uvm_config_db#(virtual gpio_interface)::set(null, path, "gpio_if", gpio_if);
    uvm_config_db#(virtual i2c_interface)::set(null, path, "i2c_if", i2c_if);
    uvm_config_db#(verilab_core_pharness_base)::set(null, path, "harness", pharness);
  endfunction
endinterface

bind verilab_core verilab_core_harness harness();

`endif
`endif

