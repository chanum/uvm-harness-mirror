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

`ifndef __first1__
`define __first1__

module first1 #(BITS = 1) (
  input [BITS-1:0] in,
  output reg [BITS-1:0] out
);

  always @(in) begin
    automatic int first = BITS;
    foreach (in[i]) begin
      if (in[i]) begin
        if (i < first) begin
          first = i;
        end
      end
    end
    out = {{BITS{1'b0}}, 1'b1} << first;
  end
endmodule

`endif

