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

`ifndef __gpio_harness__
`define __gpio_harness__
// Harness files are read before stub files. The only reason a stub compile token would already be defined is if the real and stub module defs are both being suppressed, in which case the harness def must also be suppressed, since it will have nowhere to bind.
`ifndef __gpio_stub__

interface gpio_harness#(GPIO = 32) (); // Harness doesn't use instance width param(s) itself (uses proj max width param(s)), but makes available to testbench components.

  import gpio_mod_pkg::*;

  clk_rst_interface clk_rst_if (
    .reset_n (gpio.preset_n),
    .clk (gpio.pclk)
  );

  apb_interface apb_if (
    .preset_n (gpio.preset_n),
    .pclk (gpio.pclk),
    .psel (gpio.psel),
    .penable (gpio.penable),
    .pprot (gpio.pprot),
    .paddr (gpio.paddr),
    .pwrite (gpio.pwrite),
    .pwdata (gpio.pwdata),
    .pstrb (gpio.pstrb),
    .prdata (gpio.prdata),
    .pslverr (gpio.pslverr),
    .pready (gpio.pready)
  );

  gpio_interface gpio_if (
    .gpio_i (gpio.gpio_i),
    .gpio_o (gpio.gpio_o),
    .gpio_e (gpio.gpio_e)
  );

  class gpio_pharness extends gpio_pharness_base;
    function new(string name = "gpio_pharness");
      super.new(name);
      GPIO = gpio_harness.GPIO;
    endfunction
  endclass
  gpio_pharness pharness = new($sformatf("%m"));

  initial begin
    automatic string path = autopublish_path(pharness.get_name());
    publish_vifs(path);
  end

  function automatic void publish_vifs(string path);
    uvm_config_db#(virtual clk_rst_interface)::set(null, path, "clk_rst_if", clk_rst_if);
    uvm_config_db#(virtual apb_interface)::set(null, path, "apb_if", apb_if);
    uvm_config_db#(virtual gpio_interface)::set(null, path, "gpio_if", gpio_if);
    uvm_config_db#(gpio_pharness_base)::set(null, path, "harness", pharness);
  endfunction
endinterface

bind gpio gpio_harness#(.GPIO(GPIO)) harness();

`endif
`endif

