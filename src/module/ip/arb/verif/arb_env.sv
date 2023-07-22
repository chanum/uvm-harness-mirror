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

`ifndef __arb_env__
`define __arb_env__

class arb_env extends uvm_env;

  clk_rst_agent clk_rst_agents[string];
  arb_agent arb_agents[string];

  arb_env_cfg cfg;
  arb_pharness_base harness;
  arb_vseqr vseqr;

  `uvm_component_utils_begin(arb_env)
  `uvm_component_utils_end

  function new(string name = "arb_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (cfg.role != BLIND) begin
      if (! uvm_config_db#(arb_pharness_base)::get(this, "", "harness", harness)) begin
        `uvm_fatal("build_phase", "No arb_pharness_base 'harness' in uvm_config_db")
      end
      vseqr = arb_vseqr::type_id::create("vseqr", this);

      clk_rst_agents["clk_rst_if"] = clk_rst_agent::type_id::create("clk_rst_if", this);
      if (! uvm_config_db#(virtual clk_rst_interface)::get(this, "", "clk_rst_if", clk_rst_agents["clk_rst_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual clk_rst_interface 'clk_rst_if' in uvm_config_db")
      end
      clk_rst_agents["clk_rst_if"].cfg = clk_rst_vip_cfg::type_id::create("clk_rst_if_cfg");

      arb_agents["arb_if"] = arb_agent::type_id::create("arb_if", this);
      if (! uvm_config_db#(virtual arb_interface)::get(this, "", "arb_if", arb_agents["arb_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual arb_interface 'arb_if' in uvm_config_db")
      end
      arb_agents["arb_if"].cfg = arb_vip_cfg::type_id::create("arb_if_cfg");
      arb_agents["arb_if"].cfg.actual_ways = harness.WAY;

      if (cfg.role == ACTING_AS) begin
        arb_agents["arb_if"].is_active = UVM_ACTIVE; arb_agents["arb_if"].cfg.role = arb_pkg::RESPONDER;
      end
      else if (cfg.role == ACTING_ON) begin
        clk_rst_agents["clk_rst_if"].is_active = UVM_ACTIVE; clk_rst_agents["clk_rst_if"].cfg.freq = cfg.clk_freq;
        arb_agents["arb_if"].is_active = UVM_ACTIVE; arb_agents["arb_if"].cfg.role = arb_pkg::REQUESTER;
      end
    end
  endfunction
endclass

`endif

