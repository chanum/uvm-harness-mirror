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

`ifndef __ahb_fabric__
`define __ahb_fabric__

module ahb_fabric#(MST = 1, SLV = 1, MST_ADDR = 32, SLV_ADDR = 32, DATA = 32, BURST_LOCK = 0) (
  // BURST_LOCK: 0 = Gnt can be taken away from current owner in the middle of a burst. 1 = Current owner will be given gnt for duration of burst.
  input hreset_n,
  input hclk,
  input  [MST-1:0] mst_hsel,
  input  [MST-1:0][1:0] mst_htrans,
  input  [MST-1:0][2:0] mst_hburst,
  input  [MST-1:0][2:0] mst_hsize,
  input  [MST-1:0][3:0] mst_hprot,
  input  [MST-1:0] mst_hmastlock,
  input  [MST-1:0][MST_ADDR-1:0] mst_haddr,
  input  [MST-1:0] mst_hwrite,
  input  [MST-1:0][DATA-1:0] mst_hwdata,
  output [MST-1:0][DATA-1:0] mst_hrdata,
  output reg [MST-1:0] mst_hresp,
  output reg [MST-1:0] mst_hreadyout,
  input  [MST-1:0] mst_hready,
  output [SLV-1:0][1:0] slv_htrans,
  output [SLV-1:0][2:0] slv_hburst,
  output [SLV-1:0][2:0] slv_hsize,
  output [SLV-1:0][3:0] slv_hprot,
  output [SLV-1:0] slv_hmastlock,
  output [SLV-1:0][SLV_ADDR-1:0] slv_haddr,
  output [SLV-1:0] slv_hwrite,
  output [SLV-1:0][DATA-1:0] slv_hwdata,
  input  [SLV-1:0][DATA-1:0] slv_hrdata,
  input  [SLV-1:0] slv_hresp,
  input  [SLV-1:0] slv_hready
  // Every slave port is arbitrated independently, that is, one master only owns one slave at a time.
  // Multiple masters can access multiple slaves in parallel.
);

  import ahb_names_pkg::*;

  reg  [MST-1:0] fab_hsel;
  reg  [MST-1:0][1:0] fab_htrans;
  reg  [MST-1:0][2:0] fab_hburst;
  reg  [MST-1:0][2:0] fab_hsize;
  reg  [MST-1:0][3:0] fab_hprot;
  reg  [MST-1:0] fab_hmastlock;
  reg  [MST-1:0][MST_ADDR-1:0] fab_haddr;
  reg  [MST-1:0] fab_hwrite;

  wire [MST-1:0] mst_lock;
  wire [MST-1:0][MST_ADDR:0] mst_xaddr;
  wire [MST-1:0][SLV-1:0] mst_dec;
  wire [MST-1:0][((SLV > 1) ? $clog2(SLV) : 1)-1:0] mst_a_target;
  wire [MST-1:0] mst_a_active;

  wire [MST-1:0] fab_lock;
  wire [MST-1:0][MST_ADDR:0] fab_xaddr;
  wire [MST-1:0][SLV-1:0] fab_dec;
  wire [MST-1:0][((SLV > 1) ? $clog2(SLV) : 1)-1:0] fab_a_target;
  wire [MST-1:0] fab_a_active;

  reg  [MST-1:0] fab_val;
  reg  [MST-1:0] fab_xval;
  reg  [MST-1:0] fab_hresp;

  wire [MST-1:0] a_hsel;
  wire [MST-1:0][1:0] a_htrans;
  wire [MST-1:0][2:0] a_hburst;
  wire [MST-1:0][2:0] a_hsize;
  wire [MST-1:0][3:0] a_hprot;
  wire [MST-1:0] a_hmastlock;
  wire [MST-1:0][MST_ADDR-1:0] a_haddr;
  wire [MST-1:0] a_hwrite;

  wire [MST-1:0][SLV-1:0] a_dec;
  reg  [MST-1:0] a_req;
  wire [MST-1:0][SLV-1:0] a_req_arb;
  wire [MST-1:0] a_lock;
  wire [MST-1:0] a_active;
  wire [MST-1:0] a_decerr;

  wire [MST-1:0][((SLV > 1) ? $clog2(SLV) : 1)-1:0] a_target;
  reg  [MST-1:0][((SLV > 1) ? $clog2(SLV) : 1)-1:0] d_target;
  wire [MST-1:0] same_target;
  reg  [MST-1:0] d_active;
  reg  [MST-1:0] d_decerr;
  reg  [MST-1:0] d_decerr_hready;

  wire [SLV-1:0][MST-1:0] a_arb_req;
  wire [SLV-1:0][MST-1:0] arb_req;
  wire [SLV-1:0][MST-1:0] arb_ack;
  wire [SLV-1:0][MST-1:0] arb_gnt;
  wire [SLV-1:0][MST-1:0] a_ack;
  wire [SLV-1:0][MST-1:0] a_hresp;
  wire [SLV-1:0][MST-1:0] a_gnt;
  reg  [SLV-1:0][MST-1:0] d_gnt;
  wire [SLV-1:0][((MST > 1) ? $clog2(MST) : 1)-1:0] a_owner;
  reg  [SLV-1:0][((MST > 1) ? $clog2(MST) : 1)-1:0] d_owner;

  wire [MST-1:0] mst_R;
  wire [MST-1:0] mst_E;
  wire [MST-1:0] mst_EE;

  wire [SLV-1:0] slv_R;
  wire [SLV-1:0] slv_E;
  wire [SLV-1:0] slv_EE;

  for (genvar m = 0; m < MST; ++m) begin
    // Truth table for the fabric capturing and holding master A-phase signals, slave arb request, and master response (hresp, hready).
    //
    // a_tgt==d_tgt means mst_a_target. fab_a_target is always equal d_target if fab_val, and meaningless otherwise
    // E means hresp error first cycle, EE means second, R means hready without error
    // capture is not a state bit at all, it's just an annotation of when a capture should happen
    // fab_val, fab_hresp are Moore (reg) outputs, a_req, mst_hresp, mst_hready are Mealy (combi) outputs
    //
    // mst_a_active      capture (event)
    //   d_active          fab_val [1][2]
    //     a_tgt==d_tgt      fab_hresp
    //       fab_val             a_req [2]
    //         a_gnt               mst_hresp [2]
    //           a_ack               mst_hready [2]
    //             a_hresp
    //               fab_hresp
    // ----------------+-------+------
    // . . . . 0 . 1 . | . . . | . . .   Unreachable: a_hresp without gnt
    // . . . . 0 1 . . | . . . | . . .   Unreachable: ack without gnt
    // . . . . 1 . 0 1 | . . . | . . .   Unreachable: gnt and fab_hresp without a_hresp
    // . . . . 1 0 . 1 | . . . | . . .   Unreachable: gnt and fab_hresp without ack
    // . . . . 1 1 1 0 | . . . | . . .   Unreachable: aEE without fab_hresp. No fab_hresp means we didn't have gnt during aE. aE blocks all req to arb so gnt cannot change btw aE/aEE, and can't see gnt in aEE wo fab_hresp (fabric doesn't let mst see aEE wo aE)
    // . . . 1 . . . 1 | . . . | . . .   Unreachable: fab_hresp with fab_val
    // . 0 . 1 . . . . | . . . | . . .   Unreachable: fab_val without D
    // . 0 1 . . . . . | . . . | . . .   Unreachable: a_target == d_target without D
    // 0 . 1 . . . . . | . . . | . . .   Unreachable: a_target == d_target without A
    // 0 . . 0 1 . . . | . . . | . . .   Unreachable: No A means no req, no req means no gnt
    // 1 . . . 0 . . 1 | . . . | . . .   Unreachable: fab_hresp means we had gnt in aE, if mst doesn't cancel then we must still have gnt in aEE. Has to be old A not cancelled: If fab_hresp then mst saw aE and shouldn't start new A in aEE
    // 1 1 0 0 1 . . . | . . . | . . .   Unreachable: Mst A and D to diff slv and no fab_val means no req, so no gnt
    // 1 1 . 0 . . . 1 | . . . | . . .   Unreachable: D and no fab_val means D started on slv, diff slv means can't req, can't get gnt, can't have fab_hresp, same slv means E is dE, fab_hresp doesn't capture dE
    // ----------------+-------+------
    // 0 0 0 0 0 0 0 0 | 0 0 0 | 0 0 1   Idle mst gets default hready from fabric
    // 0 0 0 0 0 0 0 1 | 0 0 0 | 0 1 1   Fabric will always cancel on E, but fab_hresp always injects EE
    // 0 1 0 0 0 0 0 0 | 0 0 0 | 0 d d   Mst with D and no A gets d hresp, hready
    // 0 1 0 0 0 0 0 1 | 0 0 0 | 0 1 1   Fabric will always cancel on E, but fab_hresp always injects EE
    // 0 1 0 1 0 0 0 0 | 0 1 0 | 1 0 0   fab_val means D not started, fabric holds A until ack
    // 0 1 0 1 1 0 0 0 | 0 1 0 | 1 0 0   fab_val means D not started, fabric holds A until ack
    // 0 1 0 1 1 0 1 0 | 0 0 1 | 1 1 0   aE cancels fab_val, passed through to mst
    // 0 1 0 1 1 1 0 0 | 0 0 0 | 1 0 0   fab_val consumes ack, lets go
    // 1 0 0 0 0 0 0 0 | 1 1 0 | 1 0 1   Mst with no D and no gnt gets default hready from fabric, fabric captures A
    // 1 0 0 0 1 0 0 0 | 0 0 0 | 1 0 0   Mst A and gnt, fabric not involved
    // 1 0 0 0 1 0 1 0 | 0 0 1 | 1 1 0   Mst A and gnt and aE, fabric not involved
    // 1 0 0 0 1 1 0 0 | 0 0 0 | 1 0 1   Mst A and ack, fabric not involved
    // 1 0 0 0 1 1 1 1 | 0 0 0 | 1 1 1   Mst A and gnt and aEE, fabric not involved
    // 1 1 0 0 0 0 0 0 | R R 0 | R d d   Mst A and D to diff slv, no fab_val means D started on slv, can't req, fabric not involved until D done. dE+ passes through, dR kinda like 1 0 0 0 0 0 0 0 (R ends first D) except mst_hready from d instead of fabric
    // 1 1 0 1 0 0 0 0 | 0 1 0 | 1 0 0   fab_val means D not started, fabric holds A until ack
    // 1 1 0 1 1 0 0 0 | 0 1 0 | 1 0 0   fab_val means D not started, fabric holds A until ack
    // 1 1 0 1 1 0 1 0 | 0 0 1 | 1 1 0   aE cancels fab_val, passed through to mst
    // 1 1 0 1 1 1 0 0 | 0 0 0 | 1 0 0   fab_val consumes ack, lets go
    // 1 1 1 0 0 0 0 0 | R R 0 | 1 d d   D and no fab_val means D started on slv. A and D means old A was accepted, must have lost gnt after accept, so will lose D when done, fabric not involved til then. dE+ passes through, dR kinda like 1 0 0 0 0 0 0 0 (R ends first D) except mst_hready from d instead of fabric
    // 1 1 1 0 1 0 0 0 | 0 0 0 | 1 d d   Mst A and D to same slv, and gnt, fabric not involved
    // 1 1 1 0 1 0 1 0 | 0 0 0 | 1 d d   Mst A and D to same slv, and gnt, fabric not involved
    // 1 1 1 0 1 1 0 0 | 0 0 0 | 1 d d   Mst A and D to same slv, and gnt, fabric not involved
    // 1 1 1 1 0 0 0 0 | 0 1 0 | 1 0 0   fab_val means D not started, fabric holds A until ack
    // 1 1 1 1 1 0 0 0 | 0 1 0 | 1 0 0   fab_val means D not started, fabric holds A until ack
    // 1 1 1 1 1 0 1 0 | 0 0 1 | 1 1 0   aE cancels fab_val, passed through to mst
    // 1 1 1 1 1 1 0 0 | 0 0 0 | 1 0 0   fab_val consumes ack, lets go
    // ----------------+-------+------
    // 0 0 . . . . . 0 | 0 0 0 | 0 0 1
    // 0 1 . 0 . . . . | 0 0 0 | 0 d d [2]
    // 0 . . . . . . 1 | 0 0 0 | 0 1 1
    // . . . 1 . 0 0 . | 0 1 0 | 1 0 0
    // . . . 1 . . 1 . | 0 0 1 | 1 1 0
    // . . . 1 . 1 . . | 0 0 0 | 1 0 0
    // 1 0 . . 0 . . . | 1 1 0 | 1 0 1
    // 1 0 . . 1 . . . | 0 0 E | 1 a a
    // . . 1 0 1 . . . | 0 0 0 | 1 d d [2]
    // . . 1 0 0 . . . | R R 0 | 1 d d [2]
    // 1 1 0 0 . . . . | R R 0 | R d d [2]
    //
    // [1] HTRANS_BUSY is an "a_active" code, but fab_val and d_active never set on HTRANS_BUSY.
    // [2] a_decerr: fab_val never set, a_req blocked to arb, hresp, hready "d d" come from d_decerr state machine.

    always @(posedge hclk or negedge hreset_n) begin
      if (hreset_n == 1'b0) begin
        fab_hsel[m] <= '0;
        fab_htrans[m] <= HTRANS_IDLE;
        fab_hburst[m] <= HBURST_SINGLE;
        fab_hsize[m] <= '0;
        fab_hprot[m] <= '0;
        fab_hmastlock[m] <= '0;
        fab_haddr[m] <= '0;
        fab_hwrite[m] <= '0;
        fab_val[m] <= '0;
        fab_xval[m] <= '0;
        fab_hresp[m] <= '0;
        d_active[m] <= '0;
        d_target[m] <= '0;
        d_decerr[m] <= '0;
      end
      else begin
        fab_xval[m] <= fab_val[m];
        fab_val[m] <= 0;
        fab_hresp[m] <= 0;
        unique casez ({mst_a_active[m], d_active[m], same_target[m], fab_val[m], a_gnt[a_target[m]][m], a_ack[a_target[m]][m], a_hresp[a_target[m]][m], fab_hresp[m]})
          'b00?????0 ,
          'b01?0???? ,
          'b0??????1 ,
          'b???1?1?? ,
          'b??101??? : begin // All valid case expr values, so we have to have a case item for them.
          end
          'b???1?00? : begin
            fab_val[m] <= 1;
          end
          'b???1??1? : begin
            fab_hresp[m] <= 1;
          end
          'b10??1??? : begin
            fab_hresp[m] <= mst_E[m];
          end
          'b10??0??? : begin
            fab_hsel[m] <= mst_hsel[m];
            fab_htrans[m] <= mst_htrans[m];
            fab_hburst[m] <= mst_hburst[m];
            fab_hsize[m] <= mst_hsize[m];
            fab_hprot[m] <= mst_hprot[m];
            fab_hmastlock[m] <= mst_hmastlock[m];
            fab_haddr[m] <= mst_haddr[m];
            fab_hwrite[m] <= mst_hwrite[m];
            fab_val[m] <= (mst_htrans[m] != HTRANS_BUSY) && (! a_decerr[m]);
          end
          'b??100??? ,
          'b1100???? : begin
            if (mst_R[m]) begin
              fab_hsel[m] <= mst_hsel[m];
              fab_htrans[m] <= mst_htrans[m];
              fab_hburst[m] <= mst_hburst[m];
              fab_hsize[m] <= mst_hsize[m];
              fab_hprot[m] <= mst_hprot[m];
              fab_hmastlock[m] <= mst_hmastlock[m];
              fab_haddr[m] <= mst_haddr[m];
              fab_hwrite[m] <= mst_hwrite[m];
              fab_val[m] <= (mst_htrans[m] != HTRANS_BUSY) && (! a_decerr[m]);
            end
          end
        endcase
        if (mst_hready[m]) begin
          d_active[m] <= a_active[m] && (a_htrans[m] != HTRANS_BUSY);
          d_target[m] <= a_target[m];
          d_decerr[m] <= a_decerr[m];
        end
      end
    end

    always_comb begin
      unique casez ({mst_a_active[m], d_active[m], same_target[m], fab_val[m], a_gnt[a_target[m]][m], a_ack[a_target[m]][m], a_hresp[a_target[m]][m], fab_hresp[m]})
        'b00?????0 : begin
          a_req[m] = 0;
          mst_hresp[m] = 0;
          mst_hreadyout[m] = 1;
        end
        'b0??????1 : begin
          a_req[m] = 0;
          mst_hresp[m] = 1;
          mst_hreadyout[m] = 1;
        end
        'b???1?00? ,
        'b???1?1?? : begin
          a_req[m] = 1;
          mst_hresp[m] = 0;
          mst_hreadyout[m] = 0;
        end
        'b10??0??? : begin
          a_req[m] = 1;
          mst_hresp[m] = 0;
          mst_hreadyout[m] = 1;
        end
        'b???1??1? : begin
          a_req[m] = 1;
          mst_hresp[m] = 1;
          mst_hreadyout[m] = 0;
        end
        'b10??1??? : begin
          a_req[m] = 1;
          mst_hresp[m] = slv_hresp[a_target[m]];
          mst_hreadyout[m] = slv_hready[a_target[m]];
        end
        'b01?0???? : begin
          a_req[m] = 0;
          mst_hresp[m] = d_gnt[d_target[m]] ? slv_hresp[d_target[m]] : d_decerr[m];
          mst_hreadyout[m] = d_gnt[d_target[m]] ? slv_hready[d_target[m]] : d_decerr_hready[m];
        end
        'b??101??? ,
        'b??100??? : begin
          a_req[m] = 1;
          mst_hresp[m] = d_gnt[d_target[m]] ? slv_hresp[d_target[m]] : d_decerr[m];
          mst_hreadyout[m] = d_gnt[d_target[m]] ? slv_hready[d_target[m]] : d_decerr_hready[m];
        end
        'b1100???? : begin
          a_req[m] = slv_R[d_target[m]];
          mst_hresp[m] = d_gnt[d_target[m]] ? slv_hresp[d_target[m]] : d_decerr[m];
          mst_hreadyout[m] = d_gnt[d_target[m]] ? slv_hready[d_target[m]] : d_decerr_hready[m];
        end
      endcase
    end

    always @(posedge hclk or negedge hreset_n) begin
      if (hreset_n == 1'b0) begin
        d_decerr_hready[m] <= 1'b0;
      end
      else begin
        d_decerr_hready[m] <= d_decerr[m] && (! d_decerr_hready[m]);
      end
    end

    assign same_target[m] = mst_a_active[m] && d_active[m] && (mst_a_target[m] == d_target[m]);

    assign mst_R[m] = ({mst_hresp[m], mst_hready[m]} == 'b01);
    assign mst_E[m] = ({mst_hresp[m], mst_hready[m]} == 'b10);
    assign mst_EE[m] = ({mst_hresp[m], mst_hready[m]} == 'b11);

    assign a_hsel[m] = fab_val[m] ? fab_hsel[m] : mst_hsel[m];
    assign a_htrans[m] = fab_val[m] ? fab_htrans[m] : mst_htrans[m];
    assign a_hburst[m] = fab_val[m] ? fab_hburst[m] : mst_hburst[m];
    assign a_hsize[m] = fab_val[m] ? fab_hsize[m] : mst_hsize[m];
    assign a_hprot[m] = fab_val[m] ? fab_hprot[m] : mst_hprot[m];
    assign a_hmastlock[m] = fab_val[m] ? fab_hmastlock[m] : mst_hmastlock[m];
    assign a_haddr[m] = (fab_val[m] || (fab_xval[m] && same_target[m] && mst_EE[m])) ? fab_haddr[m] : mst_haddr[m];
    assign a_hwrite[m] = fab_val[m] ? fab_hwrite[m] : mst_hwrite[m];

    assign mst_a_active[m] = mst_hsel[m] && (mst_htrans[m] != HTRANS_IDLE);
    assign mst_xaddr[m] = {1'b0, mst_haddr[m]};
    assign mst_a_target[m] = mst_xaddr[m][SLV_ADDR +: ((SLV > 1) ? $clog2(SLV) : 1)];
    assign mst_dec[m] = {{SLV-1{1'b0}}, 1'b1} << mst_xaddr[m][MST_ADDR:SLV_ADDR];
    assign mst_lock[m] = (((mst_htrans[m] != HTRANS_IDLE) && (mst_hburst[m] != HBURST_SINGLE)) && BURST_LOCK) || mst_hmastlock[m];

    assign fab_a_active[m] = fab_hsel[m] && (fab_htrans[m] != HTRANS_IDLE);
    assign fab_xaddr[m] = {1'b0, fab_haddr[m]};
    assign fab_a_target[m] = fab_xaddr[m][SLV_ADDR +: ((SLV > 1) ? $clog2(SLV) : 1)];
    assign fab_dec[m] = {{SLV-1{1'b0}}, 1'b1} << fab_xaddr[m][MST_ADDR:SLV_ADDR];
    assign fab_lock[m] = (((fab_htrans[m] != HTRANS_IDLE) && (fab_hburst[m] != HBURST_SINGLE)) && BURST_LOCK) || fab_hmastlock[m];

    assign a_active[m] = fab_val[m] ? fab_a_active[m] : mst_a_active[m];
    assign a_target[m] = fab_val[m] ? fab_a_target[m] : mst_a_target[m];
    assign a_dec[m] = fab_val[m] ? fab_dec[m] : mst_dec[m];
    assign a_lock[m] = fab_val[m] ? fab_lock[m] : mst_lock[m];
    assign a_decerr[m] = a_req[m] && (! (| a_dec[m]));

    assign a_req_arb[m] = a_dec[m] & {SLV{a_req[m] && (a_htrans[m] != HTRANS_BUSY)}};

    assign mst_hrdata[m] = {DATA{d_owner[d_target[m]] == m}} & slv_hrdata[d_target[m]];
  end

  transpose #(.A(MST), .B(SLV)) transpose_req (
    .in (a_req_arb),
    .out (a_arb_req)
  );

  for (genvar s = 0; s < SLV; ++s) begin : arb
    assign arb_req[s] = a_arb_req[s] & {MST{! slv_E[s]}};

    arb #(.WAY(MST)) arb_0 (
      .reset_n (hreset_n),
      .clk (hclk),
      .req (arb_req[s]),
      .lock (a_lock),
      .ack (arb_ack[s]),
      .gnt (arb_gnt[s]),
      .owner (a_owner[s])
    );

    assign arb_ack[s] = {MST{slv_hready[s]}} & arb_gnt[s];
    assign a_gnt[s] = arb_gnt[s] & a_arb_req[s] & ({MST{! slv_EE[s]}} | fab_hresp);
    assign a_ack[s] = {MST{slv_hready[s]}} & a_gnt[s];
    assign a_hresp[s] = {MST{slv_hresp[s]}} & a_gnt[s];

    assign slv_htrans[s] = {2{a_target[a_owner[s]] == s}} & a_htrans[a_owner[s]];
    assign slv_hburst[s] = {3{a_target[a_owner[s]] == s}} & a_hburst[a_owner[s]];
    assign slv_hsize[s] = {3{a_target[a_owner[s]] == s}} & a_hsize[a_owner[s]];
    assign slv_hprot[s] = {4{a_target[a_owner[s]] == s}} & a_hprot[a_owner[s]];
    assign slv_hmastlock[s] = (a_target[a_owner[s]] == s) & a_hmastlock[a_owner[s]];
    assign slv_haddr[s] = {SLV_ADDR{a_target[a_owner[s]] == s}} & a_haddr[a_owner[s]][SLV_ADDR-1:0];
    assign slv_hwrite[s] = (a_target[a_owner[s]] == s) & a_hwrite[a_owner[s]];
    assign slv_hwdata[s] = {DATA{d_target[d_owner[s]] == s}} & mst_hwdata[d_owner[s]];

    always @(posedge hclk or negedge hreset_n) begin
      if (hreset_n == 1'b0) begin
        d_owner[s] <= '0;
        d_gnt[s] <= '0;
      end
      else begin
        if (slv_hready[s]) begin
          d_owner[s] <= a_owner[s];
          d_gnt[s] <= arb_gnt[s] & a_arb_req[s];
        end
      end
    end

    assign slv_R[s] = ({slv_hresp[s], slv_hready[s]} == 'b01);
    assign slv_E[s] = ({slv_hresp[s], slv_hready[s]} == 'b10);
    assign slv_EE[s] = ({slv_hresp[s], slv_hready[s]} == 'b11);
  end
endmodule

`endif

