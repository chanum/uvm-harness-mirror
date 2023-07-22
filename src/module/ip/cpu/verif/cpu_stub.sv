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

`ifndef __cpu_stub__
`define __cpu_stub__
// A stub module def file is always read before its real counterpart, so a predefined __module_name__ token allows the stub to be compiled instead. Unless the __module_name_stub__ token is also predefined, in which case
// no module def is compiled at all. That might be appropriate if e.g. a parent module higher in the design hierarchy is stubbed out, and then either def of the lower module would be a nuisance implicit top-level instance.
`ifdef __cpu__

module cpu (
  input hreset_n,
  input hclk,
  output [1:0] htrans,
  output [2:0] hburst,
  output [2:0] hsize,
  output [3:0] hprot,
  output hmastlock,
  output [cpu_verif_param_pkg::HADDR-1:0] haddr,
  output hwrite,
  output [cpu_verif_param_pkg::HDATA-1:0] hwdata,
  input [cpu_verif_param_pkg::HDATA-1:0] hrdata,
  input hresp,
  input hready
);

  assign (pull1, pull0) htrans = '0;
  assign (pull1, pull0) hburst = '0;
  assign (pull1, pull0) hsize = '0;
  assign (pull1, pull0) hprot = '0;
  assign (pull1, pull0) hmastlock = '0;
  assign (pull1, pull0) haddr = '0;
  assign (pull1, pull0) hwrite = '0;
  assign (pull1, pull0) hwdata = '0;
endmodule

`endif
`endif

