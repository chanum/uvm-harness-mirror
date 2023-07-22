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

`ifndef __ahb_seq_item__
`define __ahb_seq_item__

class ahb_seq_item extends uvm_sequence_item;

  ahb_vip_cfg cfg;
  rand bit [1:0] htrans = HTRANS_NONSEQ;
  rand bit [2:0] hburst = HBURST_SINGLE;
  rand bit [2:0] hsize = HSIZE_32;
  rand bit hmastlock = 0;
  rand bit [3:0] hprot = HPROT_noCACHE_noBUFF_PRIV_DATA;
  rand ADDR_t haddr;
  rand bit hwrite;
  rand DATA_t hxdata;
  rand bit hresp;
       bit hready;
       int unsigned beat = 0;
  rand int unsigned idle_cyc;
       int unsigned stall_cyc;
  rand int unsigned wait_cyc;
  rand bit chain_cancel;
  rand ahb_seq_item next;

  `uvm_declare_p_sequencer(ahb_sequencer)
  `uvm_object_utils_begin(ahb_seq_item)
    `uvm_field_object(cfg, UVM_ALL_ON)
    `uvm_field_int(htrans, UVM_ALL_ON)
    `uvm_field_int(hburst, UVM_ALL_ON)
    `uvm_field_int(hsize, UVM_ALL_ON)
    `uvm_field_int(hmastlock, UVM_ALL_ON)
    `uvm_field_int(hprot, UVM_ALL_ON)
    `uvm_field_int(haddr, UVM_ALL_ON)
    `uvm_field_int(hwrite, UVM_ALL_ON)
    `uvm_field_int(hxdata, UVM_ALL_ON)
    `uvm_field_int(hresp, UVM_ALL_ON)
    `uvm_field_int(hready, UVM_ALL_ON)
    `uvm_field_int(idle_cyc, UVM_ALL_ON)
    `uvm_field_int(stall_cyc, UVM_ALL_ON)
    `uvm_field_int(wait_cyc, UVM_ALL_ON)
    `uvm_field_int(beat, UVM_ALL_ON)
    `uvm_field_int(chain_cancel, UVM_ALL_ON)
    `uvm_field_object(next, UVM_ALL_ON)
  `uvm_object_utils_end

  constraint htrans_not_idle {
    (htrans != HTRANS_IDLE); // Don't generate items that don't do anything.
  }

  constraint haddr_max {
    (haddr & ((ADDR_t'(1) << cfg.actual_addr_bus_bits) - 1)) == haddr;
  }

  constraint hsize_max {
    ((1 << hsize) << 3) <= cfg.actual_data_bus_bits;
  }

  constraint hxdata_max {
    (hxdata & ((DATA_t'(1) << cfg.actual_data_bus_bits) - 1)) == hxdata;
  }

  constraint haddr_hsize_align {
    ((htrans != HTRANS_IDLE) || (cfg.kill_haddr_hsize_align_idle == 1'b0)) -> ((haddr & ((1 << hsize) - 1)) == '0);
  }

  constraint haddr_burst_incr_window_align {
    ((hburst inside {hburst_incr_set}) && (beat != 0)) -> ((haddr & ((1 << 10) - 1)) != 0); // A non-first beat of an incr burst cannot land on a 1kB boundary.
  }

  constraint requester {
    if (cfg.role == REQUESTER) {
      idle_cyc dist {    0     :/ 11'b10000000000,
                     [  1:  3] :/ 11'b01000000000,
                     [  4: 15] :/ 11'b00010000000,
                     [ 16: 63] :/ 11'b00000010000,
                     [ 64:255] :/ 11'b00000000001 };
      wait_cyc == 0;
      hresp == HRESP_OKAY;
    }
  }

  constraint requester_read {
    if (cfg.role == REQUESTER) {
      ((htrans != HTRANS_IDLE) && (hwrite == HWRITE_READ)) -> (hxdata == '0);
    }
  }

  constraint requester_lock_not_supported {
    if (cfg.role == REQUESTER) {
      hmastlock == 1'b0;
    }
  }

  constraint requester_beat_0 {
    if (cfg.role == REQUESTER) {
      (beat == 0) -> (htrans == HTRANS_NONSEQ);
    }
  }

  constraint requester_chain { // All chain transactions.
    if (cfg.role == REQUESTER) {
      if (next != null) {
        next.hburst == hburst;
        next.hmastlock == hmastlock;
        ((next.haddr & ~((ADDR_t'(1) << 10) - 1)) == (haddr & ~((ADDR_t'(1) << 10) - 1))); // Every item of a chain must target the same slave.
        ((hmastlock != 0) || (hburst != HBURST_SINGLE)); // A chain must be for lock or burst, cannot chain unlocked singles. But you can have a locked burst.
      }
    }
  }

  constraint requester_lock_chain { // Locked transactions.
    if (cfg.role == REQUESTER) {
      if (hmastlock == 1'b1) {
        (chain_cancel == 1'b1);
        (hburst == HBURST_SINGLE) -> (htrans == HTRANS_NONSEQ);
      }
    }
  }

  constraint requester_burst_chain { // Burst transactions.
    if (cfg.role == REQUESTER) {
      if (hburst != HBURST_SINGLE) {
        (hburst inside {hburst_fixed_length_set}) -> (htrans != HTRANS_BUSY);
        if (next != null) {
          (beat != 0) -> (htrans == HTRANS_SEQ);
          next.hsize == hsize;
          next.hprot == hprot;
          next.hwrite == hwrite;
          (hburst == HBURST_WRAP4)  -> (next.haddr == ((haddr & ~((ADDR_t'( 4) << hsize) - 1)) + ((haddr + (ADDR_t'(1) << hsize)) & ((ADDR_t'( 4) << hsize) - 1))));
          (hburst == HBURST_WRAP8)  -> (next.haddr == ((haddr & ~((ADDR_t'( 8) << hsize) - 1)) + ((haddr + (ADDR_t'(1) << hsize)) & ((ADDR_t'( 8) << hsize) - 1))));
          (hburst == HBURST_WRAP16) -> (next.haddr == ((haddr & ~((ADDR_t'(16) << hsize) - 1)) + ((haddr + (ADDR_t'(1) << hsize)) & ((ADDR_t'(16) << hsize) - 1))));
          (hburst inside {hburst_incr_set}) -> (next.haddr == ((haddr + (ADDR_t'(1) << hsize))));
        }
        else { // next is a rand var, and can be changed to null to satisfy the constraints of a burst on a very wide data bus.
          (beat ==  0) -> (hburst inside {HBURST_INCR, HBURST_SINGLE});
          (beat ==  3) -> (hburst inside {HBURST_INCR, HBURST_INCR4 , HBURST_WRAP4 });
          (beat ==  7) -> (hburst inside {HBURST_INCR, HBURST_INCR8 , HBURST_WRAP8 });
          (beat == 15) -> (hburst inside {HBURST_INCR, HBURST_INCR16, HBURST_WRAP16});
          (! beat inside {0, 3, 7, 15}) -> (hburst == HBURST_INCR);
          ((beat != 0) && (hburst == HBURST_INCR)) -> (htrans inside {HTRANS_SEQ, HTRANS_BUSY}); // Last beat of INCR burst can be BUSY. But only the last beat, next == null, and only if the chain has more than one beat.
        }
      }
    }
  }

  constraint responder {
    if (cfg.role == RESPONDER) {
      wait_cyc dist {    0     :/ 11'b10000000000,
                     [  1:  3] :/ 11'b01000000000,
                     [  4: 15] :/ 11'b00010000000,
                     [ 16: 63] :/ 11'b00000010000,
                     [ 64:255] :/ 11'b00000000001 };
    }
  }

  rand ahb_ad_hoc_policy_list ad_hoc_plist = new("ad_hoc_plist"); // A seq item can be given ad hoc policy constraints by anyone who has its handle. Ad hoc policies are specific to a single seq item. Ad hoc policies would typically be used to create a more-or-less directed item.
  rand ahb_policy_list plist = new("plist"); // A seq item will usually check the uvm_config_db for any policy constraints with the context of the sequence that sent it, and for any policy constraints with the context of the sequencer it is sent to. But setting plist.rand_mode(0) disables both.
  // Sequence policies would typically constrain the kind of traffic (small burst, large burst, no burst, ...). Sequencer policies would typically constrain the item to structural parameters of the dut (legal addr range for the specific block/port where an agent is attached, ...).
  // Seq policies may apply to all items in a chain, or only to the first. The chain policy governs the naming of "next" items, the seq defines the uvm_config_db::set() context pattern so that "next" items do or do not match.
  // Seqr policies should typically apply to every item in a chain, and consequently the ahb_sequencer defines a context pattern that matches any item name.

  function new(string name = "ahb_seq_item");
    super.new(name);
    ad_hoc_plist.set_item(this);
    plist.set_item(this);
  endfunction

  function void pre_randomize();
    ahb_policy policy; // NON-RAND.
    super.pre_randomize();
    if (cfg == null) begin
      if (! uvm_config_db#(ahb_vip_cfg)::get(p_sequencer, get_name(), "cfg", cfg)) begin
        cfg = p_sequencer.cfg;
      end
    end
    if (cfg.role == RESPONDER) begin
      htrans.rand_mode(0);
      hburst.rand_mode(0);
      hsize.rand_mode(0);
      hmastlock.rand_mode(0);
      hprot.rand_mode(0);
      haddr.rand_mode(0);
      hwrite.rand_mode(0);
      idle_cyc.rand_mode(0);
      chain_cancel.rand_mode(0);
      next.rand_mode(0);
      if (hwrite == HWRITE_WRITE) begin
        hxdata.rand_mode(0);
      end
    end
    // As best I can tell, the pre_randomize() of a child rand object can be called from parent pre_randomize() the *very instant* the child is non-null,
    // so getting from the cfg db directly into a class rand policy creates a race between child.pre_randomize() and trying to call child.set_item().
    // Instead, get from the cfg db into a non-rand intermediate, set_item on the intermediate, then pass the intermediate to the class policy.
    if (plist.rand_mode()) begin
      if (m_parent_sequence != null) begin
        if (uvm_config_db#(ahb_policy)::get(null, get_full_name(), "policy", policy)) begin
          policy.set_item(this);
          plist.add('{policy});
        end
      end
      if (uvm_config_db#(ahb_policy)::get(p_sequencer, get_name(), "policy", policy)) begin
        policy.set_item(this);
        plist.add('{policy});
      end
    end
  endfunction
endclass

`endif

