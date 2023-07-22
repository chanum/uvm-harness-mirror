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

`ifndef __gpio_pkg__
`define __gpio_pkg__

package gpio_pkg;

  import uvm_pkg::*;
  import gpio_param_pkg::*;

  typedef enum bit { REQUESTER, RESPONDER } agent_role;

  typedef class gpio_seq_item;

  //`include "gpio_policy_lib.sv"
  `include "gpio_vip_cfg.sv"
  `include "gpio_sequencer.sv"
  //`include "gpio_driver.sv"
  //`include "gpio_monitor.sv"
  `include "gpio_agent.sv"
  `include "gpio_seq_item.sv"
endpackage

`endif

