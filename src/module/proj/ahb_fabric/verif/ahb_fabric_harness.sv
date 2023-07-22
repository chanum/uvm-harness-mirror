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

`ifndef __ahb_fabric_harness__
`define __ahb_fabric_harness__
// Harness files are read before stub files. The only reason a stub compile token would already be defined is if the real and stub module defs are both being suppressed, in which case the harness def must also be suppressed, since it will have nowhere to bind.
`ifndef __ahb_fabric_stub__

interface ahb_fabric_harness#(MST = 1, SLV = 1, MST_ADDR = 32, SLV_ADDR = 32, DATA = 32, BURST_LOCK = 0) ();

  import ahb_fabric_pkg::*;

  initial begin // Parameter legality checks.
    if (MST_ADDR < (SLV_ADDR + $clog2(SLV))) begin // I don't think the file will even compile if this condition isn't satisfied, but the message text could still help someone understand the compile failure.
      `uvm_fatal($sformatf("%m"), $sformatf("Master addr width MST_ADDR (%0d) must be greater-or-equal slave addr width + bits to decode any target slave, SLV_ADDR + clog2(SLV) (%0d + clog2(%0d) = %0d)", MST_ADDR, SLV_ADDR, $clog2(SLV), SLV_ADDR + $clog2(SLV)))
    end
    if (SLV_ADDR < $clog2(DATA >> 3)) begin // No need to check MST_ADDR vs DATA explicitly, the check above addresses MST_ADDR vs SLV_ADDR.
      `uvm_fatal($sformatf("%m"), $sformatf("Master MST_ADDR (%0d) and slave SLV_ADDR (%0d) addr width both must be at least enough bits to address every byte of data bus width, clog2(DATA >> 3) (clog2(%0d) = %0d)", MST_ADDR, SLV_ADDR, DATA >> 3, $clog2(DATA >> 3)))
    end
    if ((DATA < 8) || ((DATA & (DATA - 1)) != 0)) begin
      `uvm_fatal($sformatf("%m"), $sformatf("Data bus width DATA (%0d) must be a power-of-2 and greater-or-equal 8", DATA))
    end
  end

  clk_rst_interface clk_rst_if (
    .reset_n (ahb_fabric.hreset_n),
    .clk (ahb_fabric.hclk)
  );

  for (genvar m = 0; m < MST; ++m) begin : mst
    assign (pull0, pull1) ahb_fabric.mst_hsel[m] = 1'b1;
    assign (pull0, pull1) ahb_fabric.mst_hready[m] = ahb_fabric.mst_hreadyout[m];
    ahb_interface ahb_if (
      .hreset_n  (ahb_fabric.hreset_n),
      .hclk      (ahb_fabric.hclk),
      .hsel      (ahb_fabric.mst_hsel[m]),
      .htrans    (ahb_fabric.mst_htrans[m]),
      .hburst    (ahb_fabric.mst_hburst[m]),
      .hsize     (ahb_fabric.mst_hsize[m]),
      .hmastlock (ahb_fabric.mst_hmastlock[m]),
      .hprot     (ahb_fabric.mst_hprot[m]),
      .haddr     (ahb_fabric.mst_haddr[m]),
      .hwrite    (ahb_fabric.mst_hwrite[m]),
      .hwdata    (ahb_fabric.mst_hwdata[m]),
      .hrdata    (ahb_fabric.mst_hrdata[m]),
      .hresp     (ahb_fabric.mst_hresp[m]),
      .hreadyout (ahb_fabric.mst_hreadyout[m]),
      .hready    (ahb_fabric.mst_hready[m])
    );
    if (m > 0) begin : vif
      function automatic void publish(string path);
        uvm_config_db#(virtual ahb_interface)::set(null, path, $sformatf("mst_ahb_if[%0d]", m), mst[m].ahb_if);
        mst[m-1].vif.publish(path);
      endfunction
    end
    else begin : vif
      function automatic void publish(string path);
        uvm_config_db#(virtual ahb_interface)::set(null, path, $sformatf("mst_ahb_if[%0d]", m), mst[m].ahb_if);
      endfunction
    end
  end

  for (genvar s = 0; s < SLV; ++s) begin : slv
    assign (pull0, pull1) ahb_if.hsel = 1'b1;
    assign (pull0, pull1) ahb_fabric.slv_hready[s] = ahb_if.hreadyout;
    ahb_interface ahb_if (
      .hreset_n  (ahb_fabric.hreset_n),
      .hclk      (ahb_fabric.hclk),
      .htrans    (ahb_fabric.slv_htrans[s]),
      .hburst    (ahb_fabric.slv_hburst[s]),
      .hsize     (ahb_fabric.slv_hsize[s]),
      .hmastlock (ahb_fabric.slv_hmastlock[s]),
      .hprot     (ahb_fabric.slv_hprot[s]),
      .haddr     (ahb_fabric.slv_haddr[s]),
      .hwrite    (ahb_fabric.slv_hwrite[s]),
      .hwdata    (ahb_fabric.slv_hwdata[s]),
      .hrdata    (ahb_fabric.slv_hrdata[s]),
      .hresp     (ahb_fabric.slv_hresp[s]),
      .hready    (ahb_fabric.slv_hready[s])
    );
    if (s > 0) begin : vif
      function automatic void publish(string path);
        uvm_config_db#(virtual ahb_interface)::set(null, path, $sformatf("slv_ahb_if[%0d]", s), slv[s].ahb_if);
        slv[s-1].vif.publish(path);
      endfunction
    end
    else begin : vif
      function automatic void publish(string path);
        uvm_config_db#(virtual ahb_interface)::set(null, path, $sformatf("slv_ahb_if[%0d]", s), slv[s].ahb_if);
      endfunction
    end
  end

  class ahb_fabric_pharness extends ahb_fabric_pharness_base;
    function new(string name = "ahb_fabric_pharness");
      super.new(name);
      MST = ahb_fabric_harness.MST;
      SLV = ahb_fabric_harness.SLV;
      MST_ADDR = ahb_fabric_harness.MST_ADDR;
      SLV_ADDR = ahb_fabric_harness.SLV_ADDR;
      DATA = ahb_fabric_harness.DATA;
      BURST_LOCK = ahb_fabric_harness.BURST_LOCK;
    endfunction
  endclass
  ahb_fabric_pharness pharness = new($sformatf("%m"));

  initial begin
    automatic string path = autopublish_path(pharness.get_name());
    publish_vifs(path);
  end

  function automatic void publish_vifs(string path);
    uvm_config_db#(virtual clk_rst_interface)::set(null, path, "clk_rst_if", clk_rst_if);
    mst[MST-1].vif.publish(path);
    slv[SLV-1].vif.publish(path);
    uvm_config_db#(ahb_fabric_pharness_base)::set(null, path, "harness", pharness);
  endfunction
endinterface

bind ahb_fabric ahb_fabric_harness#(.MST(MST), .SLV(SLV), .MST_ADDR(MST_ADDR), .SLV_ADDR(SLV_ADDR), .DATA(DATA), .BURST_LOCK(BURST_LOCK)) harness();

`endif
`endif

