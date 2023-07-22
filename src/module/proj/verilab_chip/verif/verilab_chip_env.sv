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

`ifndef __verilab_chip_env__
`define __verilab_chip_env__

class verilab_chip_env extends uvm_env;

  verilab_pads_env verilab_pads_envs[string];
  verilab_core_env verilab_core_envs[string];

  clk_rst_agent clk_rst_agents[string];
  //gpioz_agent gpioz_agents[string];
  //i2cz_agent i2cz_agents[string];

  verilab_chip_env_cfg cfg;
  verilab_chip_pharness_base harness;
  verilab_chip_vseqr vseqr;

  `uvm_component_utils_begin(verilab_chip_env)
  `uvm_component_utils_end

  function new(string name = "verilab_chip_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (cfg.role != BLIND) begin
      if (! uvm_config_db#(verilab_chip_pharness_base)::get(this, "", "harness", harness)) begin
        `uvm_fatal("build_phase", "No verilab_chip_pharness_base 'harness' in uvm_config_db")
      end
      vseqr = verilab_chip_vseqr::type_id::create("vseqr", this);

      clk_rst_agents["clk_rst_if"] = clk_rst_agent::type_id::create("clk_rst_if", this);
      if (! uvm_config_db#(virtual clk_rst_interface)::get(this, "", "clk_rst_if", clk_rst_agents["clk_rst_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual clk_rst_interface 'clk_rst_if' in uvm_config_db")
      end
      clk_rst_agents["clk_rst_if"].cfg = clk_rst_vip_cfg::type_id::create("clk_rst_if_cfg");

      //gpioz_agents["gpioz_if"] = gpioz_agent::type_id::create("gpioz_if", this);
      //if (! uvm_config_db#(virtual gpioz_interface)::get(this, "", "gpioz_if", gpioz_agents["gpioz_if"].vif)) begin
      //  `uvm_fatal("build_phase", "No virtual gpioz_interface 'gpioz_if' in uvm_config_db")
      //end
      //gpioz_agents["gpioz_if"].cfg = gpioz_vip_cfg::type_id::create("cfg");

      //i2cz_agents["i2cz_if"] = i2cz_agent::type_id::create("i2cz_if", this);
      //if (! uvm_config_db#(virtual i2cz_interface)::get(this, "", "i2cz_if", i2cz_agents["i2cz_if"].vif)) begin
      //  `uvm_fatal("build_phase", "No virtual i2cz_interface 'i2cz_if' in uvm_config_db")
      //end
      //i2cz_agents["i2cz_if"].cfg = i2cz_vip_cfg::type_id::create("cfg");

      if (cfg.role == ACTING_AS) begin
        //gpioz_agents["gpioz_if"].is_active = UVM_ACTIVE; gpioz_agents["gpioz_if"].cfg.role = gpioz_pkg::REQUESTER;
        //i2cz_agents["i2cz_if"].is_active = UVM_ACTIVE;
      end
      else if (cfg.role == ACTING_ON) begin
        clk_rst_agents["clk_rst_if"].is_active = UVM_ACTIVE; clk_rst_agents["clk_rst_if"].cfg.freq = cfg.clk_freq;
        //gpioz_agents["gpioz_if"].is_active = UVM_ACTIVE; gpioz_agents["gpioz_if"].cfg.role = gpioz_pkg::RESPONDER;
        //i2cz_agents["i2cz_if"].is_active = UVM_ACTIVE;
      end
    end

    foreach (cfg.verilab_pads_env_cfgs[e]) begin verilab_pads_envs[e] = verilab_pads_env::type_id::create(e, this); verilab_pads_envs[e].cfg = cfg.verilab_pads_env_cfgs[e]; end
    foreach (cfg.verilab_core_env_cfgs[e]) begin verilab_core_envs[e] = verilab_core_env::type_id::create(e, this); verilab_core_envs[e].cfg = cfg.verilab_core_env_cfgs[e]; end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  virtual task run_phase(uvm_phase phase);
  endtask
endclass

`endif

