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

`ifndef __arb_vip_cfg__
`define __arb_vip_cfg__

class arb_vip_cfg extends uvm_object;

  agent_role role;
  int unsigned actual_ways;

  `uvm_object_utils_begin(arb_vip_cfg)
    `uvm_field_enum(agent_role, role, UVM_ALL_ON)
    `uvm_field_int(actual_ways, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "arb_vip_cfg");
    super.new(name);
  endfunction
endclass

`endif

