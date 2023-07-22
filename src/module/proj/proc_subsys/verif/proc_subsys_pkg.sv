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

`ifndef __proc_subsys_pkg__
`define __proc_subsys_pkg__

package proc_subsys_pkg;

  import uvm_pkg::*;
  import clk_rst_pkg::*;
  import apb_pkg::*;
  import ahb_pkg::*;
  import ahb_fabric_pkg::*;
  import mem_pkg::*;
  import dma_pkg::*;
  import cpu_pkg::*;

  typedef enum int {BLIND, JUST_LOOKING, ACTING_AS, ACTING_ON} env_role;

  typedef class proc_subsys_env;

  `include "proc_subsys_env_cfg.sv"
  `include "proc_subsys_vseqr.sv"
  `include "proc_subsys_pharness_base.sv"
  `include "proc_subsys_env.sv"
endpackage

`endif
