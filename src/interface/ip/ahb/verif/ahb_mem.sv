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

`ifndef __ahb_mem__
`define __ahb_mem__

class ahb_mem extends uvm_object;

  byte mem[ADDR_t];

  `uvm_object_utils_begin(ahb_mem)
  `uvm_object_utils_end

  function new(string name = "ahb_mem");
    super.new(name);
  endfunction

  virtual function void access(ahb_seq_item item);
    ADDR_t addr_offset = item.haddr & ((item.cfg.actual_data_bus_bits >> 3) - 1);
    DATA_t data_offset = 0;

    if (item.hwrite == HWRITE_WRITE) begin
      ADDR_t mem_addr = item.haddr;
      data_offset = item.hxdata >> (addr_offset << 3);
      for (ADDR_t b = 0; b < (ADDR_t'(1) << item.hsize); ++b) begin
        mem[mem_addr] = data_offset[7:0];
        ++mem_addr;
        data_offset >>= 8;
      end
    end
    else begin
      ADDR_t mem_addr = item.haddr + (ADDR_t'(1) << item.hsize);
      for (ADDR_t b = 0; b < (ADDR_t'(1) << item.hsize); ++b) begin
        data_offset <<= 8;
        --mem_addr;
        if (! mem.exists(mem_addr)) begin
          mem[mem_addr] = $urandom;
        end
        data_offset[7:0] = mem[mem_addr];
      end
      item.hxdata = data_offset << (addr_offset << 3);
    end
  endfunction
endclass

`endif

