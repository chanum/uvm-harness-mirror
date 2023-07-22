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

`ifndef __ahb_driver__
`define __ahb_driver__

class ahb_driver extends uvm_driver#(ahb_seq_item);

  ahb_vip_cfg cfg;
  virtual ahb_interface vif;
  ahb_sequencer seqr;
  int unsigned stall_cyc;
  int unsigned wait_cyc;

  ahb_time0_seq_item_policy time0_policy = new();
  ahb_idle_seq_item_policy idle_policy = new();
  ahb_seq_item ad_hoc_item;
  ahb_seq_item item;
  mailbox#(ahb_seq_item) accepted;

  `uvm_component_utils_begin(ahb_driver)
    `uvm_field_object(cfg, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name = "ahb_driver", uvm_component parent = null);
    super.new(name, parent);
    if (parent == null) begin
      `uvm_fatal("new", "Null parent is not legal for this component")
    end
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  virtual task run_phase(uvm_phase phase);
    if (cfg.role == REQUESTER) begin
      run_requester();
    end
    else begin
      run_responder();
    end
  endtask

  virtual task run_requester();
    ad_hoc_item = ahb_seq_item::type_id::create("time0_item");
    ad_hoc_item.set_sequencer(seqr);
    ad_hoc_item.cfg = cfg;
    ad_hoc_item.ad_hoc_plist.set('{time0_policy});
    ad_hoc_item.ad_hoc_plist.set_item(ad_hoc_item);
    if (! ad_hoc_item.randomize()) begin
      `uvm_error("run_requester", "Unable to randomize time0_item")
    end
    vif.ocb.htrans <= ad_hoc_item.htrans;
    vif.ocb.hburst <= ad_hoc_item.hburst;
    vif.ocb.hsize <= ad_hoc_item.hsize;
    vif.ocb.hmastlock <= ad_hoc_item.hmastlock;
    vif.ocb.hprot <= ad_hoc_item.hprot;
    vif.ocb.haddr <= ad_hoc_item.haddr;
    vif.ocb.hwrite <= ad_hoc_item.hwrite;
    vif.ocb.hwdata <= ad_hoc_item.hxdata;
    vif.ad_hoc_ocb();
    wait (vif.time0 == 1'b0);

    fork
      forever begin
        ad_hoc_item = ahb_seq_item::type_id::create("idle_item");
        ad_hoc_item.set_sequencer(seqr);
        ad_hoc_item.cfg = cfg;
        ad_hoc_item.ad_hoc_plist.set('{idle_policy});
        ad_hoc_item.ad_hoc_plist.set_item(ad_hoc_item);
        if (! ad_hoc_item.randomize()) begin
          `uvm_error("run_requester", "Unable to randomize idle_item")
        end
        vif.ocb.htrans <= ad_hoc_item.htrans;
        vif.ocb.hburst <= ad_hoc_item.hburst;
        vif.ocb.hsize <= ad_hoc_item.hsize;
        vif.ocb.hmastlock <= ad_hoc_item.hmastlock;
        vif.ocb.hprot <= ad_hoc_item.hprot;
        vif.ocb.haddr <= ad_hoc_item.haddr;
        vif.ocb.hwrite <= ad_hoc_item.hwrite;
        vif.ocb.hwdata <= ad_hoc_item.hxdata;
        vif.ad_hoc_ocb();
        wait (vif.icb.hreset_n == 1'b1);
        seqr.set_reset(1'b0);
        item = ad_hoc_item;
        fork
          begin
            accepted = new();
            fork
              run_requester_data();
            join_none
            forever begin // This whole loop ONLY processes addr phases. Data phases are processed in run_requester_data().
              if (item.next != null) begin // The first time around, item (from ad_hoc_item) has no next item.
                item = item.next;
              end
              else begin
                seq_item_port.get_next_item(item); // If item is a beat > 0 of a loose chain, it MUST be available IMMEDIATELY, else there will be illegal HTRANS_IDLE cycles on the bus in the middle of the chain.
                vif.sync_icb();
                seq_item_port.item_done();
              end
              if (item.beat > 0) begin
                if (item.hburst != HBURST_SINGLE) begin
                  vif.ocb.htrans <= HTRANS_BUSY;
                  vif.ocb.hburst <= item.hburst;
                  vif.ocb.hsize <= item.hsize;
                  vif.ocb.hprot <= item.hprot;
                  vif.ocb.haddr <= item.haddr;
                  vif.ocb.hwrite <= item.hwrite;
                end
                vif.ocb.hmastlock <= item.hmastlock; // hmastlock is the only signal that must be stable even for non-burst chain.
              end
              repeat (item.idle_cyc) begin
                @vif.icb;
              end
              if ({vif.icb.hresp, vif.icb.hready} == 'b10) begin // Don't start a new txn in the middle of 2-cyc error hresp.
                @vif.icb;
              end

              vif.ocb.htrans <= item.htrans;
              vif.ocb.hburst <= item.hburst;
              vif.ocb.hsize <= item.hsize;
              vif.ocb.hmastlock <= item.hmastlock;
              vif.ocb.hprot <= item.hprot;
              vif.ocb.haddr <= item.haddr;
              vif.ocb.hwrite <= item.hwrite;
              @vif.icb;
              stall_cyc = 0;
              while ((vif.icb.hready == 1'b0) && (vif.icb.hresp == HRESP_OKAY)) begin
                @vif.icb;
                ++stall_cyc;
              end
              item.stall_cyc = stall_cyc;
              item.hresp = vif.icb.hresp;
              if (vif.icb.hresp == HRESP_OKAY) begin
                if (item.htrans inside { htrans_with_data_set }) begin
                  accepted.put(item);
                end
                else begin
                  item.hready = 1; // Primarily for the case of HBURST_INCR ending on HTRANS_BUSY, but also a seq could send us an HTRANS_IDLE txn (not encouraged, but allowed).
                end
              end
              else if (item.hburst != HBURST_SINGLE) begin // If HRESP_ERROR but this is a burst, it can stop or keep going.
                if (item.chain_cancel) begin
                  item.next = null;
                end
                else begin // If it keeps going, we have to keep waiting for hready, it must come next cycle.
                  @vif.icb;
                  accepted.put(item);
                end
              end

              if (! ad_hoc_item.randomize()) begin // ad_hoc_item remains idle_item until another reset. The easiest way to randomize bus fields that might be wider than $urandom, and also respect any idle bus rules, is to re-randomize idle_item each time.
                `uvm_error("run_requester", "Unable to randomize idle_item")
              end
              vif.ocb.htrans <= HTRANS_IDLE; // If there is a new item available immediately back at the top of the loop, this can all be overwritten and never appear on the interface.
              vif.ocb.hburst <= ad_hoc_item.hburst;
              vif.ocb.hsize <= ad_hoc_item.hsize;
              vif.ocb.hmastlock <= ad_hoc_item.hmastlock;
              vif.ocb.hprot <= ad_hoc_item.hprot;
              vif.ocb.haddr <= ad_hoc_item.haddr;
              vif.ocb.hwrite <= ad_hoc_item.hwrite;

              while (vif.icb.hready == 0) begin
                @vif.icb; // Solely for the case that a txn was cancelled in the first error cyc, we need to wait an extra cyc for hready.
              end
            end
          end

          wait (vif.hreset_n == 1'b0);
        join_any
        disable fork;
        seqr.set_reset(1'b1);
      end
    join
  endtask

  virtual task run_requester_data();
    ahb_seq_item item;
    forever begin
      accepted.get(item);
      // Data phase.
      if (item.hwrite == HWRITE_WRITE) begin
        vif.ocb.hwdata <= item.hxdata;
      end
      @vif.icb;
      wait_cyc = 0;
      while (vif.icb.hready != 1'b1) begin
        @vif.icb;
        ++wait_cyc;
      end
      item.wait_cyc = wait_cyc;
      if (item.hwrite == HWRITE_READ) begin
        item.hxdata = vif.icb.hrdata;
      end
      item.hresp = vif.icb.hresp;
      item.hready = vif.icb.hready;

      vif.ocb.hwdata <= ad_hoc_item.hxdata;
    end
  endtask

  virtual task run_responder();
    ad_hoc_item = ahb_seq_item::type_id::create("time0_item");
    ad_hoc_item.set_sequencer(seqr);
    ad_hoc_item.cfg = cfg;
    ad_hoc_item.ad_hoc_plist.set('{time0_policy});
    ad_hoc_item.ad_hoc_plist.set_item(ad_hoc_item);
    if (! ad_hoc_item.randomize()) begin
      `uvm_error("run_responder", "Unable to randomize time0_item")
    end
    vif.ocb.hrdata <= ad_hoc_item.hxdata;
    vif.ocb.hresp <= ad_hoc_item.hresp;
    vif.ocb.hreadyout <= $urandom();
    vif.ad_hoc_ocb();
    wait (vif.time0 == 1'b0);

    fork
      forever begin
        ad_hoc_item = ahb_seq_item::type_id::create("idle_item");
        ad_hoc_item.set_sequencer(seqr);
        ad_hoc_item.cfg = cfg;
        ad_hoc_item.ad_hoc_plist.set('{idle_policy});
        ad_hoc_item.ad_hoc_plist.set_item(ad_hoc_item);
        if (! ad_hoc_item.randomize()) begin
          `uvm_error("run_requester", "Unable to randomize idle_item")
        end
        vif.ocb.hrdata <= ad_hoc_item.hxdata;
        vif.ocb.hresp <= ad_hoc_item.hresp;
        vif.ocb.hreadyout <= 1'b1;
        vif.ad_hoc_ocb();
        wait (vif.icb.hreset_n == 1'b1);
        seqr.set_reset(1'b0);

        fork
          forever begin
            seq_item_port.get_next_item(item);
            vif.sync_icb(); // If the seq got the req from the monitor as intended, this will always fall straight through.
            seq_item_port.item_done();

            // Data phase.
            vif.ocb.hreadyout <= 1'b0;
            repeat (item.wait_cyc) begin
              @vif.icb;
            end
            if (item.hwrite == HWRITE_READ) begin
              vif.ocb.hrdata <= item.hxdata;
            end
            vif.ocb.hresp <= item.hresp;
            if (item.hresp == HRESP_ERROR) begin
              @vif.icb;
            end
            vif.ocb.hreadyout <= 1'b1;
            @vif.icb;

            if (! ad_hoc_item.randomize()) begin
              `uvm_error("run_requester", "Unable to randomize idle_item")
            end
            vif.ocb.hrdata <= ad_hoc_item.hxdata;
            vif.ocb.hresp <= HRESP_OKAY;
            vif.ocb.hreadyout <= 1'b1;
          end

          wait (vif.hreset_n === 1'b0); // Not icb.hreset_n!
        join_any
        disable fork;
        seqr.set_reset(1'b1);
      end
    join
  endtask
endclass

`endif

