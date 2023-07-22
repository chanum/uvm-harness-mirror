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

`ifndef __verilab_chip_test_pkg__
`define __verilab_chip_test_pkg__

package verilab_chip_test_pkg;

  import uvm_pkg::*;
  import gpio_pkg::*;
  import i2c_pkg::*;
  import arb_pkg::*;
  import apb_pkg::*;
  import ahb_pkg::*;
  import gpio_mod_pkg::*;
  import i2c_mod_pkg::*;
  import arb_mod_pkg::*;
  import mem_pkg::*;
  import dma_pkg::*;
  import cpu_pkg::*;
  import apb_fabric_pkg::*;
  import ahb_fabric_pkg::*;
  import ahb2apb_pkg::*;
  import periph_subsys_pkg::*;
  import proc_subsys_pkg::*;
  import verilab_core_pkg::*;
  import verilab_pads_pkg::*;
  import verilab_chip_pkg::*;

  `include "verilab_chip_base_vseq.sv"

  typedef class ahb_fabric_test_base_vseq;
  `include "ahb_fabric_vseq.sv"

  typedef class proc_subsys_xcpu_xdma_test_base_vseq;
  `include "proc_subsys_xcpu_xdma_vseq.sv"

  `include "verilab_chip_base_test.sv"
  `include "ahb_fabric_test.sv"
  `include "proc_subsys_xcpu_xdma_test.sv"
endpackage

`endif

