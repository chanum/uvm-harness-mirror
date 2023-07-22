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

`ifndef __verilab_core_env__
`define __verilab_core_env__

class verilab_core_env extends uvm_env;

  proc_subsys_env proc_subsys_envs[string];
  periph_subsys_env periph_subsys_envs[string];
  ahb2apb_env ahb2apb_envs[string];

  clk_rst_agent clk_rst_agents[string];
  i2c_agent i2c_agents[string];
  gpio_agent gpio_agents[string];

  verilab_core_env_cfg cfg;
  verilab_core_pharness_base harness;
  verilab_core_vseqr vseqr;

  `uvm_component_utils_begin(verilab_core_env)
  `uvm_component_utils_end

  function new(string name = "verilab_core_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (cfg.role != BLIND) begin
      if (! uvm_config_db#(verilab_core_pharness_base)::get(this, "", "harness", harness)) begin
        `uvm_fatal("build_phase", "No verilab_core_pharness_base 'harness' in uvm_config_db")
      end
      vseqr = verilab_core_vseqr::type_id::create("vseqr", this);

      clk_rst_agents["clk_rst_if"] = clk_rst_agent::type_id::create("clk_rst_if", this);
      if (! uvm_config_db#(virtual clk_rst_interface)::get(this, "", "clk_rst_if", clk_rst_agents["clk_rst_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual clk_rst_interface 'clk_rst_if' in uvm_config_db")
      end
      clk_rst_agents["clk_rst_if"].cfg = clk_rst_vip_cfg::type_id::create("clk_rst_if_cfg");

      gpio_agents["gpio_if"] = gpio_agent::type_id::create("gpio_if", this);
      if (! uvm_config_db#(virtual gpio_interface)::get(this, "", "gpio_if", gpio_agents["gpio_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual gpio_interface 'gpio_if' in uvm_config_db")
      end
      gpio_agents["gpio_if"].cfg = gpio_vip_cfg::type_id::create("gpio_if_cfg");

      i2c_agents["i2c_if"] = i2c_agent::type_id::create("i2c_if", this);
      if (! uvm_config_db#(virtual i2c_interface)::get(this, "", "i2c_if", i2c_agents["i2c_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual i2c_interface 'i2c_if' in uvm_config_db")
      end
      i2c_agents["i2c_if"].cfg = i2c_vip_cfg::type_id::create("i2c_if_cfg");

      if (cfg.role == ACTING_AS) begin
        gpio_agents["gpio_if"].is_active = UVM_ACTIVE; gpio_agents["gpio_if"].cfg.role = gpio_pkg::REQUESTER;
        i2c_agents["i2c_if"].is_active = UVM_ACTIVE;
      end
      else if (cfg.role == ACTING_ON) begin
        clk_rst_agents["clk_rst_if"].is_active = UVM_ACTIVE; clk_rst_agents["clk_rst_if"].cfg.freq = cfg.clk_freq;
        gpio_agents["gpio_if"].is_active = UVM_ACTIVE; gpio_agents["gpio_if"].cfg.role = gpio_pkg::RESPONDER;
        i2c_agents["i2c_if"].is_active = UVM_ACTIVE;
      end
    end

    foreach (cfg.proc_subsys_env_cfgs[e]) begin proc_subsys_envs[e] = proc_subsys_env::type_id::create(e, this); proc_subsys_envs[e].cfg = cfg.proc_subsys_env_cfgs[e]; end
    foreach (cfg.periph_subsys_env_cfgs[e]) begin periph_subsys_envs[e] = periph_subsys_env::type_id::create(e, this); periph_subsys_envs[e].cfg = cfg.periph_subsys_env_cfgs[e]; end
    foreach (cfg.ahb2apb_env_cfgs[e]) begin ahb2apb_envs[e] = ahb2apb_env::type_id::create(e, this); ahb2apb_envs[e].cfg = cfg.ahb2apb_env_cfgs[e]; end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  virtual task run_phase(uvm_phase phase);
  endtask
endclass

`endif

