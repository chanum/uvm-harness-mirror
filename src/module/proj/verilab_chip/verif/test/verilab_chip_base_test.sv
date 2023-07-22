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

`ifndef __verilab_chip_base_test__
`define __verilab_chip_base_test__

class verilab_chip_base_test extends uvm_test;

  verilab_chip_env_cfg   verilab_chip_env_cfgs[string];
  verilab_chip_env       verilab_chip_envs[string];

  `uvm_component_utils_begin(verilab_chip_base_test)
  `uvm_component_utils_end

  function new(string name = "verilab_chip_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    verilab_chip_env_cfgs["dut"] = verilab_chip_env_cfg::type_id::create("dut");
    verilab_chip_envs["dut"] = verilab_chip_env::type_id::create("dut", this); verilab_chip_envs["dut"].cfg = verilab_chip_env_cfgs["dut"];
  endfunction
endclass

`endif

