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

`ifndef __proc_subsys_xcpu_xdma_test__
`define __proc_subsys_xcpu_xdma_test__

class proc_subsys_xcpu_xdma_test extends verilab_chip_base_test;
  proc_subsys_xcpu_xdma_test_base_vseq vseq; // Only vseqs that extend this base can be run with this test.

  `uvm_component_utils_begin(proc_subsys_xcpu_xdma_test)
  `uvm_component_utils_end

  function new(string name = "proc_subsys_xcpu_xdma_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"] = verilab_core_env_cfg::type_id::create("verilab_core_0");
    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].role = verilab_core_pkg::BLIND;

    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"] = proc_subsys_env_cfg::type_id::create("proc_subsys_0");
    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"].role = proc_subsys_pkg::ACTING_ON;
    void'($value$plusargs("CLK_FREQ=%s", verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"].clk_freq));

    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"].cpu_env_cfgs["cpu_0"] = cpu_env_cfg::type_id::create("cpu_0");
    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"].cpu_env_cfgs["cpu_0"].role = cpu_pkg::ACTING_AS;

    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"].dma_env_cfgs["dma_0"] = dma_env_cfg::type_id::create("dma_0");
    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"].dma_env_cfgs["dma_0"].role = dma_pkg::ACTING_AS;

    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"].mem_env_cfgs["mem_0"] = mem_env_cfg::type_id::create("mem_0");
    verilab_chip_env_cfgs["dut"].verilab_core_env_cfgs["verilab_core_0"].proc_subsys_env_cfgs["proc_subsys_0"].mem_env_cfgs["mem_0"].role = mem_pkg::JUST_LOOKING;
  endfunction

  virtual task run_phase(uvm_phase phase);
    string VSEQ;
    void'($value$plusargs("VSEQ=%s", VSEQ));
    set_type_override(proc_subsys_xcpu_xdma_test_base_vseq::type_name, VSEQ);
    vseq = proc_subsys_xcpu_xdma_test_base_vseq::type_id::create(VSEQ);

    phase.raise_objection(this);
    `uvm_info("run_phase", $sformatf("Starting VSEQ=%s",VSEQ),UVM_NONE)
    vseq.start(verilab_chip_envs["dut"].verilab_core_envs["verilab_core_0"].proc_subsys_envs["proc_subsys_0"].vseqr, null);
    `uvm_info("run_phase", $sformatf("Finished VSEQ=%s",VSEQ),UVM_NONE)
    phase.drop_objection(this);
  endtask
endclass

class proc_subsys_xcpu_xdma_test_base_vseq extends verilab_chip_base_vseq;
  `uvm_object_utils_begin(proc_subsys_xcpu_xdma_test_base_vseq)
  `uvm_object_utils_end
  `uvm_declare_p_sequencer(proc_subsys_pkg::proc_subsys_vseqr)

  function new(string name = "proc_subsys_xcpu_xdma_test_base_vseq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_error("body", "This is an empty base class method, you must specify a factory override vseq with a +VSEQ=... plusarg")
  endtask
endclass

`endif

