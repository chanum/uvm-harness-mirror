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

`ifndef __arb_stub__
`define __arb_stub__
// A stub module def file is always read before its real counterpart, so a predefined __module_name__ token allows the stub to be compiled instead. Unless the __module_name_stub__ token is also predefined, in which case
// no module def is compiled at all. That might be appropriate if e.g. a parent module higher in the design hierarchy is stubbed out, and then either def of the lower module would be a nuisance implicit top-level instance.
`ifdef __arb__

module arb#(WAY = 2) ( // Stub ignores instance width param, uses fixed max width.
  input                                         reset_n,
  input                                         clk,
  input [arb_verif_param_pkg::WAY-1:0]          req,
  input [arb_verif_param_pkg::WAY-1:0]          lock,
  input [arb_verif_param_pkg::WAY-1:0]          ack,
  output [arb_verif_param_pkg::WAY-1:0]         gnt,
  output [$clog2(arb_verif_param_pkg::WAY)-1:0] owner
);

  assign (pull1, pull0) gnt = arb_param_pkg::WAY_t'(1);
  assign (pull1, pull0) owner = '0;
endmodule

`endif
`endif

