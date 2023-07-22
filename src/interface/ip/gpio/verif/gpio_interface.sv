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

`ifndef __gpio_interface__
`define __gpio_interface__

interface gpio_interface #(GPIO = gpio_param_pkg::GPIO) (
  input [GPIO-1:0] gpio_i,
  input [GPIO-1:0] gpio_o,
  input [GPIO-1:0] gpio_e
);

  import gpio_pkg::*;
  gpio_vip_cfg cfg;

  event sync_icb_ev;
  event ad_hoc_ocb_ev;

  //clocking icb @(gpio_i or gpio_o or gpio_e);
  //  input gpio_i;
  //  input gpio_o;
  //  input gpio_e;
  //endclocking

  clocking ocb @(ad_hoc_ocb_ev);
    output gpio_i;
    output gpio_o;
    output gpio_e;
  endclocking

  //always @(icb) begin
  //  -> sync_icb_ev;
  //end

  //task sync_icb();
  //  wait (sync_icb_ev.triggered);
  //endtask

  function void ad_hoc_ocb();
    -> ad_hoc_ocb_ev;
  endfunction

  bit time0 = 1;

  //initial begin
  //  wait ($isunknown({gpio_e, gpio_i}) == 1'b0);
  //  fork
  //    forever begin
  //      assert ({gpio_i} == ?); // Coming out of reset, gpio signals must be ???.
  //      wait (0);
  //    end
  //  join
  //end
endinterface

`endif

