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

`ifndef __proc_subsys_env__
`define __proc_subsys_env__

class proc_subsys_env extends uvm_env;

  ahb_fabric_env ahb_fabric_envs[string];
  mem_env mem_envs[string];
  dma_env dma_envs[string];
  cpu_env cpu_envs[string];

  clk_rst_agent clk_rst_agents[string];
  ahb_agent ahb_agents[string];
  apb_agent apb_agents[string];

  proc_subsys_env_cfg cfg;
  proc_subsys_pharness_base harness;
  proc_subsys_vseqr vseqr;

  `uvm_component_utils_begin(proc_subsys_env)
  `uvm_component_utils_end

  function new(string name = "proc_subsys_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (cfg.role != BLIND) begin
      if (! uvm_config_db#(proc_subsys_pharness_base)::get(this, "", "harness", harness)) begin
        `uvm_fatal("build_phase", "No proc_subsys_pharness_base 'harness' in uvm_config_db")
      end
      vseqr = proc_subsys_vseqr::type_id::create("vseqr", this);

      clk_rst_agents["clk_rst_if"] = clk_rst_agent::type_id::create("clk_rst_if", this);
      if (! uvm_config_db#(virtual clk_rst_interface)::get(this, "", "clk_rst_if", clk_rst_agents["clk_rst_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual clk_rst_interface 'clk_rst_if' in uvm_config_db")
      end
      clk_rst_agents["clk_rst_if"].cfg = clk_rst_vip_cfg::type_id::create("clk_rst_if_cfg");

      ahb_agents["periph_ahb_if"] = ahb_agent::type_id::create("periph_ahb_if", this);
      if (! uvm_config_db#(virtual ahb_interface)::get(this, "", "periph_ahb_if", ahb_agents["periph_ahb_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual ahb_interface 'periph_ahb_if' in uvm_config_db")
      end
      ahb_agents["periph_ahb_if"].cfg = ahb_vip_cfg::type_id::create("periph_ahb_if_cfg");
      ahb_agents["periph_ahb_if"].cfg.actual_addr_bus_bits = 24; ahb_agents["periph_ahb_if"].cfg.actual_data_bus_bits = 32;

      apb_agents["dma_apb_if"] = apb_agent::type_id::create("dma_apb_if", this);
      if (! uvm_config_db#(virtual apb_interface)::get(this, "", "dma_apb_if", apb_agents["dma_apb_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual apb_interface 'dma_apb_if' in uvm_config_db")
      end
      apb_agents["dma_apb_if"].cfg = apb_vip_cfg::type_id::create("dma_apb_if_cfg");
      apb_agents["dma_apb_if"].cfg.actual_addr_bus_bits = 8; apb_agents["dma_apb_if"].cfg.actual_data_bus_bits = 32;

      if (cfg.role == ACTING_AS) begin
        ahb_agents["periph_ahb_if"].is_active = UVM_ACTIVE; ahb_agents["periph_ahb_if"].cfg.role = ahb_pkg::REQUESTER;
        apb_agents["dma_apb_if"].is_active = UVM_ACTIVE; apb_agents["dma_apb_if"].cfg.role = apb_pkg::RESPONDER;
      end
      else if (cfg.role == ACTING_ON) begin
        clk_rst_agents["clk_rst_if"].is_active = UVM_ACTIVE; clk_rst_agents["clk_rst_if"].cfg.freq = cfg.clk_freq;
        ahb_agents["periph_ahb_if"].is_active = UVM_ACTIVE; ahb_agents["periph_ahb_if"].cfg.role = ahb_pkg::RESPONDER;
        apb_agents["dma_apb_if"].is_active = UVM_ACTIVE; apb_agents["dma_apb_if"].cfg.role = apb_pkg::REQUESTER;
      end
    end

    foreach (cfg.ahb_fabric_env_cfgs[e]) begin ahb_fabric_envs[e] = ahb_fabric_env::type_id::create(e, this); ahb_fabric_envs[e].cfg = cfg.ahb_fabric_env_cfgs[e]; end
    foreach (cfg.mem_env_cfgs[e]) begin mem_envs[e] = mem_env::type_id::create(e, this); mem_envs[e].cfg = cfg.mem_env_cfgs[e]; end
    foreach (cfg.dma_env_cfgs[e]) begin dma_envs[e] = dma_env::type_id::create(e, this); dma_envs[e].cfg = cfg.dma_env_cfgs[e]; end
    foreach (cfg.cpu_env_cfgs[e]) begin cpu_envs[e] = cpu_env::type_id::create(e, this); cpu_envs[e].cfg = cfg.cpu_env_cfgs[e]; end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  virtual task run_phase(uvm_phase phase);
  endtask
endclass

`endif

