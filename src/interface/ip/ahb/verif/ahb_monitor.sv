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

`ifndef __ahb_monitor__
`define __ahb_monitor__

class ahb_monitor extends uvm_monitor;

  ahb_vip_cfg cfg;
  virtual ahb_interface vif;
  uvm_analysis_port#(ahb_seq_item) mon_item_port; // Completed transactions.
  uvm_analysis_port#(ahb_seq_item) react_item_port; // Incomplete transactions, request information only, for reactive sequence.
  ahb_seq_item mon_item;
  ahb_seq_item react_item;
  mailbox#(ahb_seq_item) accepted;
  int unsigned idle_cyc;
  int unsigned stall_cyc;
  int unsigned wait_cyc;
  int unsigned serial_num = '1;

  `uvm_component_utils_begin(ahb_monitor)
  `uvm_component_utils_end

  function new(string name = "ahb_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_item_port = new("mon_item_port", this);
    react_item_port = new("react_item_port", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  virtual task run_phase(uvm_phase phase);
    wait (vif.time0 == 1'b0);
    fork
      forever begin
        wait (vif.icb.hreset_n == 1'b1);
        accepted = new();
        fork
          run_addr_phase();
          run_data_phase();
          wait (vif.hreset_n == 1'b0);
        join_any
        disable fork;
      end
    join
  endtask

  virtual task run_addr_phase();
    forever begin
      mon_item = ahb_seq_item::type_id::create($sformatf("mon_item[%0d]", ++serial_num));
      mon_item.cfg = cfg;
      idle_cyc = 0;
      while ((vif.icb.hsel == 1'b0) || (vif.icb.htrans inside {HTRANS_IDLE, HTRANS_BUSY})) begin
        @vif.icb;
        ++idle_cyc;
      end
      // Addr phase.
      mon_item.idle_cyc = idle_cyc;
      mon_item.htrans = vif.icb.htrans;
      mon_item.hburst = vif.icb.hburst;
      mon_item.hsize = vif.icb.hsize;
      mon_item.hmastlock = vif.icb.hmastlock;
      mon_item.hprot = vif.icb.hprot;
      mon_item.haddr = vif.icb.haddr;
      mon_item.hwrite = vif.icb.hwrite;
      stall_cyc = 0;
      while ((vif.icb.hready == 1'b0) && (vif.icb.hresp == HRESP_OKAY)) begin
        @vif.icb;
        ++stall_cyc;
      end
      mon_item.stall_cyc = stall_cyc;
      mon_item.hresp = vif.icb.hresp;
      if ((vif.icb.hresp == HRESP_ERROR) && (vif.icb.hready == 1'b0)) begin // Only the *first* cycle of error response applies to addr phase. Second cycle applies to *data* phase only.
        mon_item_port.write(mon_item);
        @vif.icb;
        continue;
      end
      $cast(react_item, mon_item.clone());
      react_item.set_name($sformatf("react_item[%0d]", serial_num));
      react_item_port.write(react_item); // Once we hand off react_item to a reactive slave seq, we don't own it anymore, the seq and the driver can do anything they want to it.
      accepted.put(mon_item);
      @vif.icb;
    end
  endtask

  virtual task run_data_phase();
    ahb_seq_item mon_item;
    forever begin
      accepted.get(mon_item);
      @vif.icb;
      wait_cyc = 0;
      while (vif.icb.hready == 1'b0) begin
        @vif.icb;
        ++wait_cyc;
      end
      mon_item.wait_cyc = wait_cyc;
      mon_item.hxdata = (mon_item.hwrite == HWRITE_WRITE) ? vif.icb.hwdata : vif.icb.hrdata;
      mon_item.hresp = vif.icb.hresp;
      mon_item.hready = vif.icb.hready;
      mon_item_port.write(mon_item);
    end
  endtask
endclass

`endif

