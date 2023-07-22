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

`ifndef __verilab_chip_base_vseq__
`define __verilab_chip_base_vseq__

class verilab_chip_base_vseq extends uvm_sequence;

  `uvm_object_utils_begin(verilab_chip_base_vseq)
  `uvm_object_utils_end

  function new(string name = "verilab_chip_base_vseq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_error("body", "This is an empty base class method, you must specify a factory override vseq with a +VSEQ=... plusarg")
  endtask
endclass

`endif

