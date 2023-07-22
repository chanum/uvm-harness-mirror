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

`ifndef __i2c_env__
`define __i2c_env__

class i2c_env extends uvm_env;

  clk_rst_agent clk_rst_agents[string];
  apb_agent apb_agents[string];
  i2c_agent i2c_agents[string];

  i2c_env_cfg cfg;
  i2c_pharness_base harness;
  i2c_vseqr vseqr;

  `uvm_component_utils_begin(i2c_env)
  `uvm_component_utils_end

  function new(string name = "i2c_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (cfg.role != BLIND) begin
      if (! uvm_config_db#(i2c_pharness_base)::get(this, "", "harness", harness)) begin
        `uvm_fatal("build_phase", "No i2c_pharness_base 'harness' in uvm_config_db")
      end
      vseqr = i2c_vseqr::type_id::create("vseqr", this);

      clk_rst_agents["clk_rst_if"] = clk_rst_agent::type_id::create("clk_rst_if", this);
      if (! uvm_config_db#(virtual clk_rst_interface)::get(this, "", "clk_rst_if", clk_rst_agents["clk_rst_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual clk_rst_interface 'clk_rst_if' in uvm_config_db")
      end
      clk_rst_agents["clk_rst_if"].cfg = clk_rst_vip_cfg::type_id::create("clk_rst_if_cfg");

      apb_agents["mst_apb_if"] = apb_agent::type_id::create("mst_apb_if", this);
      if (! uvm_config_db#(virtual apb_interface)::get(this, "", "mst_apb_if", apb_agents["mst_apb_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual apb_interface 'mst_apb_if' in uvm_config_db")
      end
      apb_agents["mst_apb_if"].cfg = apb_vip_cfg::type_id::create("mst_apb_if_cfg");
      apb_agents["mst_apb_if"].cfg.actual_addr_bus_bits = harness.MST_ADDR; apb_agents["mst_apb_if"].cfg.actual_data_bus_bits = 32;

      apb_agents["slv_apb_if"] = apb_agent::type_id::create("slv_apb_if", this);
      if (! uvm_config_db#(virtual apb_interface)::get(this, "", "slv_apb_if", apb_agents["slv_apb_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual apb_interface 'slv_apb_if' in uvm_config_db")
      end
      apb_agents["slv_apb_if"].cfg = apb_vip_cfg::type_id::create("slv_apb_if_cfg");
      apb_agents["slv_apb_if"].cfg.actual_addr_bus_bits = 12; apb_agents["slv_apb_if"].cfg.actual_data_bus_bits = harness.SLV_DATA;

      i2c_agents["i2c_if"] = i2c_agent::type_id::create("i2c_if", this);
      if (! uvm_config_db#(virtual i2c_interface)::get(this, "", "i2c_if", i2c_agents["i2c_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual i2c_interface 'i2c_if' in uvm_config_db")
      end
      i2c_agents["i2c_if"].cfg = i2c_vip_cfg::type_id::create("i2c_if_cfg");

      if (cfg.role == ACTING_AS) begin
        apb_agents["mst_apb_if"].is_active = UVM_ACTIVE; apb_agents["mst_apb_if"].cfg.role = apb_pkg::REQUESTER;
        apb_agents["slv_apb_if"].is_active = UVM_ACTIVE; apb_agents["slv_apb_if"].cfg.role = apb_pkg::RESPONDER;
        i2c_agents["i2c_if"].is_active = UVM_ACTIVE;
      end
      else if (cfg.role == ACTING_ON) begin
        clk_rst_agents["clk_rst_if"].is_active = UVM_ACTIVE; clk_rst_agents["clk_rst_if"].cfg.freq = cfg.clk_freq;
        apb_agents["mst_apb_if"].is_active = UVM_ACTIVE; apb_agents["mst_apb_if"].cfg.role = apb_pkg::RESPONDER;
        apb_agents["slv_apb_if"].is_active = UVM_ACTIVE; apb_agents["slv_apb_if"].cfg.role = apb_pkg::REQUESTER;
        i2c_agents["i2c_if"].is_active = UVM_ACTIVE;
      end
    end
  endfunction
endclass

`endif

