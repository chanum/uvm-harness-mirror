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

`ifndef __hot2bin__
`define __hot2bin__

module hot2bin #(BITS = 1) (
  input [BITS-1:0] hot,
  output reg [$clog2(BITS)-1:0] bin,
  output reg nz // Flag bit that says hot was actually "hot", not zero.
);

  always @(hot) begin
    bin = 0;
    foreach (hot[i]) begin
      if (hot[i]) begin
        bin |= i;
      end
    end
    nz = (| hot);
  end
endmodule

`endif

