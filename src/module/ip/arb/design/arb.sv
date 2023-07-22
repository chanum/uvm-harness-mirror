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

`ifndef __arb__
`define __arb__

module arb#(WAY = 2) (
  input reset_n,
  input clk,
  input  [WAY-1:0] req,
  input  [WAY-1:0] lock,
  input  [WAY-1:0] ack,
  output [WAY-1:0] gnt,
  output reg [$clog2(WAY)-1:0] owner
);

  wire [WAY-1:0] shift_req;
  wire [WAY-1:0] shift_winner_hot;
  wire [WAY-1:0] rev_shift_winner_hot;
  wire [WAY-1:0] rev_winner_hot;
  wire [WAY-1:0] winner_hot;
  wire winner_nz;
  wire [$clog2(WAY)-1:0] winner_bin;
  wire [$clog2(WAY)-1:0] round_robin_shift;

  assign gnt = ({{WAY-1{1'b0}}, 1'b1} << owner);

  always @(posedge clk or negedge reset_n) begin
    if (reset_n == 1'b0) begin
      owner <= 0;
    end
    else begin
      if (winner_nz) begin // So that owner doesn't revert to 0 just because there's no req.
        if (gnt & (ack | ~req)) begin // Current owner can always get one more access in the ack cycle.
          owner <= winner_bin;
        end
      end
    end
  end

  assign round_robin_shift = owner + !lock[owner]; // Without lock, the current owner req is at the lowest-priority end of the round-robin field of reqs. With lock, the current owner req is at the highest-priority end of the field. The current owner can still lose the bus if it drops its req, regardless of lock.

  barrel_shift #(.BITS(WAY)) barrel_shift_0 (
    .in (req),
    .shift (round_robin_shift),
    .out (shift_req)
  );

  first1 #(.BITS(WAY)) first1_0 (
    .in (shift_req),
    .out (shift_winner_hot)
  );

  reverse #(.BITS(WAY)) reverse_0 (
    .in (shift_winner_hot),
    .out (rev_shift_winner_hot)
  );

  barrel_shift #(.BITS(WAY)) barrel_shift_1 (
    .in (rev_shift_winner_hot),
    .shift (round_robin_shift),
    .out (rev_winner_hot)
  );

  reverse #(.BITS(WAY)) reverse_1 (
    .in (rev_winner_hot),
    .out (winner_hot)
  );

  hot2bin #(.BITS(WAY)) hot2bin_0 (
    .hot (winner_hot),
    .bin (winner_bin),
    .nz (winner_nz)
  );
endmodule

`endif

