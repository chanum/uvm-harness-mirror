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

`ifndef __ahb_vip_cfg__
`define __ahb_vip_cfg__

class ahb_vip_cfg extends uvm_object;

  agent_role role;
  int unsigned actual_addr_bus_bits;
  int unsigned actual_data_bus_bits;

  bit kill_valid_htrans = 0;
  bit kill_valid_hburst = 0;
  bit kill_valid_hsize = 0;
  bit kill_valid_hmastlock = 0;
  bit kill_valid_hprot = 0;
  bit kill_valid_haddr = 0;
  bit kill_valid_hwrite = 0;
  bit kill_valid_hwdata = 0;
  bit kill_valid_hresp = 0;
  bit kill_valid_hreadyout = 0;
  bit kill_valid_hrdata = 0;
  bit kill_valid_hsel = 0;
  bit kill_valid_hready = 0;
  bit kill_stable_htrans = 0;
  bit kill_stable_hburst = 0;
  bit kill_stable_hsize = 0;
  bit kill_stable_hmastlock = 0;
  bit kill_stable_hprot = 0;
  bit kill_stable_haddr = 0;
  bit kill_stable_hwrite = 0;
  bit kill_stable_hwdata = 0;
  bit kill_stable_hsel = 0;
  bit kill_stable_hresp = 0;
  bit kill_hsel_haddr_1kB = 0;
  bit kill_haddr_hsize_align = 0;
  bit kill_haddr_hsize_align_idle = 1; // Note default value!
  bit kill_haddr_max = 0;
  bit kill_hwdata_max = 0;
  bit kill_hrdata_max = 0;
  bit kill_hsize_max = 0;
  bit kill_hsize_max_idle = 1; // Note default value!
  bit kill_htrans_single = 0;
  bit kill_htrans_error_idle = 0;
  bit kill_hmastlock_rise = 0;
  bit kill_burst_stable_hburst = 0;
  bit kill_burst_stable_hsize = 0;
  bit kill_burst_stable_hprot = 0;
  bit kill_burst_stable_haddr = 0;
  bit kill_burst_stable_hwrite = 0;
  bit kill_burst_stable_busy_haddr = 0;
  bit kill_haddr_burst_step = 0;
  bit kill_burst_complete = 0;
  bit kill_burst_overrun = 0;
  bit kill_haddr_burst_incr_window_align = 0;
  bit kill_burst_end_busy = 0;
  bit kill_burst_end_busy_error = 0;
  bit kill_first_err_cyc = 0;
  bit kill_second_err_cyc = 0;

  `uvm_object_utils_begin(ahb_vip_cfg)
    `uvm_field_enum(agent_role, role, UVM_ALL_ON)
    `uvm_field_int(actual_addr_bus_bits, UVM_ALL_ON)
    `uvm_field_int(actual_data_bus_bits, UVM_ALL_ON)
    `uvm_field_int(kill_valid_htrans, UVM_ALL_ON)
    `uvm_field_int(kill_valid_hburst, UVM_ALL_ON)
    `uvm_field_int(kill_valid_hsize, UVM_ALL_ON)
    `uvm_field_int(kill_valid_hmastlock, UVM_ALL_ON)
    `uvm_field_int(kill_valid_hprot, UVM_ALL_ON)
    `uvm_field_int(kill_valid_haddr, UVM_ALL_ON)
    `uvm_field_int(kill_valid_hwrite, UVM_ALL_ON)
    `uvm_field_int(kill_valid_hwdata, UVM_ALL_ON)
    `uvm_field_int(kill_valid_hresp, UVM_ALL_ON)
    `uvm_field_int(kill_valid_hreadyout, UVM_ALL_ON)
    `uvm_field_int(kill_valid_hrdata, UVM_ALL_ON)
    `uvm_field_int(kill_valid_hsel, UVM_ALL_ON)
    `uvm_field_int(kill_valid_hready, UVM_ALL_ON)
    `uvm_field_int(kill_stable_htrans, UVM_ALL_ON)
    `uvm_field_int(kill_stable_hburst, UVM_ALL_ON)
    `uvm_field_int(kill_stable_hsize, UVM_ALL_ON)
    `uvm_field_int(kill_stable_hmastlock, UVM_ALL_ON)
    `uvm_field_int(kill_stable_hprot, UVM_ALL_ON)
    `uvm_field_int(kill_stable_haddr, UVM_ALL_ON)
    `uvm_field_int(kill_stable_hwrite, UVM_ALL_ON)
    `uvm_field_int(kill_stable_hwdata, UVM_ALL_ON)
    `uvm_field_int(kill_stable_hsel, UVM_ALL_ON)
    `uvm_field_int(kill_stable_hresp, UVM_ALL_ON)
    `uvm_field_int(kill_hsel_haddr_1kB, UVM_ALL_ON)
    `uvm_field_int(kill_haddr_hsize_align, UVM_ALL_ON)
    `uvm_field_int(kill_haddr_hsize_align_idle, UVM_ALL_ON)
    `uvm_field_int(kill_haddr_max, UVM_ALL_ON)
    `uvm_field_int(kill_hwdata_max, UVM_ALL_ON)
    `uvm_field_int(kill_hrdata_max, UVM_ALL_ON)
    `uvm_field_int(kill_hsize_max, UVM_ALL_ON)
    `uvm_field_int(kill_hsize_max_idle, UVM_ALL_ON)
    `uvm_field_int(kill_htrans_single, UVM_ALL_ON)
    `uvm_field_int(kill_htrans_error_idle, UVM_ALL_ON)
    `uvm_field_int(kill_hmastlock_rise, UVM_ALL_ON)
    `uvm_field_int(kill_burst_stable_hburst, UVM_ALL_ON)
    `uvm_field_int(kill_burst_stable_hsize, UVM_ALL_ON)
    `uvm_field_int(kill_burst_stable_hprot, UVM_ALL_ON)
    `uvm_field_int(kill_burst_stable_haddr, UVM_ALL_ON)
    `uvm_field_int(kill_burst_stable_hwrite, UVM_ALL_ON)
    `uvm_field_int(kill_burst_stable_busy_haddr, UVM_ALL_ON)
    `uvm_field_int(kill_haddr_burst_step, UVM_ALL_ON)
    `uvm_field_int(kill_burst_complete, UVM_ALL_ON)
    `uvm_field_int(kill_burst_overrun, UVM_ALL_ON)
    `uvm_field_int(kill_haddr_burst_incr_window_align, UVM_ALL_ON)
    `uvm_field_int(kill_burst_end_busy, UVM_ALL_ON)
    `uvm_field_int(kill_burst_end_busy_error, UVM_ALL_ON)
    `uvm_field_int(kill_first_err_cyc, UVM_ALL_ON)
    `uvm_field_int(kill_second_err_cyc, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "ahb_vip_cfg");
    super.new(name);
  endfunction

  virtual function void set_kills(kill_aa aa);
    if (aa.exists("kill_valid_htrans")) begin kill_valid_htrans = aa["kill_valid_htrans"]; end
    if (aa.exists("kill_valid_hburst")) begin kill_valid_hburst = aa["kill_valid_hburst"]; end
    if (aa.exists("kill_valid_hsize")) begin kill_valid_hsize = aa["kill_valid_hsize"]; end
    if (aa.exists("kill_valid_hmastlock")) begin kill_valid_hmastlock = aa["kill_valid_hmastlock"]; end
    if (aa.exists("kill_valid_hprot")) begin kill_valid_hprot = aa["kill_valid_hprot"]; end
    if (aa.exists("kill_valid_haddr")) begin kill_valid_haddr = aa["kill_valid_haddr"]; end
    if (aa.exists("kill_valid_hwrite")) begin kill_valid_hwrite = aa["kill_valid_hwrite"]; end
    if (aa.exists("kill_valid_hwdata")) begin kill_valid_hwdata = aa["kill_valid_hwdata"]; end
    if (aa.exists("kill_valid_hresp")) begin kill_valid_hresp = aa["kill_valid_hresp"]; end
    if (aa.exists("kill_valid_hreadyout")) begin kill_valid_hreadyout = aa["kill_valid_hreadyout"]; end
    if (aa.exists("kill_valid_hrdata")) begin kill_valid_hrdata = aa["kill_valid_hrdata"]; end
    if (aa.exists("kill_valid_hsel")) begin kill_valid_hsel = aa["kill_valid_hsel"]; end
    if (aa.exists("kill_valid_hready")) begin kill_valid_hready = aa["kill_valid_hready"]; end
    if (aa.exists("kill_stable_htrans")) begin kill_stable_htrans = aa["kill_stable_htrans"]; end
    if (aa.exists("kill_stable_hburst")) begin kill_stable_hburst = aa["kill_stable_hburst"]; end
    if (aa.exists("kill_stable_hsize")) begin kill_stable_hsize = aa["kill_stable_hsize"]; end
    if (aa.exists("kill_stable_hmastlock")) begin kill_stable_hmastlock = aa["kill_stable_hmastlock"]; end
    if (aa.exists("kill_stable_hprot")) begin kill_stable_hprot = aa["kill_stable_hprot"]; end
    if (aa.exists("kill_stable_haddr")) begin kill_stable_haddr = aa["kill_stable_haddr"]; end
    if (aa.exists("kill_stable_hwrite")) begin kill_stable_hwrite = aa["kill_stable_hwrite"]; end
    if (aa.exists("kill_stable_hwdata")) begin kill_stable_hwdata = aa["kill_stable_hwdata"]; end
    if (aa.exists("kill_stable_hsel")) begin kill_stable_hsel = aa["kill_stable_hsel"]; end
    if (aa.exists("kill_stable_hresp")) begin kill_stable_hresp = aa["kill_stable_hresp"]; end
    if (aa.exists("kill_hsel_haddr_1kB")) begin kill_hsel_haddr_1kB = aa["kill_hsel_haddr_1kB"]; end
    if (aa.exists("kill_haddr_hsize_align")) begin kill_haddr_hsize_align = aa["kill_haddr_hsize_align"]; end
    if (aa.exists("kill_haddr_hsize_align_idle")) begin kill_haddr_hsize_align_idle = aa["kill_haddr_hsize_align_idle"]; end
    if (aa.exists("kill_haddr_max")) begin kill_haddr_max = aa["kill_haddr_max"]; end
    if (aa.exists("kill_hwdata_max")) begin kill_hwdata_max = aa["kill_hwdata_max"]; end
    if (aa.exists("kill_hrdata_max")) begin kill_hrdata_max = aa["kill_hrdata_max"]; end
    if (aa.exists("kill_hsize_max")) begin kill_hsize_max = aa["kill_hsize_max"]; end
    if (aa.exists("kill_hsize_max_idle")) begin kill_hsize_max_idle = aa["kill_hsize_max_idle"]; end
    if (aa.exists("kill_htrans_single")) begin kill_htrans_single = aa["kill_htrans_single"]; end
    if (aa.exists("kill_htrans_error_idle")) begin kill_htrans_error_idle = aa["kill_htrans_error_idle"]; end
    if (aa.exists("kill_hmastlock_rise")) begin kill_hmastlock_rise = aa["kill_hmastlock_rise"]; end
    if (aa.exists("kill_burst_stable_hburst")) begin kill_burst_stable_hburst = aa["kill_burst_stable_hburst"]; end
    if (aa.exists("kill_burst_stable_hsize")) begin kill_burst_stable_hsize = aa["kill_burst_stable_hsize"]; end
    if (aa.exists("kill_burst_stable_hprot")) begin kill_burst_stable_hprot = aa["kill_burst_stable_hprot"]; end
    if (aa.exists("kill_burst_stable_haddr")) begin kill_burst_stable_haddr = aa["kill_burst_stable_haddr"]; end
    if (aa.exists("kill_burst_stable_hwrite")) begin kill_burst_stable_hwrite = aa["kill_burst_stable_hwrite"]; end
    if (aa.exists("kill_burst_stable_busy_haddr")) begin kill_burst_stable_busy_haddr = aa["kill_burst_stable_busy_haddr"]; end
    if (aa.exists("kill_haddr_burst_step")) begin kill_haddr_burst_step = aa["kill_haddr_burst_step"]; end
    if (aa.exists("kill_burst_complete")) begin kill_burst_complete = aa["kill_burst_complete"]; end
    if (aa.exists("kill_burst_overrun")) begin kill_burst_overrun = aa["kill_burst_overrun"]; end
    if (aa.exists("kill_haddr_burst_incr_window_align")) begin kill_haddr_burst_incr_window_align = aa["kill_haddr_burst_incr_window_align"]; end
    if (aa.exists("kill_burst_end_busy")) begin kill_burst_end_busy = aa["kill_burst_end_busy"]; end
    if (aa.exists("kill_burst_end_busy_error")) begin kill_burst_end_busy_error = aa["kill_burst_end_busy_error"]; end
    if (aa.exists("kill_first_err_cyc")) begin kill_first_err_cyc = aa["kill_first_err_cyc"]; end
    if (aa.exists("kill_second_err_cyc")) begin kill_second_err_cyc = aa["kill_second_err_cyc"]; end
  endfunction

  virtual function kill_aa get_kills();
    get_kills["kill_valid_htrans"] = kill_valid_htrans;
    get_kills["kill_valid_hburst"] = kill_valid_hburst;
    get_kills["kill_valid_hsize"] = kill_valid_hsize;
    get_kills["kill_valid_hmastlock"] = kill_valid_hmastlock;
    get_kills["kill_valid_hprot"] = kill_valid_hprot;
    get_kills["kill_valid_haddr"] = kill_valid_haddr;
    get_kills["kill_valid_hwrite"] = kill_valid_hwrite;
    get_kills["kill_valid_hwdata"] = kill_valid_hwdata;
    get_kills["kill_valid_hresp"] = kill_valid_hresp;
    get_kills["kill_valid_hreadyout"] = kill_valid_hreadyout;
    get_kills["kill_valid_hrdata"] = kill_valid_hrdata;
    get_kills["kill_valid_hsel"] = kill_valid_hsel;
    get_kills["kill_valid_hready"] = kill_valid_hready;
    get_kills["kill_stable_htrans"] = kill_stable_htrans;
    get_kills["kill_stable_hburst"] = kill_stable_hburst;
    get_kills["kill_stable_hsize"] = kill_stable_hsize;
    get_kills["kill_stable_hmastlock"] = kill_stable_hmastlock;
    get_kills["kill_stable_hprot"] = kill_stable_hprot;
    get_kills["kill_stable_haddr"] = kill_stable_haddr;
    get_kills["kill_stable_hwrite"] = kill_stable_hwrite;
    get_kills["kill_stable_hwdata"] = kill_stable_hwdata;
    get_kills["kill_stable_hsel"] = kill_stable_hsel;
    get_kills["kill_stable_hresp"] = kill_stable_hresp;
    get_kills["kill_hsel_haddr_1kB"] = kill_hsel_haddr_1kB;
    get_kills["kill_haddr_hsize_align"] = kill_haddr_hsize_align;
    get_kills["kill_haddr_hsize_align_idle"] = kill_haddr_hsize_align_idle;
    get_kills["kill_haddr_max"] = kill_haddr_max;
    get_kills["kill_hwdata_max"] = kill_hwdata_max;
    get_kills["kill_hrdata_max"] = kill_hrdata_max;
    get_kills["kill_hsize_max"] = kill_hsize_max;
    get_kills["kill_hsize_max_idle"] = kill_hsize_max_idle;
    get_kills["kill_htrans_single"] = kill_htrans_single;
    get_kills["kill_htrans_error_idle"] = kill_htrans_error_idle;
    get_kills["kill_hmastlock_rise"] = kill_hmastlock_rise;
    get_kills["kill_burst_stable_hburst"] = kill_burst_stable_hburst;
    get_kills["kill_burst_stable_hsize"] = kill_burst_stable_hsize;
    get_kills["kill_burst_stable_hprot"] = kill_burst_stable_hprot;
    get_kills["kill_burst_stable_haddr"] = kill_burst_stable_haddr;
    get_kills["kill_burst_stable_hwrite"] = kill_burst_stable_hwrite;
    get_kills["kill_burst_stable_busy_haddr"] = kill_burst_stable_busy_haddr;
    get_kills["kill_haddr_burst_step"] = kill_haddr_burst_step;
    get_kills["kill_burst_complete"] = kill_burst_complete;
    get_kills["kill_burst_overrun"] = kill_burst_overrun;
    get_kills["kill_haddr_burst_incr_window_align"] = kill_haddr_burst_incr_window_align;
    get_kills["kill_burst_end_busy"] = kill_burst_end_busy;
    get_kills["kill_burst_end_busy_error"] = kill_burst_end_busy_error;
    get_kills["kill_first_err_cyc"] = kill_first_err_cyc;
    get_kills["kill_second_err_cyc"] = kill_second_err_cyc;
    return get_kills;
  endfunction
endclass

`endif

