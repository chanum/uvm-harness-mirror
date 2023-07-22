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

`ifndef __ahb_names_pkg__
`define __ahb_names_pkg__

package ahb_names_pkg;

  typedef enum bit [1:0] { HTRANS_IDLE = 2'b00,
                           HTRANS_BUSY = 2'b01,
                           HTRANS_NONSEQ = 2'b10,
                           HTRANS_SEQ = 2'b11
                         } htrans_t;

  typedef enum bit [2:0] { HBURST_SINGLE = 3'b000,
                           HBURST_INCR = 3'b001,
                           HBURST_WRAP4 = 3'b010,
                           HBURST_INCR4 = 3'b011,
                           HBURST_WRAP8 = 3'b100,
                           HBURST_INCR8 = 3'b101,
                           HBURST_WRAP16 = 3'b110,
                           HBURST_INCR16 = 3'b111
                         } hburst_t;

  typedef enum bit [2:0] { HSIZE_8 = 3'b000,
                           HSIZE_16 = 3'b001,
                           HSIZE_32 = 3'b010,
                           HSIZE_64 = 3'b011,
                           HSIZE_128 = 3'b100,
                           HSIZE_256 = 3'b101,
                           HSIZE_512 = 3'b110,
                           HSIZE_1024 = 3'b111
                         } hsize_t;

  typedef enum bit { HPROT3_NONCACHEABLE = 1'b0,
                     HPROT3_CACHEABLE = 1'b1
                   } hprot3_t;

  typedef enum bit { HPROT2_NONBUFFERABLE = 1'b0,
                     HPROT2_BUFFERABLE = 1'b1
                   } hprot2_t;

  typedef enum bit { HPROT1_USER = 1'b0,
                     HPROT1_PRIVILEGED = 1'b1
                   } hprot1_t;

  typedef enum bit { HPROT0_DATA = 1'b0,
                     HPROT0_OPCODE = 1'b1
                   } hprot0_t;

  typedef enum bit [3:0] { HPROT_noCACHE_noBUFF_USER_DATA = 4'b0000,
                           HPROT_noCACHE_noBUFF_USER_OP = 4'b0001,
                           HPROT_noCACHE_noBUFF_PRIV_DATA = 4'b0010,
                           HPROT_noCACHE_noBUFF_PRIV_OP = 4'b0011,
                           HPROT_noCACHE_BUFF_USER_DATA = 4'b0100,
                           HPROT_noCACHE_BUFF_USER_OP = 4'b0101,
                           HPROT_noCACHE_BUFF_PRIV_DATA = 4'b0110,
                           HPROT_noCACHE_BUFF_PRIV_OP = 4'b0111,
                           HPROT_CACHE_noBUFF_USER_DATA = 4'b1000,
                           HPROT_CACHE_noBUFF_USER_OP = 4'b1001,
                           HPROT_CACHE_noBUFF_PRIV_DATA = 4'b1010,
                           HPROT_CACHE_noBUFF_PRIV_OP = 4'b1011,
                           HPROT_CACHE_BUFF_USER_DATA = 4'b1100,
                           HPROT_CACHE_BUFF_USER_OP = 4'b1101,
                           HPROT_CACHE_BUFF_PRIV_DATA = 4'b1110,
                           HPROT_CACHE_BUFF_PRIV_OP = 4'b1111
                         } hprot_t;

  typedef enum bit { HWRITE_READ = 1'b0,
                     HWRITE_WRITE = 1'b1
                   } hwrite_t;

  typedef enum bit { HRESP_OKAY = 1'b0,
                     HRESP_ERROR = 1'b1
                   } hresp_t;
endpackage

`endif

