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

`ifndef __ahb_fabric_env__
`define __ahb_fabric_env__

class ahb_fabric_env extends uvm_env;

  arb_env arb_envs[string];

  clk_rst_agent clk_rst_agents[string];
  ahb_agent mst_ahb_agents[string];
  ahb_agent slv_ahb_agents[string];

  ahb_fabric_env_cfg cfg;
  ahb_fabric_pharness_base harness;
  ahb_fabric_vseqr vseqr;

  `uvm_component_utils_begin(ahb_fabric_env)
  `uvm_component_utils_end

  function new(string name = "ahb_fabric_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (cfg.role != BLIND) begin
      if (! uvm_config_db#(ahb_fabric_pharness_base)::get(this, "", "harness", harness)) begin
        `uvm_fatal("build_phase", "No ahb_fabric_pharness_base 'harness' in uvm_config_db")
      end
      vseqr = ahb_fabric_vseqr::type_id::create("vseqr", this);

      clk_rst_agents["clk_rst_if"] = clk_rst_agent::type_id::create("clk_rst_if", this);
      if (! uvm_config_db#(virtual clk_rst_interface)::get(this, "", "clk_rst_if", clk_rst_agents["clk_rst_if"].vif)) begin
        `uvm_fatal("build_phase", "No virtual clk_rst_interface 'clk_rst_if' in uvm_config_db")
      end
      clk_rst_agents["clk_rst_if"].cfg = clk_rst_vip_cfg::type_id::create("clk_rst_if_cfg");

      for (int a = 0; a < harness.MST; ++a) begin
        string name = $sformatf("mst_ahb_if[%0d]", a);
        mst_ahb_agents[name] = ahb_agent::type_id::create(name, this);
        if (! uvm_config_db#(virtual ahb_interface)::get(this, "", name, mst_ahb_agents[name].vif)) begin
          `uvm_fatal("build_phase", $sformatf("No virtual ahb_interface '%s' in uvm_config_db", name))
        end
        mst_ahb_agents[name].cfg = ahb_vip_cfg::type_id::create($sformatf("mst_ahb_if_cfg[%0d]", a));
        mst_ahb_agents[name].cfg.actual_addr_bus_bits = harness.MST_ADDR; mst_ahb_agents[name].cfg.actual_data_bus_bits = harness.DATA;
      end

      for (int a = 0; a < harness.SLV; ++a) begin
        string name = $sformatf("slv_ahb_if[%0d]", a);
        slv_ahb_agents[name] = ahb_agent::type_id::create(name, this);
        if (! uvm_config_db#(virtual ahb_interface)::get(this, "", name, slv_ahb_agents[name].vif)) begin
          `uvm_fatal("build_phase", $sformatf("No virtual ahb_interface '%s' in uvm_config_db", name))
        end
        slv_ahb_agents[name].cfg = ahb_vip_cfg::type_id::create($sformatf("slv_ahb_if_cfg[%0d]", a));
        slv_ahb_agents[name].cfg.actual_addr_bus_bits = harness.SLV_ADDR; slv_ahb_agents[name].cfg.actual_data_bus_bits = harness.DATA;
      end

      if (cfg.role == ACTING_AS) begin
        foreach (mst_ahb_agents[a]) begin
          mst_ahb_agents[a].is_active = UVM_ACTIVE; mst_ahb_agents[a].cfg.role = ahb_pkg::RESPONDER;
        end
        foreach (slv_ahb_agents[a]) begin
          slv_ahb_agents[a].is_active = UVM_ACTIVE; slv_ahb_agents[a].cfg.role = ahb_pkg::REQUESTER;
        end
      end
      else if (cfg.role == ACTING_ON) begin
        clk_rst_agents["clk_rst_if"].is_active = UVM_ACTIVE; clk_rst_agents["clk_rst_if"].cfg.freq = cfg.clk_freq;
        foreach (mst_ahb_agents[a]) begin
          mst_ahb_agents[a].is_active = UVM_ACTIVE; mst_ahb_agents[a].cfg.role = ahb_pkg::REQUESTER;
        end
        foreach (slv_ahb_agents[a]) begin
          slv_ahb_agents[a].is_active = UVM_ACTIVE; slv_ahb_agents[a].cfg.role = ahb_pkg::RESPONDER;
        end
      end
    end

    foreach (cfg.arb_env_cfgs[e]) begin arb_envs[e] = arb_env::type_id::create(e, this); arb_envs[e].cfg = cfg.arb_env_cfgs[e]; end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (cfg.role == ACTING_AS) begin
      foreach (slv_ahb_agents[a]) begin
        ahb_addr_range_policy_list slv_addr_range_plist = new($sformatf("%s.addr_range_plist", slv_ahb_agents[a].get_full_name()));
        ahb_addr_range_policy slv_addr_range_policy = new(a);
        slv_addr_range_policy.addr_lo = 0;
        slv_addr_range_policy.addr_hi = (ahb_param_pkg::ADDR_t'(1) << harness.SLV_ADDR) - 1;
        slv_addr_range_plist.add('{slv_addr_range_policy});
        slv_ahb_agents[a].sequencer.plist.add('{slv_addr_range_plist});
      end
    end
    else if (cfg.role == ACTING_ON) begin
      ahb_addr_range_policy_list mst_addr_range_plists[string];
      ahb_param_pkg::ADDR_t s = 0;
      foreach (mst_ahb_agents[a]) begin
        mst_addr_range_plists[a] = new($sformatf("%s.addr_range_plist", mst_ahb_agents[a].get_full_name()));
      end
      foreach (slv_ahb_agents[a]) begin
        ahb_addr_range_policy slv_addr_range_policy = new(a);
        slv_addr_range_policy.addr_lo = (s++) << harness.SLV_ADDR;
        slv_addr_range_policy.addr_hi = slv_addr_range_policy.addr_lo + (ahb_param_pkg::ADDR_t'(1) << harness.SLV_ADDR) - 1;
        foreach (mst_ahb_agents[a]) begin
          mst_addr_range_plists[a].add('{slv_addr_range_policy});
        end
      end
      foreach (mst_ahb_agents[a]) begin
        mst_ahb_agents[a].sequencer.plist.add('{mst_addr_range_plists[a]});
      end
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
  endtask
endclass

`endif
