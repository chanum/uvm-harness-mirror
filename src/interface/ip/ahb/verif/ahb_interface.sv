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

`ifndef __ahb_interface__
`define __ahb_interface__

interface ahb_interface #(ADDR = ahb_param_pkg::ADDR, DATA = ahb_param_pkg::DATA) (
  input hreset_n,
  input hclk,
  input hsel,
  input [1:0] htrans,
  input [2:0] hburst,
  input [2:0] hsize,
  input hmastlock,
  input [3:0] hprot,
  input [ADDR-1:0] haddr,
  input hwrite,
  input [DATA-1:0] hwdata,
  input [DATA-1:0] hrdata,
  input hresp,
  input hreadyout,
  input hready
);

  import ahb_param_pkg::*;
  import ahb_names_pkg::*;
  import ahb_pkg::*;
  ahb_vip_cfg cfg;

  event sync_icb_ev;
  event ad_hoc_ocb_ev;

  clocking icb @(posedge hclk);
    input hreset_n;
    input hsel;
    input htrans;
    input hburst;
    input hsize;
    input hmastlock;
    input hprot;
    input haddr;
    input hwrite;
    input hwdata;
    input hrdata;
    input hresp;
    input hreadyout;
    input hready;
  endclocking

  clocking ocb @(posedge hclk or ad_hoc_ocb_ev);
    output hsel;
    output htrans;
    output hburst;
    output hsize;
    output hmastlock;
    output hprot;
    output haddr;
    output hwrite;
    output hwdata;
    output hrdata;
    output hresp;
    output hreadyout;
  endclocking

  always @(icb) begin
    -> sync_icb_ev;
  end

  task sync_icb();
    wait (sync_icb_ev.triggered);
  endtask

  function void ad_hoc_ocb();
    -> ad_hoc_ocb_ev;
  endfunction

  bit time0 = 1;

  initial begin
    wait ($isunknown({hreset_n, hclk}) == 1'b0);
    fork
      forever @({hreset_n, hclk}) begin
        assert ($isunknown({hreset_n, hclk}) == 1'b0); // From the moment both hreset_n and hclk become valid, they can never again be unknown.
      end

      forever begin
        wait (hreset_n == 1'b0);
        time0 = 0;
        wait (hreset_n == 1'b1);
        assert (htrans == HTRANS_IDLE); // Coming out of reset, htrans must be Idle.
        assert (hmastlock == 1'b0); // Coming out of reset, hmastlock must be 0.
        assert (hresp == HRESP_OKAY); // Coming out of reset, hresp must be Okay.
        assert ({hreadyout, hready} == '1); // Coming out of reset, all hready signals must be high.
      end
    join
  end

  int unsigned actual_addr_bus_bits = ADDR;
  int unsigned actual_data_bus_bits = DATA;
  bit kill_valid_htrans = 0;
  bit kill_valid_hburst = 0;
  bit kill_valid_hsize = 0;
  bit kill_valid_hmastlock = 0;
  bit kill_valid_hprot = 0;
  bit kill_valid_haddr = 0;
  bit kill_valid_hwrite = 0;
  bit kill_valid_hwdata = 0;
  bit kill_valid_hresp = 0;
  bit kill_valid_hreadyout = 0;
  bit kill_valid_hrdata = 0;
  bit kill_valid_hsel = 0;
  bit kill_valid_hready = 0;
  bit kill_stable_htrans = 0;
  bit kill_stable_hburst = 0;
  bit kill_stable_hsize = 0;
  bit kill_stable_hmastlock = 0;
  bit kill_stable_hprot = 0;
  bit kill_stable_haddr = 0;
  bit kill_stable_hwrite = 0;
  bit kill_stable_hwdata = 0;
  bit kill_stable_hsel = 0;
  bit kill_stable_hresp = 0;
  bit kill_hsel_haddr_1kB = 0;
  bit kill_haddr_hsize_align = 0;
  bit kill_haddr_hsize_align_idle = 1; // Note default value!
  bit kill_haddr_max = 0;
  bit kill_hwdata_max = 0;
  bit kill_hrdata_max = 0;
  bit kill_hsize_max = 0;
  bit kill_hsize_max_idle = 1; // Note default value!
  bit kill_htrans_single = 0;
  bit kill_htrans_error_idle = 0;
  bit kill_hmastlock_rise = 0;
  bit kill_burst_stable_hburst = 0;
  bit kill_burst_stable_hsize = 0;
  bit kill_burst_stable_hprot = 0;
  bit kill_burst_stable_haddr = 0;
  bit kill_burst_stable_hwrite = 0;
  bit kill_burst_stable_busy_haddr = 0;
  bit kill_haddr_burst_step = 0;
  bit kill_burst_complete = 0;
  bit kill_burst_overrun = 0;
  bit kill_haddr_burst_incr_window_align = 0;
  bit kill_burst_end_busy = 0;
  bit kill_burst_end_busy_error = 0;
  bit kill_first_err_cyc = 0;
  bit kill_second_err_cyc = 0;

  initial begin
    wait (cfg != null);
    actual_addr_bus_bits = cfg.actual_addr_bus_bits;
    actual_data_bus_bits = cfg.actual_data_bus_bits;
    if (actual_addr_bus_bits > ADDR) begin
      `uvm_fatal($sformatf("ahb_interface %m"), $sformatf("config data width %0d greater than inst param addr width %0d (bits)", actual_addr_bus_bits, ADDR))
    end
    if (actual_data_bus_bits > DATA) begin
      `uvm_fatal($sformatf("ahb_interface %m"), $sformatf("config data width %0d greater than inst param data width %0d (bits)", actual_data_bus_bits, DATA))
    end
    if ($countbits(actual_data_bus_bits, 1) != 1) begin
      `uvm_fatal($sformatf("ahb_interface %m"), $sformatf("config data width %0d is invalid, must be power of 2 (bits)", actual_data_bus_bits))
    end
    kill_valid_htrans = cfg.kill_valid_htrans;
    kill_valid_hburst = cfg.kill_valid_hburst;
    kill_valid_hsize = cfg.kill_valid_hsize;
    kill_valid_hmastlock = cfg.kill_valid_hmastlock;
    kill_valid_hprot = cfg.kill_valid_hprot;
    kill_valid_haddr = cfg.kill_valid_haddr;
    kill_valid_hwrite = cfg.kill_valid_hwrite;
    kill_valid_hwdata = cfg.kill_valid_hwdata;
    kill_valid_hresp = cfg.kill_valid_hresp;
    kill_valid_hreadyout = cfg.kill_valid_hreadyout;
    kill_valid_hrdata = cfg.kill_valid_hrdata;
    kill_valid_hsel = cfg.kill_valid_hsel;
    kill_valid_hready = cfg.kill_valid_hready;
    kill_stable_htrans = cfg.kill_stable_htrans;
    kill_stable_hburst = cfg.kill_stable_hburst;
    kill_stable_hsize = cfg.kill_stable_hsize;
    kill_stable_hmastlock = cfg.kill_stable_hmastlock;
    kill_stable_hprot = cfg.kill_stable_hprot;
    kill_stable_haddr = cfg.kill_stable_haddr;
    kill_stable_hwrite = cfg.kill_stable_hwrite;
    kill_stable_hwdata = cfg.kill_stable_hwdata;
    kill_stable_hsel = cfg.kill_stable_hsel;
    kill_stable_hresp = cfg.kill_stable_hresp;
    kill_hsel_haddr_1kB = cfg.kill_hsel_haddr_1kB;
    kill_haddr_hsize_align = cfg.kill_haddr_hsize_align;
    kill_haddr_hsize_align_idle = cfg.kill_haddr_hsize_align_idle;
    kill_haddr_max = cfg.kill_haddr_max;
    kill_hwdata_max = cfg.kill_hwdata_max;
    kill_hrdata_max = cfg.kill_hrdata_max;
    kill_hsize_max = cfg.kill_hsize_max;
    kill_hsize_max_idle = cfg.kill_hsize_max_idle;
    kill_htrans_single = cfg.kill_htrans_single;
    kill_htrans_error_idle = cfg.kill_htrans_error_idle;
    kill_hmastlock_rise = cfg.kill_hmastlock_rise;
    kill_burst_stable_hburst = cfg.kill_burst_stable_hburst;
    kill_burst_stable_hsize = cfg.kill_burst_stable_hsize;
    kill_burst_stable_hprot = cfg.kill_burst_stable_hprot;
    kill_burst_stable_haddr = cfg.kill_burst_stable_haddr;
    kill_burst_stable_hwrite = cfg.kill_burst_stable_hwrite;
    kill_burst_stable_busy_haddr = cfg.kill_burst_stable_busy_haddr;
    kill_haddr_burst_step = cfg.kill_haddr_burst_step;
    kill_burst_complete = cfg.kill_burst_complete;
    kill_burst_overrun = cfg.kill_burst_overrun;
    kill_haddr_burst_incr_window_align = cfg.kill_haddr_burst_incr_window_align;
    kill_burst_end_busy = cfg.kill_burst_end_busy;
    kill_burst_end_busy_error = cfg.kill_burst_end_busy_error;
    kill_first_err_cyc = cfg.kill_first_err_cyc;
    kill_second_err_cyc = cfg.kill_second_err_cyc;
  end

  // Property helper signals.
  bit dr_phase;
  bit dw_phase;
  always @(posedge hclk or negedge hreset_n) begin
    if (hreset_n == 1'b0) begin
      dr_phase <= 1'b0;
      dw_phase <= 1'b0;
    end
    else if ((htrans != HTRANS_IDLE) && (htrans != HTRANS_BUSY) && hready) begin
      dr_phase <= (hwrite == HWRITE_READ);
      dw_phase <= (hwrite == HWRITE_WRITE);
    end
    else begin
      dr_phase <= 1'b0;
      dw_phase <= 1'b0;
    end
  end

  bit [31:0] burst_beat_addr;
  int unsigned burst_beats_remain;
  always @(posedge hclk or negedge hreset_n) begin
    if (hreset_n == 1'b0) begin
      burst_beat_addr <= '0;
      burst_beats_remain <= 0;
    end
    else if (htrans == HTRANS_IDLE) begin
      burst_beats_remain <= 0;
    end
    else if ((htrans == HTRANS_NONSEQ) && hready) begin
      burst_beat_addr <= haddr;
      burst_beats_remain <= (hburst inside {HBURST_WRAP4 , HBURST_INCR4 }) ?  3
                          : (hburst inside {HBURST_WRAP8 , HBURST_INCR8 }) ?  7
                          : (hburst inside {HBURST_WRAP16, HBURST_INCR16}) ? 15
                                                                           :  0;
    end
    else if ((htrans == HTRANS_SEQ) && hready) begin
      burst_beat_addr <= burst_beat_addr + (1 << hsize);
      if (burst_beats_remain > 0) begin
        burst_beats_remain <= burst_beats_remain - 1;
      end
    end
  end

  bit [31:0] wrap_window;
  assign wrap_window = (hburst == HBURST_WRAP4)  ? (( 4 << int'(hsize)) - 1)
                     : (hburst == HBURST_WRAP8)  ? (( 8 << int'(hsize)) - 1)
                     : (hburst == HBURST_WRAP16) ? ((16 << int'(hsize)) - 1)
                                                 : (( 1 << 10         ) - 1); // Address is never allowed to increment across 1kB boundary for any burst type, wrapping or not.

  bit [31:0] fixed_length_window;
  assign fixed_length_window = (hburst == HBURST_WRAP4)  ? (( 4 << int'(hsize)) - 1)
                             : (hburst == HBURST_INCR4)  ? (( 4 << int'(hsize)) - 1)
                             : (hburst == HBURST_WRAP8)  ? (( 8 << int'(hsize)) - 1)
                             : (hburst == HBURST_INCR8)  ? (( 8 << int'(hsize)) - 1)
                             : (hburst == HBURST_WRAP16) ? ((16 << int'(hsize)) - 1)
                             : (hburst == HBURST_INCR16) ? ((16 << int'(hsize)) - 1)
                                                         : (( 1 << 10         ) - 1);

  property valid(signal, precondition, kill);
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill)
    precondition |-> !$isunknown(signal);
  endproperty
  assert_valid_htrans: assert property (valid(htrans, 1, kill_valid_htrans)); // All Master signals must be valid always.
  assert_valid_hburst: assert property (valid(hburst, 1, kill_valid_hburst));
  assert_valid_hsize: assert property (valid(hsize, 1, kill_valid_hsize));
  assert_valid_hmastlock: assert property (valid(hmastlock, 1, kill_valid_hmastlock));
  assert_valid_hprot: assert property (valid(hprot, 1, kill_valid_hprot));
  assert_valid_haddr: assert property (valid(haddr, 1, kill_valid_haddr));
  assert_valid_hwrite: assert property (valid(hwrite, 1, kill_valid_hwrite));
  assert_valid_hwdata: assert property (valid(hwdata, 1, kill_valid_hwdata));
  assert_valid_hresp: assert property (valid(hresp, 1, kill_valid_hresp)); // hresp must be valid always.
  assert_valid_hreadyout: assert property (valid(hreadyout, 1, kill_valid_hreadyout)); // hreadyout must be valid always.
  assert_valid_hrdata: assert property (valid(hrdata, (dr_phase && hready && (hresp == HRESP_OKAY)), kill_valid_hrdata)); // hrdata must be valid during the ready cycle of a no-error read data phase.
  assert_valid_hsel: assert property (valid(hsel, 1, kill_valid_hsel)); // hsel is derived from other signals, but still must be valid always.
  assert_valid_hready: assert property (valid(hready, 1, kill_valid_hready)); // hready is derived from other signals, but still must be valid always.

  property stable(signal, precondition, kill);
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill)
    precondition |-> ##1 $stable(signal);
  endproperty
  assert_stable_htrans: assert property (stable(htrans, ((htrans != HTRANS_IDLE) && (htrans != HTRANS_BUSY) && !hready && (hresp != HRESP_ERROR)), kill_stable_htrans)); // All Master signals must be stable except after Idle or Busy or Ready or Abort.
  assert_stable_hburst: assert property (stable(hburst, ((htrans != HTRANS_IDLE) && (htrans != HTRANS_BUSY) && !hready && (hresp != HRESP_ERROR)), kill_stable_hburst));
  assert_stable_hsize: assert property (stable(hsize, ((htrans != HTRANS_IDLE) && (htrans != HTRANS_BUSY) && !hready && (hresp != HRESP_ERROR)), kill_stable_hsize));
  assert_stable_hmastlock: assert property (stable(hmastlock, ((htrans != HTRANS_IDLE) && (htrans != HTRANS_BUSY) && !hready && (hresp != HRESP_ERROR)), kill_stable_hmastlock));
  assert_stable_hprot: assert property (stable(hprot, ((htrans != HTRANS_IDLE) && (htrans != HTRANS_BUSY) && !hready && (hresp != HRESP_ERROR)), kill_stable_hprot));
  assert_stable_haddr: assert property (stable(haddr, ((htrans != HTRANS_IDLE) && (htrans != HTRANS_BUSY) && !hready && (hresp != HRESP_ERROR)), kill_stable_haddr));
  assert_stable_hwrite: assert property (stable(hwrite, ((htrans != HTRANS_IDLE) && (htrans != HTRANS_BUSY) && !hready && (hresp != HRESP_ERROR)), kill_stable_hwrite));
  assert_stable_hwdata: assert property (stable(hwdata, ((htrans != HTRANS_IDLE) && (htrans != HTRANS_BUSY) && !hready && (hresp != HRESP_ERROR)), kill_stable_hwdata));
  assert_stable_hsel: assert property (stable(hsel, ((htrans != HTRANS_IDLE) && (htrans != HTRANS_BUSY) && !hready && (hresp != HRESP_ERROR)), kill_stable_hsel)); // hsel must be stable except after Idle or Busy or Ready or Abort.
  assert_stable_hresp: assert property (stable(hresp, ((hready == 1'b0) ##1 (hready == 1'b1)), kill_stable_hresp)); // hresp must be stable through the two-cycle error response.
  // There are no stability requirements on other slave signals: hrdata, hreadyout.

  // THIS PROPERTY MUST BE DISABLED IF HSEL IS DECODED FROM MORE HADDR BITS THAN ARE VISIBLE AT THIS INTERFACE.
  property hsel_haddr_1kB; // Slave address space must be allocated in size-aligned 1kB blocks, hsel cannot change within a block.
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_hsel_haddr_1kB)
    (1 ##1 $stable(haddr[31:10])) |-> $stable(hsel);
  endproperty
  assert_hsel_haddr_1kB: assert property (hsel_haddr_1kB);

  property haddr_hsize_align; // haddr must be aligned to the hsize of the transfer.
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_haddr_hsize_align)
    (htrans != HTRANS_IDLE) |-> ((haddr & ((1 << hsize) - 1)) == 0);
  endproperty
  assert_haddr_hsize_align: assert property (haddr_hsize_align);

  // The spec (3.5 Burst Operation) says "The address for IDLE transfers must also be aligned, otherwise during simulation it is likely that bus monitors could report spurious warnings".
  // Is that a rule, or not? If it's a rule, then failure of a bus monitor to report it is a bug. "Likely" isn't good enough, "warning" isn't good enough.
  // But a "spurious" warning is a false alarm, and if it's a false alarm, then it's not a rule, just a different monitor bug.
  // You get to decide whether to check IDLE address alignment. To enable the check, turn off the kill bit in the cfg object.
  property haddr_hsize_align_idle;
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_haddr_hsize_align_idle)
    (htrans == HTRANS_IDLE) |-> ((haddr & ((1 << hsize) - 1)) == 0);
  endproperty
  assert_haddr_hsize_align_idle: assert property (haddr_hsize_align_idle);

  property haddr_max;
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_haddr_max)
    ((haddr & ((1 << actual_addr_bus_bits) - 1)) == haddr);
  endproperty
  assert_haddr_max: assert property (haddr_max);

  property hwdata_max;
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_hwdata_max)
    ((hwdata & ((1024'h1 << actual_data_bus_bits) - 1)) == hwdata);
  endproperty
  assert_hwdata_max: assert property (hwdata_max);

  property hrdata_max;
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_hrdata_max)
    ((hrdata & ((1024'h1 << actual_data_bus_bits) - 1)) == hrdata);
  endproperty
  assert_hrdata_max: assert property (hrdata_max);

  property hsize_max; // hsize cannot specify a beat data size greater than the physical bus.
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_hsize_max)
    (htrans != HTRANS_IDLE) |-> (((1 << hsize) << 3) <= actual_data_bus_bits);
  endproperty
  assert_hsize_max: assert property (hsize_max);

  // You also get to decide whether to enforce hsize max during idle.
  property hsize_max_idle;
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_hsize_max_idle)
    (htrans != HTRANS_IDLE) |-> (((1 << hsize) << 3) <= actual_data_bus_bits);
  endproperty
  assert_hsize_max_idle: assert property (hsize_max_idle);

  property htrans_single; // htrans cannot be Seq or Busy immediately after htrans Idle or hburst Single.
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_htrans_single)
    ((htrans == HTRANS_IDLE) || (hburst == HBURST_SINGLE)) |-> ##1 (htrans inside {HTRANS_IDLE, HTRANS_NONSEQ});
  endproperty
  assert_htrans_single: assert property (htrans_single);

  property hmastlock_rise; // hmastlock can only go true with the start of a new transfer.
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_hmastlock_rise)
    ((hmastlock ==1'b0) ##1 (hmastlock == 1'b1)) |-> (htrans == HTRANS_NONSEQ);
  endproperty
  assert_hmastlock_rise: assert property (hmastlock_rise);

  property burst_stable(signal, kill); // Additional stability requirements on signals during a burst, above and beyond the basic per-beat stability requirements above.
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill)
    (1 ##1 (htrans inside {HTRANS_BUSY, HTRANS_SEQ})) |-> $stable(signal);
  endproperty
  assert_burst_stable_hburst: assert property (burst_stable(hburst, kill_burst_stable_hburst));
  assert_burst_stable_hsize: assert property (burst_stable(hsize, kill_burst_stable_hsize));
  assert_burst_stable_hprot: assert property (burst_stable(hprot, kill_burst_stable_hprot));
  assert_burst_stable_haddr: assert property (burst_stable((haddr & ~wrap_window), kill_burst_stable_haddr)); // Address bits above the wrap size of a burst must not change. The wrap window for all incrementing bursts is 1kB.
  assert_burst_stable_hwrite: assert property (burst_stable(hwrite, kill_burst_stable_hwrite));

  property burst_stable_busy(signal, kill);
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill)
    ((htrans == HTRANS_BUSY) ##1 (htrans inside {HTRANS_BUSY, HTRANS_SEQ})) |-> $stable(signal);
  endproperty
  assert_burst_stable_busy: assert property (burst_stable_busy(haddr, kill_burst_stable_busy_haddr));

  // THIS PROPERTY MUST BE DISABLED WHERE A SLAVE ATTACHES TO A FABRIC, IF THE FABRIC IS CAPABLE OF PREEMPTING ONE MASTER TO SERVICE ANOTHER. The slave will have no visibility of the hresp or hready overrides injected by the fabric to the master to cancel or suspend a burst.
  property burst_complete; // A fixed length burst must complete or be cancelled by hresp Error. Only the *first* cycle of the error response can affect address phase signals. On the second cycle, htrans is accepted and the transaction must complete.
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_haddr_burst_step)
    (burst_beats_remain > 0) |-> ((htrans inside {HTRANS_SEQ, HTRANS_BUSY}) || ((hresp == HRESP_ERROR) && hready && (htrans == HTRANS_IDLE)));
  endproperty
  assert_burst_complete: assert property (burst_complete);

  // THIS PROPERTY MUST BE DISABLED WHERE A SLAVE ATTACHES TO A FABRIC, IF THE FABRIC IS CAPABLE OF PREEMPTING ONE MASTER TO SERVICE ANOTHER. The slave will have no visibility of the hresp or hready overrides injected by the fabric to the master to cancel or suspend a burst.
  property haddr_burst_step; // The address of a new beat of a burst must advance by hsize, wrapping within the wrap window as necessary.
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_haddr_burst_step)
    ((htrans inside {HTRANS_NONSEQ, HTRANS_SEQ}) && (hburst != HBURST_SINGLE) && hready) |-> ##1 (((haddr & wrap_window) == ((burst_beat_addr + (1 << hsize)) & wrap_window)) || ((burst_beats_remain == 0) && (htrans inside {HTRANS_IDLE, HTRANS_NONSEQ})));
  endproperty
  assert_haddr_burst_step: assert property (haddr_burst_step);

  property burst_overrun; // A fixed length burst must not overrun burst_beats_remain.
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_burst_overrun)
    ((htrans inside {HTRANS_SEQ, HTRANS_BUSY}) && (hburst inside {hburst_fixed_length_set})) |-> (burst_beats_remain > 0);
  endproperty
  assert_burst_overrun: assert property (burst_overrun);

  property haddr_burst_incr_window_align; // The address of a non-first beat of an incrementing burst cannot be the base address of the wrap window. That is, incrementing burst cannot cross the window boundary nor wrap. The wrap window for all incrementing bursts is 1kB.
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_haddr_burst_incr_window_align)
    ((htrans == HTRANS_SEQ) && (hburst inside {hburst_incr_set})) |-> ((haddr & wrap_window) != 0);
  endproperty
  assert_haddr_burst_incr_window_align: assert property (haddr_burst_incr_window_align);

  // YOU SHOULD DISABLE ONE OF THE NEXT TWO PROPERTIES, BUT NOT BOTH.
  // 3.5.1 Burst termination after a BUSY transfer says "The protocol does not permit a master to end a burst with a BUSY transfer for fixed length bursts".
  // But 5.1.3 ERROR response says that a master can cancel any remaining beats of a burst after an Error response.
  // My best effort to reconcile this is: A BUSY *transfer* is a BUSY accepted by hready. If a master doesn't cancel a burst after the first cycle of an error response, it cannot cancel after the second cycle.
  // But no master can ever cancel any transfer accepted by hready, that's why the protocol needs the two cycle error response in the first place: The first cycle aborts an *address* phase waiting to be accepted, the second cycle is a *data* phase error response. A data phase error does *not* affect an address phase, a transfer accepted by hready must complete *without exception*.
  // So my interpretation is, a fixed length burst *can* be cancelled by the first cycle of an error response, even if htrans is Busy. The master cancels any remaining beats, drives htrans Idle, the Idle is accepted at the end of the second cycle of the error response, and the burst did not end with a "BUSY transfer".
  property burst_end_busy; // Fixed length burst cannot end with htrans == HTRANS_BUSY.
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_burst_end_busy)
    ((htrans == HTRANS_BUSY) && (hburst inside {hburst_fixed_length_set})) |-> ##1 (htrans inside {HTRANS_SEQ, HTRANS_BUSY});
  endproperty
  assert_burst_end_busy: assert property (burst_end_busy);

  property burst_end_busy_error; // Fixed length burst cannot end with htrans == HTRANS_BUSY unless cancelled by hresp Error.
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_burst_end_busy_error)
    ((htrans == HTRANS_BUSY) && (hburst inside {hburst_fixed_length_set}) && ((hresp != HRESP_ERROR) || hready)) |-> ##1 (htrans inside {HTRANS_SEQ, HTRANS_BUSY});
  endproperty
  assert_burst_end_busy_error: assert property (burst_end_busy_error);

  property first_err_cyc; // hready must be low in the first err response cycle.
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_first_err_cyc)
    (((hready == 1'b1) || (hresp == HRESP_OKAY)) ##1 (hresp == HRESP_ERROR)) |-> (hready == 1'b0);
  endproperty
  assert_first_err_cyc: assert property (first_err_cyc);

  property second_err_cyc; // hready must be high in the second err response cycle.
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_second_err_cyc)
    ((hresp == HRESP_ERROR) && (hready == 1'b0)) |-> ##1 (hready == 1'b1);
  endproperty
  assert_second_err_cyc: assert property (second_err_cyc);

  property htrans_error_idle; // Cannot start a new NONSEQ in the second cycle of an error response. It's okay to continue a burst, but otherwise htrans must go Idle.
    @(posedge hclk) disable iff (time0 || (hreset_n == 1'b0) || kill_htrans_error_idle)
    ((hresp == HRESP_ERROR) && !hready && ((htrans == HTRANS_IDLE) || (hburst == HBURST_SINGLE))) |-> ##1 (htrans == HTRANS_IDLE);
  endproperty
  assert_htrans_error_idle: assert property (htrans_error_idle);
endinterface

`endif




