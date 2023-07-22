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

`ifndef __arb_pkg__
`define __arb_pkg__

package arb_pkg;

  import uvm_pkg::*;
  import arb_param_pkg::*;

  typedef enum bit { REQUESTER, RESPONDER } agent_role;

  //typedef class arb_seq_item;

  //`include "arb_policy_lib.sv"
  `include "arb_vip_cfg.sv"
  //`include "arb_sequencer.sv"
  //`include "arb_driver.sv"
  //`include "arb_monitor.sv"
  `include "arb_agent.sv"
  //`include "arb_seq_item.sv"
endpackage

`endif

