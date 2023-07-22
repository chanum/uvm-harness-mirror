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

`ifndef __i2c_interface__
`define __i2c_interface__

interface i2c_interface (
  input i2c_scl_i,
  input i2c_scl_o,
  input i2c_scl_e,
  input i2c_sda_i,
  input i2c_sda_o,
  input i2c_sda_e
);

  import i2c_pkg::*;
  i2c_vip_cfg cfg;

  event sync_icb_ev;
  event ad_hoc_ocb_ev;

  clocking icb @(i2c_scl_i or i2c_sda_i);
    input i2c_scl_i;
    input i2c_scl_o;
    input i2c_scl_e;
    input i2c_sda_i;
    input i2c_sda_o;
    input i2c_sda_e;
  endclocking

  clocking ocb @(ad_hoc_ocb_ev);
    output i2c_scl_i;
    output i2c_scl_o;
    output i2c_scl_e;
    output i2c_sda_i;
    output i2c_sda_o;
    output i2c_sda_e;
  endclocking

  always @(icb) begin
    -> sync_icb_ev;
  end

  task sync_icb();
    wait (sync_icb_ev.triggered);
  endtask

  function void ad_hoc_ocb();
    -> ad_hoc_ocb_ev;
  endfunction

  bit time0 = 1;

  initial begin
    wait ($isunknown({i2c_scl_e, i2c_scl_i, i2c_sda_e, i2c_sda_i}) == 1'b0);
    fork
      forever begin
        assert ({i2c_scl_e, i2c_sda_e} == '0); // Coming out of reset, sda and scl must both be undriven.
        assert ({i2c_scl_i, i2c_sda_i} == '1); // Coming out of reset, sda and scl must both be high.
        wait (0);
      end
    join
  end
endinterface

`endif

