# Copyright 2017 Verilab Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

PROJ_ROOT := $(shell pwd)

define HELP
echo 'Usage: make [target [options]]'
echo '       make help'
echo '       make sim    UVM_TESTNAME=...  VSEQ=... [TOOL=...] [SEED=...]    [UVM_VERBOSITY=...]'
echo '       make clean [UVM_TESTNAME=... [VSEQ=... [TOOL=...  [SEED=...]]]] [UVM_VERBOSITY=...]'
echo ''
echo 'Targets:         One of (help|sim|clean), or none. Default=help.'
echo 'Options:'
echo '  UVM_TESTNAME:  Any *_test name in module/proj/verilab_chip/verif/test/verilab_chip_test_pkg.sv, except'
echo '                 verilab_chip_base_test. Required for sim, optional for clean.'
echo '  VSEQ:          Any *_vseq name in module/proj/verilab_chip/verif/test/verilab_chip_test_pkg.sv that'
echo '                 extends the {UVM_TESTNAME}_base_vseq. Required for sim, optional for clean.'
echo '  TOOL:          One of (vcs|ius|questa)[-g], or none. Default=vcs. Optional "-g" suffix enables gui mode.'
echo '  SEED:          Anything recognized by the TOOL, or none. Default=random value (from /dev/urandom).'
echo '  UVM_VERBOSITY: Anything recognized as a +UVM_VERBOSITY plusarg, or none. Default=UVM_FULL.'
echo '                 (Allowed and ignored by clean.)'
echo ''
echo 'The results of a sim will be found in <PROJ_ROOT>/sim/<UVM_TESTNAME>/<VSEQ>/<TOOL>/<SEED>/.'
echo '<PROJ_ROOT> is the directory containing this Makefile. The <TOOL> directory will not include "-g".'
echo 'An existing result directory is ALWAYS REMOVED before a new sim is run. The sim log file is always sim.log.'
echo ''
echo 'The order of commandline arguments is irrelevant, but there is a precedence of options for clean:'
echo 'Clean constructs a directory path from the UVM_TESTNAME, VSEQ, TOOL, SEED options, in that order, stopping'
echo 'at the first option not specified on the commandline. Whatever directory path is so constructed, is removed.'
echo 'With no UVM_TESTNAME commandline option, the entire <PROJ_ROOT>/sim directory is removed completely.'
echo ''
echo 'YOU CAN CHANGE THIS MAKEFILE. In particular, tool invocation names and switches. See "# To change ...".'
endef
.DEFAULT_GOAL := help

# Values given on the commandline override these defaults. For a sim, UVM_TESTNAME and VSEQ must be set on the commandline:
UVM_TESTNAME := none
VSEQ := none
TOOL := vcs
SEED := $(shell perl -e'print unpack qq(U*), qx(dd if=/dev/urandom count=1 bs=4 status=none);')
UVM_VERBOSITY := UVM_FULL

# Check all options for legal(ish) values, isolate TOOL from -g. This is just a preliminary check, more checking done by specific target rules.
TRUTOOL := $(shell perl -e'for my $$opt (q(UVM_TESTNAME=${UVM_TESTNAME}), q(VSEQ=${VSEQ}), q(SEED=${SEED}), q(UVM_VERBOSITY=${UVM_VERBOSITY})) { \
                             $$opt =~ /^\w+=\w+$$/ or die qq(Commandline option missing or contains illegal characters: $$opt\n); \
                           } \
                           q(${TOOL}) =~ /^(vcs|ius|questa)(?:-g)?$$/ or die qq(Invalid TOOL=${TOOL}\n); \
                           print qq($$1);')
ifeq (${TRUTOOL},)
  $(error Unable to proceed. For more assistance, try "make help")
endif

# To change gui options, make the change here: Each => RHS is a list of 2 entries, switches for non-gui mode, switches for gui mode.
GUI := $(shell perl -e'%g = (vcs    => [q(), q(-gui)], \
                             ius    => [q(), q(-gui -linedebug -uvmlinedebug +access+rwc)], \
                             questa => [q(-do "run -all"), q(-i)]); \
                       print qq($${$$g{${TRUTOOL}}}[(q(${TOOL}) =~ /-g/) ? 1 : 0]);')

# If doing a clean, SIM_DIR is "don't care". If doing a sim, CLEAN_DIR is "don't care".
SIM_DIR := ${PROJ_ROOT}/sim/${UVM_TESTNAME}/${VSEQ}/${TRUTOOL}/${SEED}
CLEAN_DIR := ${PROJ_ROOT}/sim
# Using ":=" instead of "+=" because "+=" leaves space in the joint.
ifeq ($(origin UVM_TESTNAME),command line)
  CLEAN_DIR := ${CLEAN_DIR}/${UVM_TESTNAME}
  ifeq ($(origin VSEQ),command line)
    CLEAN_DIR := ${CLEAN_DIR}/${VSEQ}
    ifeq ($(origin TOOL),command line)
      CLEAN_DIR := ${CLEAN_DIR}/${TRUTOOL}
      ifeq ($(origin SEED),command line)
        CLEAN_DIR := ${CLEAN_DIR}/${SEED}
      endif
    endif
  endif
endif

help:
	@${HELP}

sim:    ${TRUTOOL}

# To change tool invocation, make the change in this section:
vcs:    simdir
	cd ${SIM_DIR} && \
	vcs \
	  -l sim.log \
	  -full64 -sverilog -ntb_opts uvm-1.1 \
	  -notice -debug_access+all \
	  -timescale=1ns/1ps \
	  +define+SVA_ON \
          -F ../../../../../module/proj/verilab_chip/verif/test/${UVM_TESTNAME}.f \
	  -F ../../../../../proj/sim.f \
	  -R \
	  +UVM_NO_RELNOTES \
	  +UVM_TESTNAME=${UVM_TESTNAME} +VSEQ=${VSEQ} +ntb_random_seed=${SEED} +UVM_VERBOSITY=${UVM_VERBOSITY} ${GUI}
# Note: vcs WILL NOT COMPILE with absolute paths to the two -F files. They must be relative paths, I don't know why.

ius:    simdir
	cd ${SIM_DIR} && \
	xrun \
	  -l sim.log \
	  -licqueue \
	  -64 -sv -uvm \
	  -nowarn BADPRF -nowarn MRSTAR -nowarn NOTLRM -nowarn CUVIHR \
	  -timescale 1ns/1ps  \
	  +define+SVA_ON \
          -F ../../../../../module/proj/verilab_chip/verif/test/${UVM_TESTNAME}.f \
	  -F ../../../../../proj/sim.f \
	  +UVM_NO_RELNOTES \
	  +UVM_TESTNAME=${UVM_TESTNAME} +VSEQ=${VSEQ} -seed ${SEED} +UVM_VERBOSITY=${UVM_VERBOSITY} ${GUI}

questa: simdir
	cd ${SIM_DIR} && \
	vlog \
	  -l compile.log \
	  -64 -sv -mfcu \
	  -lint -novopt -warning 2054 -suppress 175,1902,21810,22230 \
	  -timescale 1ns/1ps \
	  +define+SVA_ON -sva \
          -F ../../../../../module/proj/verilab_chip/verif/test/${UVM_TESTNAME}.f \
	  -F ../../../../../proj/sim.f \
	  -R \
	    -l sim.log \
	    +UVM_NO_RELNOTES \
	    +UVM_TESTNAME=${UVM_TESTNAME} +VSEQ=${VSEQ} -sv_seed ${SEED} +UVM_VERBOSITY=${UVM_VERBOSITY} ${GUI}

simdir: valid_simdir
	rm -fr ${SIM_DIR}
	mkdir -p ${SIM_DIR}

valid_simdir:
	@perl -e'%var = (q(UVM_TESTNAME), q($(origin UVM_TESTNAME)), q(VSEQ), q($(origin VSEQ))); for my $$var (keys(%var)) { if ($$var{$$var} ne q(command line)) { die qq(For a sim, $$var must be specified on commandline. Unable to proceed. For more assistance, try "make help"\n); } }'

clean:
	rm -fr ${CLEAN_DIR}

