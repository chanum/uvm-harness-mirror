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

`ifndef __ahb_pkg__
`define __ahb_pkg__

package ahb_pkg;

  import uvm_pkg::*;
  import ahb_param_pkg::*;
  import ahb_names_pkg::*;

  typedef enum bit { REQUESTER, RESPONDER } agent_role;

  bit [1:0] htrans_with_data_set[2] = '{ HTRANS_NONSEQ, HTRANS_SEQ };
  bit [2:0] hburst_fixed_length_set[6] = '{ HBURST_WRAP4, HBURST_INCR4, HBURST_WRAP8, HBURST_INCR8, HBURST_WRAP16, HBURST_INCR16 };
  bit [2:0] hburst_incr_set[4] = '{ HBURST_INCR, HBURST_INCR4, HBURST_INCR8, HBURST_INCR16 };
  bit [2:0] hburst_wrap_set[3] = '{ HBURST_WRAP4, HBURST_WRAP8, HBURST_WRAP16 };

  typedef bit kill_aa[string];

  typedef class ahb_seq_item;

  `include "ahb_mem.sv"
  `include "ahb_policy_lib.sv"
  `include "ahb_vip_cfg.sv"
  `include "ahb_sequencer.sv"
  `include "ahb_driver.sv"
  `include "ahb_monitor.sv"
  `include "ahb_agent.sv"
  `include "ahb_seq_item.sv"

  `include "ahb_base_seq.sv"
  `include "ahb_master_rand_seq.sv"
  `include "ahb_slave_mem_seq.sv"
endpackage

`endif

