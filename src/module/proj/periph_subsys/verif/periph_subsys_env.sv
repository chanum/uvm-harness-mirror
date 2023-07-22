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

`ifndef __periph_subsys_env__
`define __periph_subsys_env__

class periph_subsys_env extends uvm_env;

  apb_fabric_env apb_fabric_envs[string];
  gpio_env gpio_envs[string];
  i2c_env i2c_envs[string];

  clk_rst_agent clk_rst_agents[string];
  gpio_agent gpio_agents[string];
  i2c_agent i2c_agents[string];
  apb_agent apb_agents[string];

  periph_subsys_env_cfg cfg;
  periph_subsys_pharness_base harness;
  periph_subsys_vseqr vseqr;

  `uvm_component_utils_begin(periph_subsys_env)
  `uvm_component_utils_end

  function new(string name = "periph_subsys_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (cfg.role != BLIND) begin
      if (! uvm_config_db#(periph_subsys_pharness_base)::get(this, "", "harness", harness)) begin
        `uvm_fatal("build_phase", "No periph_subsys_pharness_base 'harness' in uvm_config_db")
      end
      vseqr = periph_subsys_vseqr::type_id::create("vseqr", this);

      clk_rst_agents["pclk_rst_if"] = clk_rst_agent::type_id::create("pclk_rst_if", this);
      if (! uvm_config_db#(virtual clk_rst_interface)::get(this, "", "pclk_rst_if", clk_rst_agents["pclk_rst_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual clk_rst_interface 'pclk_rst_if' in uvm_config_db")
      end
      clk_rst_agents["pclk_rst_if"].cfg = clk_rst_vip_cfg::type_id::create("pclk_rst_if_cfg");

      apb_agents["proc_apb_if"] = apb_agent::type_id::create("proc_apb_if", this);
      if (! uvm_config_db#(virtual apb_interface)::get(this, "", "proc_apb_if", apb_agents["proc_apb_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual apb_interface 'proc_apb_if' in uvm_config_db")
      end
      apb_agents["proc_apb_if"].cfg = apb_vip_cfg::type_id::create("proc_apb_if_cfg");
      apb_agents["proc_apb_if"].cfg.actual_addr_bus_bits = 24; apb_agents["proc_apb_if"].cfg.actual_data_bus_bits = 32;

      apb_agents["dma_apb_if"] = apb_agent::type_id::create("dma_apb_if", this);
      if (! uvm_config_db#(virtual apb_interface)::get(this, "", "dma_apb_if", apb_agents["dma_apb_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual apb_interface 'dma_apb_if' in uvm_config_db")
      end
      apb_agents["dma_apb_if"].cfg = apb_vip_cfg::type_id::create("dma_apb_if_cfg");
      apb_agents["dma_apb_if"].cfg.actual_addr_bus_bits = 8; apb_agents["dma_apb_if"].cfg.actual_data_bus_bits = 32;

      gpio_agents["gpio_if"] = gpio_agent::type_id::create("gpio_if", this);
      if (! uvm_config_db#(virtual gpio_interface)::get(this, "", "gpio_if", gpio_agents["gpio_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual gpio_interface 'gpio_if' in uvm_config_db")
      end
      gpio_agents["gpio_if"].cfg = gpio_vip_cfg::type_id::create("gpio_if_cfg");

      i2c_agents["i2c_if"] = i2c_agent::type_id::create("i2c_if", this);
      if (! uvm_config_db#(virtual i2c_interface)::get(this, "", "i2c_if", i2c_agents["i2c_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual i2c_interface 'i2c_if' in uvm_config_db")
      end
      i2c_agents["pi2c_if"].cfg = i2c_vip_cfg::type_id::create("pi2c_if_cfg");

      if (cfg.role == ACTING_AS) begin
        apb_agents["proc_apb_if"].is_active = UVM_ACTIVE; apb_agents["proc_apb_if"].cfg.role = apb_pkg::RESPONDER;
        apb_agents["dma_apb_if"].is_active = UVM_ACTIVE; apb_agents["dma_apb_if"].cfg.role = apb_pkg::REQUESTER;
        gpio_agents["gpio_if"].is_active = UVM_ACTIVE; gpio_agents["gpio_if"].cfg.role = gpio_pkg::REQUESTER;
        i2c_agents["i2c_if"].is_active = UVM_ACTIVE;
      end
      else if (cfg.role == ACTING_ON) begin
        clk_rst_agents["pclk_rst_if"].is_active = UVM_ACTIVE; clk_rst_agents["pclk_rst_if"].cfg.freq = cfg.pclk_freq;
        apb_agents["proc_apb_if"].is_active = UVM_ACTIVE; apb_agents["proc_apb_if"].cfg.role = apb_pkg::REQUESTER;
        apb_agents["dma_apb_if"].is_active = UVM_ACTIVE; apb_agents["dma_apb_if"].cfg.role = apb_pkg::RESPONDER;
        gpio_agents["gpio_if"].is_active = UVM_ACTIVE; gpio_agents["gpio_if"].cfg.role = gpio_pkg::RESPONDER;
        i2c_agents["i2c_if"].is_active = UVM_ACTIVE;
      end
    end

    foreach (cfg.apb_fabric_env_cfgs[e]) begin apb_fabric_envs[e] = apb_fabric_env::type_id::create(e, this); apb_fabric_envs[e].cfg = cfg.apb_fabric_env_cfgs[e]; end
    foreach (cfg.gpio_env_cfgs[e]) begin gpio_envs[e] = gpio_env::type_id::create(e, this); gpio_envs[e].cfg = cfg.gpio_env_cfgs[e]; end
    foreach (cfg.i2c_env_cfgs[e]) begin i2c_envs[e] = i2c_env::type_id::create(e, this); i2c_envs[e].cfg = cfg.i2c_env_cfgs[e]; end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  virtual task run_phase(uvm_phase phase);
  endtask
endclass

`endif

