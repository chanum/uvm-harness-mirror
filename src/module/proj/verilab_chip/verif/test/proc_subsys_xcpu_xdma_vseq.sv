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

`ifndef __proc_subsys_xcpu_xdma_vseq__
`define __proc_subsys_xcpu_xdma_vseq__

class proc_subsys_xcpu_xdma_vseq extends proc_subsys_xcpu_xdma_test_base_vseq;

  `uvm_object_utils_begin(proc_subsys_xcpu_xdma_vseq)
  `uvm_object_utils_end

  function new(string name = "proc_subsys_xcpu_xdma_vseq");
    super.new(name);
  endfunction

  virtual task body();
    ahb_pkg::ahb_master_rand_seq ahb_master_rand_seqs[string];
    ahb_pkg::ahb_slave_mem_seq ahb_slave_mem_seqs[string];
    apb_pkg::apb_master_rand_seq apb_master_rand_seqs[string];
    apb_pkg::apb_slave_mem_seq apb_slave_mem_seqs[string];
    int enough = 0;

    fork
      // RESPONDER sequences: Run forever. Set as auto_seq on respective seqrs and forget about them.
      begin
        ahb_slave_mem_seqs["periph_ahb_if"] = ahb_pkg::ahb_slave_mem_seq::type_id::create("periph_ahb_if");
        uvm_config_db#(uvm_sequence#(ahb_seq_item))::set(p_sequencer.p_env.ahb_agents["periph_ahb_if"].sequencer, "", "auto_seq", ahb_slave_mem_seqs["periph_ahb_if"]);
        apb_slave_mem_seqs["dma_apb_if"] = apb_pkg::apb_slave_mem_seq::type_id::create("dma_apb_if");
        uvm_config_db#(uvm_sequence#(apb_seq_item))::set(p_sequencer.p_env.dma_envs["dma_0"].apb_agents["apb_if"].sequencer, "", "auto_seq", apb_slave_mem_seqs["dma_apb_if"]);
      end

      // REQUESTER sequences: Run forever unless commanded to stop.
      do begin
        ahb_master_rand_seqs["cpu_ahb_if"] = ahb_pkg::ahb_master_rand_seq::type_id::create("cpu_ahb_if");
        ahb_master_rand_seqs["cpu_ahb_if"].item_limit = enough;
        ahb_master_rand_seqs["cpu_ahb_if"].start(p_sequencer.p_env.cpu_envs["cpu_0"].ahb_agents["ahb_if"].sequencer, this);
      end while (p_sequencer.p_env.cpu_envs["cpu_0"].ahb_agents["ahb_if"].sequencer.get_reset() == 1); // If a seq stops on enough, we're done, but if it was stopped by reset, start another.
      do begin
        ahb_master_rand_seqs["dma_ahb_if"] = ahb_pkg::ahb_master_rand_seq::type_id::create("dma_ahb_if");
        ahb_master_rand_seqs["dma_ahb_if"].item_limit = enough;
        ahb_master_rand_seqs["dma_ahb_if"].start(p_sequencer.p_env.dma_envs["dma_0"].ahb_agents["ahb_if"].sequencer, this);
      end while (p_sequencer.p_env.dma_envs["dma_0"].ahb_agents["ahb_if"].sequencer.get_reset() == 1); // If a seq stops on enough, we're done, but if it was stopped by reset, start another.
      do begin
        apb_master_rand_seqs["dma_apb_if"] = apb_pkg::apb_master_rand_seq::type_id::create("dma_apb_if");
        apb_master_rand_seqs["dma_apb_if"].item_limit = enough;
        apb_master_rand_seqs["dma_apb_if"].start(p_sequencer.p_env.apb_agents["dma_apb_if"].sequencer, this);
      end while (p_sequencer.p_env.apb_agents["dma_apb_if"].sequencer.get_reset() == 1); // If a seq stops on enough, we're done, but if it was stopped by reset, start another.

      // Test termination thread.
      begin
        #100us;
        enough = 1; // Just in case a reset kills the currently running seq just as we try to wind it down; we don't want to shut down the dead one and let a new infinite one start up.
        foreach (ahb_master_rand_seqs[b]) begin
          ahb_master_rand_seqs[b].item_limit = 1; // If it's done at least 1 item, don't send any more.
        end
        foreach (apb_master_rand_seqs[b]) begin
          apb_master_rand_seqs[b].item_limit = 1; // If it's done at least 1 item, don't send any more.
        end
      end
    join
  endtask
endclass

`endif

