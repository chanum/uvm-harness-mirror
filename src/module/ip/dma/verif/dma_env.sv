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

`ifndef __dma_env__
`define __dma_env__

class dma_env extends uvm_env;

  clk_rst_agent clk_rst_agents[string];
  apb_agent apb_agents[string];
  ahb_agent ahb_agents[string];

  dma_env_cfg cfg;
  dma_pharness_base harness;
  dma_vseqr vseqr;

  `uvm_component_utils_begin(dma_env)
  `uvm_component_utils_end

  function new(string name = "dma_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (cfg.role != BLIND) begin
      if (! uvm_config_db#(dma_pharness_base)::get(this, "", "harness", harness)) begin
        `uvm_fatal("build_phase", "No dma_pharness_base 'harness' in uvm_config_db")
      end
      vseqr = dma_vseqr::type_id::create("vseqr", this);

      clk_rst_agents["clk_rst_if"] = clk_rst_agent::type_id::create("clk_rst_if", this);
      if (! uvm_config_db#(virtual clk_rst_interface)::get(this, "", "clk_rst_if", clk_rst_agents["clk_rst_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual clk_rst_interface 'clk_rst_if' in uvm_config_db")
      end
      clk_rst_agents["clk_rst_if"].cfg = clk_rst_vip_cfg::type_id::create("clk_rst_if_cfg");

      ahb_agents["ahb_if"] = ahb_agent::type_id::create("ahb_if", this);
      if (! uvm_config_db#(virtual ahb_interface)::get(this, "", "ahb_if", ahb_agents["ahb_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual ahb_interface 'ahb_if' in uvm_config_db")
      end
      ahb_agents["ahb_if"].cfg = ahb_vip_cfg::type_id::create("ahb_if_cfg");
      ahb_agents["ahb_if"].cfg.actual_addr_bus_bits = 32; ahb_agents["ahb_if"].cfg.actual_data_bus_bits = 32;

      apb_agents["apb_if"] = apb_agent::type_id::create("apb_if", this);
      if (! uvm_config_db#(virtual apb_interface)::get(this, "", "apb_if", apb_agents["apb_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual apb_interface 'apb_if' in uvm_config_db")
      end
      apb_agents["apb_if"].cfg = apb_vip_cfg::type_id::create("apb_if_cfg");
      apb_agents["apb_if"].cfg.actual_addr_bus_bits = 8; apb_agents["apb_if"].cfg.actual_data_bus_bits = 32;

      if (cfg.role == ACTING_AS) begin
        ahb_agents["ahb_if"].is_active = UVM_ACTIVE; ahb_agents["ahb_if"].cfg.role = ahb_pkg::REQUESTER;
        apb_agents["apb_if"].is_active = UVM_ACTIVE; apb_agents["apb_if"].cfg.role = apb_pkg::RESPONDER;
      end
      else if (cfg.role == ACTING_ON) begin
        clk_rst_agents["clk_rst_if"].is_active = UVM_ACTIVE; clk_rst_agents["clk_rst_if"].cfg.freq = cfg.clk_freq;
        ahb_agents["ahb_if"].is_active = UVM_ACTIVE; ahb_agents["ahb_if"].cfg.role = ahb_pkg::RESPONDER;
        apb_agents["apb_if"].is_active = UVM_ACTIVE; apb_agents["apb_if"].cfg.role = apb_pkg::REQUESTER;
      end
    end
  endfunction
endclass

`endif

