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

`ifndef __periph_subsys_env_cfg__
`define __periph_subsys_env_cfg__

class periph_subsys_env_cfg extends uvm_object;

  apb_fabric_env_cfg apb_fabric_env_cfgs[string];
  gpio_env_cfg gpio_env_cfgs[string];
  i2c_env_cfg i2c_env_cfgs[string];

  periph_subsys_pkg::env_role role;
  string pclk_freq;

  `uvm_object_utils_begin(periph_subsys_env_cfg)
  `uvm_object_utils_end

  function new(string name = "periph_subsys_env_cfg");
    super.new(name);
  endfunction
endclass

`endif

