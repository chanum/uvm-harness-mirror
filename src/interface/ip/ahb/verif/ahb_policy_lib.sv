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

`ifndef __ahb_policy_lib__
`define __ahb_policy_lib__

class ahb_ad_hoc_policy#(type I = ahb_seq_item); // The base policy class. A ahb_ad_hoc_policy can only be added to a ahb_ad_hoc_policy_list. Ad hoc policies are not pulled from the uvm_config_db.
  string name;
  rand I item;

  function new(string name = "ahb_ad_hoc_policy");
    this.name = name;
  endfunction

  virtual function void set_item(I item);
    this.item = item;
  endfunction

  function void pre_randomize();
    if (item == null) begin
      `uvm_fatal("pre_randomize", $sformatf("%s: 'item' must be set before randomization", name))
    end
  endfunction
endclass

class ahb_ad_hoc_policy_list#(type I = ahb_seq_item) extends ahb_ad_hoc_policy#(I); // The policy list extends the policy, so a list can hold both individual policies and nested lists of policies.
  rand ahb_ad_hoc_policy#(I) plist[$];
  int plist_size; // I want the objects on the plist to be rand, but I don't want the list size to be rand.

  constraint keep_plist_size {
    plist.size() == plist_size;
  }

  function new(string name = "ahb_ad_hoc_policy_list");
    super.new(name);
  endfunction

  virtual function void set_item(I item);
    super.set_item(item);
    foreach (plist[p]) begin
      plist[p].set_item(item);
    end
  endfunction

  virtual function void delete();
    plist.delete();
    plist_size = plist.size();
  endfunction

  virtual function void set(ahb_ad_hoc_policy#(I) policy[$]); // Notice the arg is a queue: You can set a list (array literal) of policies all at once. But even for just a single policy, you must make a list, e.g. '{policy}. An empty list '{} is equivalent to delete().
    plist = policy;
    plist_size = plist.size();
  endfunction

  virtual function void add(ahb_ad_hoc_policy#(I) policy[$]);
    plist = {plist, policy};
    plist_size = plist.size();
  endfunction
endclass

class ahb_time0_seq_item_policy extends ahb_ad_hoc_policy#(ahb_seq_item);
  function new(string name = "ahb_time0_seq_item_policy");
    super.new(name);
  endfunction

  virtual function void set_item(ahb_seq_item item);
    super.set_item(item);
    item.next = null; item.next.rand_mode(0);
    item.plist.rand_mode(0);
    item.constraint_mode(0);
    item.haddr_max.constraint_mode(1);
    item.hxdata_max.constraint_mode(1);
  endfunction
endclass

class ahb_idle_seq_item_policy extends ahb_time0_seq_item_policy;
  function new(string name = "ahb_idle_seq_item_policy");
    super.new(name);
  endfunction

  virtual function void set_item(ahb_seq_item item);
    super.set_item(item);
    item.htrans = HTRANS_IDLE; item.htrans.rand_mode(0);
    item.hmastlock = 1'b0; item.hmastlock.rand_mode(0);
    item.hresp = HRESP_OKAY; item.hresp.rand_mode(0);
    item.hsize_max.constraint_mode(1);
    item.haddr_hsize_align.constraint_mode(1);
  endfunction
endclass

class ahb_policy#(type I = ahb_seq_item) extends ahb_ad_hoc_policy#(I);
  function new(string name = "ahb_policy");
    super.new(name);
  endfunction
endclass

class ahb_policy_list#(type I = ahb_seq_item, type P = ahb_policy#(I)) extends ahb_policy#(I); // The policy list extends the policy, so a list can hold both individual policies and nested lists of policies.
  rand P plist[$]; // Any list always extends the base policy type, but policies in the list don't have to be base policy type. See e.g. ahb_addr_range_policy_list.
  int plist_size; // I want the objects on the plist to be rand, but I don't want the list size to be rand.

  constraint keep_plist_size {
    plist.size() == plist_size;
  }

  function new(string name = "ahb_policy_list");
    super.new(name);
  endfunction

  virtual function void set_item(I item);
    super.set_item(item);
    foreach (plist[p]) begin
      plist[p].set_item(item);
    end
  endfunction

  virtual function void delete();
    plist.delete();
    plist_size = plist.size();
  endfunction

  virtual function void set(P policy[$]); // Notice the arg is a queue: You can set a list (array literal) of policies all at once. But even for just a single policy, you must make a list, e.g. '{policy}. An empty list '{} is equivalent to delete().
    plist = policy;
    plist_size = plist.size();
  endfunction

  virtual function void add(P policy[$]);
    plist = {plist, policy};
    plist_size = plist.size();
  endfunction
endclass

class ahb_addr_range_policy extends ahb_policy#(ahb_seq_item);
  ahb_param_pkg::ADDR_t addr_lo; // Not rand.
  ahb_param_pkg::ADDR_t addr_hi; // Not rand.
  // We don't need two different kinds of addr range object, for keep-in vs keep-out regions. To create a keep-out hole in a larger keep-in addr range, just create an addr_range object for the keep-in range and another for the keep-out range.
  // An address that falls in no addr_range at all is a keep-out. An address that falls in *exactly one* addr_range is a keep-in. An address that falls in *multiple overlapping* addr_ranges is a keep-out.

  function new(string name = "ahb_addr_range_policy");
    super.new(name);
  endfunction
endclass

class ahb_addr_range_policy_list extends ahb_policy_list#(ahb_seq_item, ahb_addr_range_policy);
  rand int range_select;

  function new(string name = "ahb_addr_range_policy_list");
    super.new(name);
  endfunction

  constraint addr_range {
    range_select inside {[0 : plist.size() - 1]}; // plist.size() better be > 0. Don't create a ahb_addr_range_policy_list without putting at least one ahb_addr_range_policy in it. #WeShouldntHaveToTellYouThis.
    foreach (plist[i]) {
      (i == range_select) == (item.haddr inside {[plist[i].addr_lo : plist[i].addr_hi]});
    }
  }
endclass

class ahb_chain_seq_item_policy extends ahb_policy#(ahb_seq_item); // This policy should only be added to a REQUESTER seq_item.
  int length;

  function new(string name = "ahb_chain_seq_item_policy");
    super.new(name);
  endfunction

  virtual function void set_item(ahb_seq_item item);
    super.set_item(item);
    if ((item.next == null) && (item.next.rand_mode())) begin // The first chain policy encountered in a policy list traversal wins. make_chain will either make item.next non-null, or set its rand_mode(0).
      make_chain();
    end
  endfunction

  virtual function void make_chain();
    ahb_seq_item link = item;
    length = policy_length();
    for (int i = 1; i < length; ++i) begin
      ahb_seq_item next = ahb_seq_item::type_id::create($sformatf("%s.%0d", item.get_full_name(), i));
      next.beat = i;
      next.set_parent_sequence(link.get_parent_sequence());
      next.set_sequencer(link.get_sequencer());
      next.cfg = link.cfg;
      link.next = next;
      link = next;
    end
    link.next = null; link.next.rand_mode(0);
  endfunction

  virtual function int policy_length();
     std::randomize(policy_length) with {policy_length dist {1 := 4, [2:5] :/ 2, [6:17] :/ 1};}; // Longer chains are legal (up to 1024/(1<<hsize) beats), but appear effectively impossible to solve, just do them directed.
  endfunction
endclass

class ahb_user_length_chain_seq_item_policy extends ahb_chain_seq_item_policy; // This policy should only be added to a REQUESTER seq_item.
  function new(string name = "ahb_user_length_seq_item_policy");
    super.new(name);
  endfunction

  virtual function void set_length(int l);
    length = l;
  endfunction

  virtual function int policy_length();
    return length;
  endfunction
endclass

class ahb_burst_seq_item_policy extends ahb_chain_seq_item_policy; // This policy should only be added to a REQUESTER seq_item.
  function new(string name = "ahb_burst_seq_item_policy");
    super.new(name);
  endfunction

  constraint burst_hburst {
    item.hburst != HBURST_SINGLE;
  }
endclass

class ahb_incr_burst_seq_item_policy extends ahb_burst_seq_item_policy; // This policy should only be added to a REQUESTER seq_item.
  function new(string name = "ahb_incr_burst_seq_item_policy");
    super.new(name);
  endfunction

  constraint burst_hburst {
    item.hburst inside {hburst_incr_set};
  }
endclass

class ahb_incr_undef_burst_seq_item_policy extends ahb_burst_seq_item_policy; // This policy should only be added to a REQUESTER seq_item.
  function new(string name = "ahb_incr_undef_burst_seq_item_policy");
    super.new(name);
  endfunction

  constraint burst_hburst {
    item.hburst == HBURST_INCR;
  }
endclass

class ahb_fixed_burst_seq_item_policy extends ahb_burst_seq_item_policy; // This policy should only be added to a REQUESTER seq_item.
  function new(string name = "ahb_fixed_burst_seq_item_policy");
    super.new(name);
  endfunction

  constraint burst_hburst {
    item.hburst inside {hburst_fixed_length_set};
  }

  virtual function int policy_length();
     std::randomize(policy_length) with {policy_length dist {4 := 1, 8 := 1, 16 := 1};};
  endfunction
endclass

class ahb_wrap_burst_seq_item_policy extends ahb_fixed_burst_seq_item_policy; // This policy should only be added to a REQUESTER seq_item.
  function new(string name = "ahb_wrap_burst_seq_item_policy");
    super.new(name);
  endfunction

  constraint burst_hburst {
    item.hburst inside {hburst_wrap_set};
  }
endclass

`endif

