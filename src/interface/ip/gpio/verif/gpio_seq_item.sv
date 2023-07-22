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

`ifndef __gpio_seq_item__
`define __gpio_seq_item__

class gpio_seq_item extends uvm_sequence_item;

  gpio_vip_cfg cfg;
  //rand bit [2:0] pprot = PPROT_DATA_SECURE_PRIV;
  //rand bit [31:0] paddr;
  //rand bit pwrite;
  //rand bit [3:0] pstrb;
  //rand bit [31:0] pxdata;
  //rand bit pslverr;
  //     bit pready;
  //rand int unsigned idle_cyc;
  //rand int unsigned wait_cyc;

  `uvm_declare_p_sequencer(gpio_sequencer)
  `uvm_object_utils_begin(gpio_seq_item)
  //  `uvm_field_int(pprot, UVM_ALL_ON)
  //  `uvm_field_int(paddr, UVM_ALL_ON)
  //  `uvm_field_int(pwrite, UVM_ALL_ON)
  //  `uvm_field_int(pstrb, UVM_ALL_ON)
  //  `uvm_field_int(pxdata, UVM_ALL_ON)
  //  `uvm_field_int(pslverr, UVM_ALL_ON)
  //  `uvm_field_int(pready, UVM_ALL_ON)
  //  `uvm_field_int(idle_cyc, UVM_ALL_ON)
  //  `uvm_field_int(wait_cyc, UVM_ALL_ON)
  `uvm_object_utils_end

  //constraint paddr_max {
  //  (paddr & ((32'h1 << cfg.actual_addr_bus_bits) - 1)) == paddr;
  //}

  //constraint pxdata_max {
  //  (pxdata & ((32'h1 << cfg.actual_data_bus_bits) - 1)) == pxdata;
  //}

  //constraint pstrb_read {
  //  (pwrite == PWRITE_READ) -> (pstrb == '0);
  //}

  //constraint pstrb_paddr {
  //  ((pstrb & ((1 << paddr[1:0]) - 1)) == '0);
  //}

  //constraint requester {
  //  (cfg.role == REQUESTER) -> ((wait_cyc == 0) && (pslverr == PSLVERR_OKAY));
  //}

  //constraint requester_read {
  //  ((cfg.role == REQUESTER) && (pwrite == PWRITE_READ)) -> (pxdata == '0);
  //}

  //rand gpio_ad_hoc_policy_list#(gpio_seq_item) ad_hoc_plist;
  //rand gpio_policy_list#(gpio_seq_item) seq_plist;
  //rand gpio_policy_list#(gpio_seq_item) seqr_plist;

  function new(string name = "gpio_seq_item");
    super.new(name);
  endfunction

  //function void pre_randomize();
  //  super.pre_randomize();
  //  if (cfg == null) begin
  //    if (! uvm_config_db#(gpio_vip_cfg)::get(p_sequencer, get_name(), "cfg", cfg)) begin
  //      cfg = p_sequencer.cfg;
  //    end
  //  end
  //  if (cfg.role == RESPONDER) begin
  //    pprot.rand_mode(0);
  //    paddr.rand_mode(0);
  //    pwrite.rand_mode(0);
  //    pstrb.rand_mode(0);
  //    idle_cyc.rand_mode(0);
  //    if (pwrite == PWRITE_WRITE) begin
  //      pxdata.rand_mode(0);
  //    end
  //  end
  //  if (uvm_config_db#(gpio_policy_list#(gpio_seq_item))::get(null, get_full_name(), "policy_list", seq_plist)) begin
  //    seq_plist.set_item(this);
  //  end
  //  if (uvm_config_db#(gpio_policy_list#(gpio_seq_item))::get(p_sequencer, get_name(), "policy_list", seqr_plist)) begin
  //    seqr_plist.set_item(this);
  //  end
  //  if (ad_hoc_plist != null) begin
  //    ad_hoc_plist.set_item(this);
  //  end
  //endfunction
endclass

`endif

