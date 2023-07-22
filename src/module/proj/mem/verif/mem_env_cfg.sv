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

`ifndef __mem_env_cfg__
`define __mem_env_cfg__

class mem_env_cfg extends uvm_object;

  mem_pkg::env_role role;
  string clk_freq;

  `uvm_object_utils_begin(mem_env_cfg)
  `uvm_object_utils_end

  function new(string name = "mem_env_cfg");
    super.new(name);
  endfunction
endclass

`endif

