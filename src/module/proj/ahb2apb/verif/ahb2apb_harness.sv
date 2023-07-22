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

`ifndef __ahb2apb_harness__
`define __ahb2apb_harness__
// Harness files are read before stub files. The only reason a stub compile token would already be defined is if the real and stub module defs are both being suppressed, in which case the harness def must also be suppressed, since it will have nowhere to bind.
`ifndef __ahb2apb_stub__

interface ahb2apb_harness#(ADDR = 32, HDATA = 32, PDATA = 32) ();

  import ahb2apb_pkg::*;

  initial begin // Parameter legality checks.
    if (ADDR < $clog2(((HDATA > PDATA) ? HDATA : PDATA) >> 3)) begin
      `uvm_fatal($sformatf("%m"), $sformatf("Addr width ADDR (%0d) must be at least enough bits to address every byte of either data bus width, clog2(max(HDATA, PDATA) >> 3) (clog2(max(%0d, %0d) >> 3) = %0d)", HDATA, PDATA, $clog2(((HDATA > PDATA) ? HDATA : PDATA) >> 3)))
    end
    if ((HDATA < 8) || ((HDATA & (HDATA - 1)) != 0) || (PDATA < 8) || ((PDATA & (PDATA - 1)) != 0)) begin
      `uvm_fatal($sformatf("%m"), $sformatf("Data bus width HDATA (%0d) and PDATA (%0d) must both be power-of-2 and greater-or-equal 8", HDATA, PDATA))
    end
  end

  clk_rst_interface clk_rst_if (
    .reset_n (ahb2apb.reset_n),
    .clk (ahb2apb.clk)
  );

  assign (pull0, pull1) ahb2apb.hsel = 1'b1;
  assign (pull0, pull1) ahb2apb.hready = ahb2apb.hreadyout;
  ahb_interface ahb_if(
    .hreset_n  (ahb2apb.reset_n),
    .hclk      (ahb2apb.clk),
    .hsel      (ahb2apb.hsel),
    .htrans    (ahb2apb.htrans),
    .hburst    (ahb2apb.hburst),
    .hsize     (ahb2apb.hsize),
    .hmastlock (ahb2apb.hmastlock),
    .hprot     (ahb2apb.hprot),
    .haddr     (ahb2apb.haddr),
    .hwrite    (ahb2apb.hwrite),
    .hwdata    (ahb2apb.hwdata),
    .hrdata    (ahb2apb.hrdata),
    .hresp     (ahb2apb.hresp),
    .hreadyout (ahb2apb.hreadyout),
    .hready    (ahb2apb.hready)
  );

  apb_interface apb_if (
    .preset_n (ahb2apb.reset_n),
    .pclk     (ahb2apb.clk),
    .psel     (ahb2apb.psel),
    .penable  (ahb2apb.penable),
    .pprot    (ahb2apb.pprot),
    .paddr    (ahb2apb.paddr),
    .pwrite   (ahb2apb.pwrite),
    .pstrb    (ahb2apb.pstrb),
    .pwdata   (ahb2apb.pwdata),
    .prdata   (ahb2apb.prdata),
    .pslverr  (ahb2apb.pslverr),
    .pready   (ahb2apb.pready)
  );

  class ahb2apb_pharness extends ahb2apb_pharness_base;
    function new(string name = "ahb2apb_pharness");
      super.new(name);
      ADDR = ahb2apb_harness.ADDR;
      HDATA = ahb2apb_harness.HDATA;
      PDATA = ahb2apb_harness.PDATA;
    endfunction
  endclass
  ahb2apb_pharness pharness = new($sformatf("%m"));

  initial begin
    automatic string path = autopublish_path(pharness.get_name());
    publish_vifs(path);
  end

  function automatic void publish_vifs(string path);
    uvm_config_db#(virtual clk_rst_interface)::set(null, path, "clk_rst_if", clk_rst_if);
    uvm_config_db#(virtual apb_interface)::set(null, path, "apb_if", apb_if);
    uvm_config_db#(virtual ahb_interface)::set(null, path, "ahb_if", ahb_if);
    uvm_config_db#(mem_pkg::mem_pharness_base)::set(null, path, "harness", pharness);
  endfunction
endinterface

bind ahb2apb ahb2apb_harness#(.ADDR(ADDR), .HDATA(HDATA), .PDATA(PDATA)) harness();

`endif
`endif

