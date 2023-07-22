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

`ifndef __arb_interface__
`define __arb_interface__

interface arb_interface  #(WAY = arb_param_pkg::WAY) (
  input reset_n,
  input clk,
  input [WAY-1:0] req,
  input lock,
  input [WAY-1:0] ack,
  input [WAY-1:0] gnt,
  input [$clog2(WAY)-1:0] owner
);

  import arb_pkg::*;
  arb_vip_cfg cfg;

  event sync_icb_ev;
  event ad_hoc_ocb_ev;

  clocking icb @(posedge clk);
    input reset_n;
    input req;
    input lock;
    input ack;
    input gnt;
    input owner;
  endclocking

  clocking ocb @(posedge clk or ad_hoc_ocb_ev);
    output req;
    output lock;
    output ack;
    output gnt;
    output owner;
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
    wait ($isunknown({reset_n, clk}) == 1'b0);
    fork
      forever @({reset_n, clk}) begin
        assert ($isunknown({reset_n, clk}) == 1'b0); // From the moment both reset_n and clk become valid, they can never again be unknown.
      end

      forever begin
        wait (reset_n == 1'b0);
        time0 = 0;
        wait (reset_n == 1'b1);
        assert (gnt == arb_param_pkg::WAY_t'(1)); // Coming out of reset, requester 0 has grant by default.
        assert (owner == '0); // Coming out of reset, requester 0 owns the resource by default.
      end
    join
  end
endinterface

`endif

