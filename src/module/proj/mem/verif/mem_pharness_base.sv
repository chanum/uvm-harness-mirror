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

`ifndef __mem_pharness_base__
`define __mem_pharness_base__

class mem_pharness_base;
  string name;
  int ADDR;
  int DATA;

  function new(string name = "mem_pharness_base");
    this.name = name;
  endfunction

  virtual function string get_name();
    return name;
  endfunction

  virtual function bit[mem_verif_param_pkg::DATA-1:0] peek(bit[mem_verif_param_pkg::ADDR-1:0] addr);
    `uvm_error("peek", "This is a place-holder base class method that must be overridden in extended classes")
  endfunction

  virtual function void poke(bit[mem_verif_param_pkg::ADDR-1:0] addr, bit[mem_verif_param_pkg::DATA-1:0] data);
    `uvm_error("poke", "This is a place-holder base class method that must be overridden in extended classes")
  endfunction

  virtual function void load(string src);
    `uvm_error("load", "This is a place-holder base class method that must be overridden in extended classes")
  endfunction
endclass

`endif
