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

`ifndef __arb_mod_pkg__
`define __arb_mod_pkg__

package arb_mod_pkg;

  import uvm_pkg::*;
  import clk_rst_pkg::*;
  import arb_pkg::*;

  typedef enum int {BLIND, JUST_LOOKING, ACTING_AS, ACTING_ON} env_role;

  typedef class arb_env;

  `include "arb_env_cfg.sv"
  `include "arb_pharness_base.sv"
  `include "arb_vseqr.sv"
  `include "arb_env.sv"
endpackage

`endif

