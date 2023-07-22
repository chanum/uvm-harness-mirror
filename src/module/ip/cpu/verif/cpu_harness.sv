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

`ifndef __cpu_harness__
`define __cpu_harness__
// Harness files are read before stub files. The only reason a stub compile token would already be defined is if the real and stub module defs are both being suppressed, in which case the harness def must also be suppressed, since it will have nowhere to bind.
`ifndef __cpu_stub__

interface cpu_harness ();

  import cpu_pkg::*;

  clk_rst_interface clk_rst_if (
    .reset_n (cpu.hreset_n),
    .clk (cpu.hclk)
  );

  assign (pull0, pull1) ahb_if.hsel = 1'b1;
  assign (pull0, pull1) cpu.hready = ahb_if.hreadyout;
  ahb_interface ahb_if (
    .hreset_n (cpu.hreset_n),
    .hclk (cpu.hclk),
    .htrans (cpu.htrans),
    .hburst (cpu.hburst),
    .hsize (cpu.hsize),
    .hprot (cpu.hprot),
    .hmastlock (cpu.hmastlock),
    .haddr (cpu.haddr),
    .hwrite (cpu.hwrite),
    .hwdata (cpu.hwdata),
    .hrdata (cpu.hrdata),
    .hresp (cpu.hresp),
    .hready (cpu.hready)
  );

  class cpu_pharness extends cpu_pharness_base;
    function new(string name);
      super.new(name);
    endfunction
  endclass
  cpu_pharness pharness = new($sformatf("%m"));

  initial begin
    automatic string path = autopublish_path(pharness.get_name());
    publish_vifs(path);
  end

  function automatic void publish_vifs(string path);
    uvm_config_db#(virtual clk_rst_interface)::set(null, path, "clk_rst_if", clk_rst_if);
    uvm_config_db#(virtual ahb_interface)::set(null, path, "ahb_if", ahb_if);
    uvm_config_db#(cpu_pharness_base)::set(null, path, "harness", pharness);
  endfunction
endinterface

bind cpu cpu_harness harness();

`endif
`endif

