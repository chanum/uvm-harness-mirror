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

`ifndef __barrel_shift__
`define __barrel_shift__

module barrel_shift #(BITS = 1) (
  input [BITS-1:0] in,
  input [$clog2(BITS)-1:0] shift,
  output [BITS-1:0] out
);

  wire [(2*BITS)-1:0] wrap_in;

  assign wrap_in = {2{in}};
  assign out = wrap_in[shift +: BITS];
endmodule

`endif

