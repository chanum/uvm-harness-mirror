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

`ifndef __arb_harness__
`define __arb_harness__
// Harness files are read before stub files. The only reason a stub compile token would already be defined is if the real and stub module defs are both being suppressed, in which case the harness def must also be suppressed, since it will have nowhere to bind.
`ifndef __arb_stub__

interface arb_harness#(WAY = 2) (); // Harness doesn't use width param itself (uses fixed max width), but makes available to testbench components.

  import arb_mod_pkg::*;

  clk_rst_interface clk_rst_if (
    .reset_n (arb.reset_n),
    .clk (arb.clk)
  );

  arb_interface arb_if (
    .reset_n (arb.reset_n),
    .clk     (arb.clk),
    .req     (arb.req),
    .lock    (arb.lock),
    .ack     (arb.ack),
    .gnt     (arb.gnt),
    .owner   (arb.owner)
  );

  class arb_pharness extends arb_pharness_base;
    function new(string name = "arb_pharness");
      super.new(name);
      WAY = arb_harness.WAY;
    endfunction
  endclass
  arb_pharness pharness = new($sformatf("%m"));

  initial begin
    automatic string path = autopublish_path(pharness.get_name());
    publish_vifs(path);
  end

  function automatic void publish_vifs(string path);
    uvm_config_db#(virtual clk_rst_interface)::set(null, path, "clk_rst_if", clk_rst_if);
    uvm_config_db#(virtual arb_interface)::set(null, path, "arb_if", arb_if);
    uvm_config_db#(arb_pharness_base)::set(null, path, "harness", pharness);
  endfunction
endinterface

bind arb arb_harness#(.WAY(WAY)) harness();

`endif
`endif

