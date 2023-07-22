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

`ifndef __aomux__
`define __aomux__

module aomux #(WAYS = 1, BITS = 1) (
  input [WAYS-1:0][BITS-1:0] in,
  input [WAYS-1:0] sel,
  output reg [BITS-1:0] out
);

  always_comb begin
    out = '0;
    foreach (sel[w]) begin
      if (sel[w]) begin
        out |= in[w];
      end
    end
  end
endmodule

`endif

