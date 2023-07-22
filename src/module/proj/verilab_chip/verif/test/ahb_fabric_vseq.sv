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

`ifndef __ahb_fabric_vseq__
`define __ahb_fabric_vseq__

class ahb_fabric_vseq extends ahb_fabric_test_base_vseq;

  `uvm_object_utils_begin(ahb_fabric_vseq)
  `uvm_object_utils_end

  function new(string name = "ahb_fabric_vseq");
    super.new(name);
  endfunction

  virtual task body();
    clk_rst_pkg::clk_rst_turnkey_seq clk_rst_turnkey_seqs[string];
    ahb_pkg::ahb_master_rand_seq ahb_master_rand_seqs[string];
    ahb_pkg::ahb_slave_mem_seq ahb_slave_mem_seqs[string];
    int enough = 0;

    fork
      // Clock(s) start automatically, but we need reset(s). Send one, then let the clock(s) run forever.
      foreach (p_sequencer.p_env.clk_rst_agents[a]) begin
        fork
          automatic string b = a;
          begin
            clk_rst_turnkey_seqs[b] = clk_rst_pkg::clk_rst_turnkey_seq::type_id::create(b);
            clk_rst_turnkey_seqs[b].start(p_sequencer.p_env.clk_rst_agents[b].sequencer, this);
          end
        join_none
      end

      // RESPONDER sequences: Run forever. Set as auto_seq on respective seqrs and forget about them.
      foreach (p_sequencer.p_env.slv_ahb_agents[a]) begin
        fork
          automatic string b = a;
          begin
            ahb_slave_mem_seqs[b] = ahb_pkg::ahb_slave_mem_seq::type_id::create(b);
            uvm_config_db#(uvm_sequence#(ahb_seq_item))::set(p_sequencer.p_env.slv_ahb_agents[b].sequencer, "", "auto_seq", ahb_slave_mem_seqs[b]);
          end
        join_none
      end

      // REQUESTER sequences: Run forever unless commanded to stop.
      begin
        foreach (p_sequencer.p_env.mst_ahb_agents[a]) begin
          fork
            automatic string b = a;
            do begin
              ahb_master_rand_seqs[b] = ahb_pkg::ahb_master_rand_seq::type_id::create(b);
              ahb_master_rand_seqs[b].item_limit = enough;
              ahb_master_rand_seqs[b].start(p_sequencer.p_env.mst_ahb_agents[b].sequencer, this);
            end while (p_sequencer.p_env.mst_ahb_agents[b].sequencer.get_reset() == 1); // If a seq stops on enough, we're done, but if it was stopped by reset, start another.
          join_none
        end
        wait fork; // If commanded to stop, we will wait for them to finish txns in progress.
      end

      // Test termination thread.
      begin
        #100us;
        enough = 1; // Just in case a reset kills the currently running seq just as we try to wind it down; we don't want to shut down the dead one and let a new infinite one start up.
        foreach (ahb_master_rand_seqs[b]) begin
          ahb_master_rand_seqs[b].item_limit = 1; // If it's done at least 1 item, don't send any more.
        end
      end
    join
  endtask
endclass

`endif

