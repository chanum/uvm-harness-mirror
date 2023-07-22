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

`ifndef __gpio_env__
`define __gpio_env__

class gpio_env extends uvm_env;

  clk_rst_agent clk_rst_agents[string];
  apb_agent apb_agents[string];
  gpio_agent gpio_agents[string];

  gpio_env_cfg cfg;
  gpio_pharness_base harness;
  gpio_vseqr vseqr;

  `uvm_component_utils_begin(gpio_env)
  `uvm_component_utils_end

  function new(string name = "gpio_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (cfg.role != BLIND) begin
      if (! uvm_config_db#(gpio_pharness_base)::get(this, "", "harness", harness)) begin
        `uvm_fatal("build_phase", "No gpio_pharness_base 'harness' in uvm_config_db")
      end
      vseqr = gpio_vseqr::type_id::create("vseqr", this);

      clk_rst_agents["clk_rst_if"] = clk_rst_agent::type_id::create("clk_rst_if", this);
      if (! uvm_config_db#(virtual clk_rst_interface)::get(this, "", "clk_rst_if", clk_rst_agents["clk_rst_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual clk_rst_interface 'clk_rst_if' in uvm_config_db")
      end
      clk_rst_agents["clk_rst_if"].cfg = clk_rst_vip_cfg::type_id::create("clk_rst_if_cfg");

      apb_agents["apb_if"] = apb_agent::type_id::create("apb_if", this);
      if (! uvm_config_db#(virtual apb_interface)::get(this, "", "apb_if", apb_agents["apb_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual apb_interface 'apb_if' in uvm_config_db")
      end
      apb_agents["apb_if"].cfg = apb_vip_cfg::type_id::create("apb_if_cfg");
      apb_agents["apb_if"].cfg.actual_addr_bus_bits = 12; apb_agents["apb_if"].cfg.actual_data_bus_bits = 32;

      gpio_agents["gpio_if"] = gpio_agent::type_id::create("gpio_if", this);
      if (! uvm_config_db#(virtual gpio_interface)::get(this, "", "gpio_if", gpio_agents["gpio_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual gpio_interface 'gpio_if' in uvm_config_db")
      end
      gpio_agents["gpio_if"].cfg = gpio_vip_cfg::type_id::create("gpio_if_cfg");

      if (cfg.role == ACTING_AS) begin
        apb_agents["apb_if"].is_active = UVM_ACTIVE; apb_agents["apb_if"].cfg.role = apb_pkg::RESPONDER;
        gpio_agents["gpio_if"].is_active = UVM_ACTIVE; gpio_agents["gpio_if"].cfg.role = gpio_pkg::REQUESTER;
      end
      else if (cfg.role == ACTING_ON) begin
        clk_rst_agents["clk_rst_if"].is_active = UVM_ACTIVE; clk_rst_agents["clk_rst_if"].cfg.freq = cfg.clk_freq;
        apb_agents["apb_if"].is_active = UVM_ACTIVE; apb_agents["apb_if"].cfg.role = apb_pkg::REQUESTER;
        gpio_agents["gpio_if"].is_active = UVM_ACTIVE; gpio_agents["gpio_if"].cfg.role = gpio_pkg::RESPONDER;
      end
    end
  endfunction
endclass

`endif

