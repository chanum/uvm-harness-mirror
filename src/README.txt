-----------------
README
-----------------
This is a snapshot of a design development and corresponding verification effort executing in parallel. It's not finished and *there are bugs*. Download the project files, cd into the top dir, and type 'make'. Explore, and have fun

-----------------
STATUS
-----------------
This is a work-in-progress. The current tests will report errors due to some design module bugs. The purpose here is not to run error-free tests, but to demonstrate the environment topology capabilities.  The following features are currently demonstrated:

- Building the env topology down to ahb_fabric_env
- Using stubs for unused blocks
- Enabling active agents in the ahb_fabric_env and running virtual sequence
- Setting environment and agent roles.
- Allow a test to start a top-level virtual sequence on a virtual sequencer of a lower level (ahb_fabric)
- Verifying a portion of a design before other design modules exist.

-----------------
CONTENTS
-----------------
Note 1: For this project, certain testbench files are tightly associated with design modules. This includes the harness, environment class, and environment configurations. For this reason, these testbench components are organized into a "verif" subdirectory in parallel with the design module code.

Note 2: there is no *real* RTL in this distribution. All "IP" in this case are stub modules with appropriate port lists to demonstrate the testbench capabilities. Other project design modules are used to create the example design hierarchy.

/interfaces/(ip|proj)/<protocol>/verif  : interface-oriented verification components, IP or proj-specific (interface, agent et al, config, sequences, seq item)

/module/(ip|proj)/<block>/verif         : module-oriented verification components, IP or proj-specific (stub, harness, polymorphic harness class, env, config)

/module/proj/<block>/verif/test     : Test classes (to build custom TB hierarchies), test-specific top-level virtual sequences

/proj : scripts and misc project-global files


---------------
EXAMPLE
---------------
make sim UVM_TESTNAME=ahb_fabric_test  VSEQ=ahb_fabric_vseq  TOOL=(vcs|ius|questa)