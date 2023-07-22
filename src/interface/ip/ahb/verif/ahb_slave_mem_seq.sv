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

`ifndef __ahb_slave_mem_seq__
`define __ahb_slave_mem_seq__

class ahb_slave_mem_seq extends ahb_base_seq;

  `uvm_object_utils_begin(ahb_slave_mem_seq)
  `uvm_object_utils_end

  function new(string name = "ahb_slave_mem_seq");
    super.new(name);
  endfunction

  virtual task body();
    forever begin
      p_sequencer.react_item_fifo.get(req);
      p_sequencer.mem.access(req);
      req.hxdata.rand_mode(0);
      `uvm_rand_send(req)
    end
  endtask
endclass

`endif

