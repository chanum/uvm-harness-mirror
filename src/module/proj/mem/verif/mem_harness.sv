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

`ifndef __mem_harness__
`define __mem_harness__
// Harness files are read before stub files. The only reason a stub compile token would already be defined is if the real and stub module defs are both being suppressed, in which case the harness def must also be suppressed, since it will have nowhere to bind.
`ifndef __mem_stub__

interface mem_harness #(ADDR = 32, DATA = 32) (); // Harness doesn't use instance width param(s) itself (uses max width param(s)), but makes available to testbench components.

  import mem_pkg::*;

  clk_rst_interface clk_rst_if (
    .reset_n (mem.hreset_n),
    .clk (mem.hclk)
  );

  assign (pull0, pull1) mem.hsel = 1'b1;
  assign (pull0, pull1) mem.hready = mem.hreadyout;
  ahb_interface ahb_if (
    .hreset_n (mem.hreset_n),
    .hclk (mem.hclk),
    .hsel (mem.hsel),
    .htrans (mem.htrans),
    .hburst (mem.hburst),
    .hsize (mem.hsize),
    .hprot (mem.hprot),
    .hmastlock (mem.hmastlock),
    .haddr (mem.haddr),
    .hwrite (mem.hwrite),
    .hwdata (mem.hwdata),
    .hrdata (mem.hrdata),
    .hresp (mem.hresp),
    .hreadyout (mem.hreadyout),
    .hready (mem.hready)
  );

`ifndef __mem__
  function bit[mem_verif_param_pkg::DATA-1:0] peek(bit[mem_verif_param_pkg::ADDR-1:0] addr);
    //body
  endfunction

  function void poke(bit[mem_verif_param_pkg::ADDR-1:0] addr, bit[mem_verif_param_pkg::DATA-1:0] data);
    //body
  endfunction

  function void load(string src);
    //body
  endfunction
`endif

  class mem_pharness extends mem_pharness_base;
    function new(string name = "mem_pharness");
      super.new(name);
      ADDR = mem_harness.ADDR;
      DATA = mem_harness.DATA;
    endfunction

`ifndef __mem__
    virtual function bit[mem_verif_param_pkg::DATA-1:0] peek(bit[mem_verif_param_pkg::ADDR-1:0] addr);
      mem_harness.peek();
    endfunction

    virtual function void poke(bit[mem_verif_param_pkg::ADDR-1:0] addr, bit[mem_verif_param_pkg::DATA-1:0] data);
      mem_harness.poke();
    endfunction

    virtual function void load(string src);
      mem_harness.load();
    endfunction
`endif
  endclass
  mem_pharness pharness = new($sformatf("%m"));

  initial begin
    automatic string path = autopublish_path(pharness.get_name());
    publish_vifs(path);
  end

  function automatic void publish_vifs(string path);
    uvm_config_db#(virtual clk_rst_interface)::set(null, path, "clk_rst_if", clk_rst_if);
    uvm_config_db#(virtual ahb_interface)::set(null, path, "ahb_if", ahb_if);
    uvm_config_db#(mem_pkg::mem_pharness_base)::set(null, path, "harness", pharness);
  endfunction
endinterface

bind mem mem_harness#(.ADDR(ADDR), .DATA(DATA)) harness();

`endif
`endif

