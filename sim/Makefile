   #==========================================================================================
# Author: Van Le
# 
# To run simulation in a sim directory, must set the following:
#   setenv RISC_V_TB_DIR $home/projects_intel/uvm_tb
#
# To compile for the risc TB:
#   make compile_risc
#
# To run risc demo test:
#   make vopt_run test_name=risc_demo_test
#   make vis_run test_name=risc_demo_test cmd_args=10
#
#==========================================================================================
#
# make must be run where in the same directory as Makefile
#
#
# To override the test name, use the command line argument: test_name=<test_name>
#
test_name = demo_test
cmd_args ?= 
# To run the risc_demo_test with a value of 6 for NUM_WRITE (default value is 4), use
# cmd_args="NUM_WRITE=6"
defines = DEFAULT
TOP = top
VOPT_TOP = vopt_top
VSIM_CMD = vsim
VOPT_CMD = vopt +acc ${TOP} -o ${VOPT_TOP} +designfile

#
# To override default values in `define, specify a file name with: 
#         make defines=<file name>
#
ifeq (${defines},DEFAULT)
	VLOG_CMD = vlog -timescale 1ns/1ps
else
	VLOG_CMD = vlog -f ${defines}
endif

init:
	ln -s $(RISC_V_TB_DIR)/sim/Makefile
	ln -s $(RISC_V_TB_DIR)/sim/sim.do
	ln -s $(RISC_V_TB_DIR)/sim/wave.do
	ln -s $(RISC_V_TB_DIR)/sim/cov.do

MEM_DIR = $(PROJ_DIR)/uvm_memory_model
DUT_DIR = $(RISC_V_TB_DIR)/dut
IF_DIR = $(RISC_V_TB_DIR)/inf
RISC_IF_DIR = $(RISC_V_TB_DIR)/inf
TB_DIR  = $(RISC_V_TB_DIR)/tb
SIM_DIR = $(RISC_V_TB_DIR)/sim
AGT_DIR = $(TB_DIR)/agt
CFG_DIR = $(TB_DIR)/cfg
TLM_DIR = $(TB_DIR)/tlm/risc_v
CHK_DIR = $(TB_DIR)/chk
COV_DIR = $(TB_DIR)/cov
ENV_DIR = $(TB_DIR)/env
TST_DIR = $(TB_DIR)/tst/risc_v

AGT_MASTER  = $(TB_DIR)/agt/master
AGT_SLAVE = $(TB_DIR)/agt/slave
CFG_RISC_DIR = $(TB_DIR)/cfg/risc_v

AGT_RISC_MASTER_DIR  = $(TB_DIR)/agt/master
AGT_RISC_SLAVE_DIR  = $(TB_DIR)/agt/slave

# compile_risc: def udf dut risc_if tlm seq agt env tst risc_top vopt
 
compile_risc: lib def udf dut risc_if tlm cfg seq agt vblocks chk env tst risc_v_top vopt

ifeq ($(wildcard work),)
lib:
	vlib work
else
lib:
	@echo work library already exists
endif

risc_v_top:
	${VLOG_CMD} -sv +incdir+$(ENV_DIR) $(ENV_DIR)/risc_v_top.sv

def:
	${VLOG_CMD} $(ENV_DIR)/uvm_tb_mem_map_pkg.svh
risc_top:
	${VLOG_CMD} -sv $(ENV_DIR)/risc_top.sv
udf:
	${VLOG_CMD} +incdir+$(ENV_DIR) $(ENV_DIR)/udf_pkg.svh
	${VLOG_CMD} +incdir+$(ENV_DIR) $(ENV_DIR)/uvm_tb_udf_pkg.svh
	${VLOG_CMD} +incdir+$(ENV_DIR) $(ENV_DIR)/risc_v_udf_pkg.svh
dut:
	${VLOG_CMD} -sv -f filelist
risc_if:
	${VLOG_CMD} +incdir+$(ENV_DIR) $(RISC_IF_DIR)/clk_rst_if.sv
	${VLOG_CMD} +incdir+$(ENV_DIR) $(RISC_IF_DIR)/risc_v_if.sv
tlm:
	${VLOG_CMD} +incdir+$(TLM_DIR) +incdir+$(ENV_DIR) $(TLM_DIR)/risc_v_tlm_pkg.svh
cfg:
	${VLOG_CMD} +incdir+$(UVM_SRC) +incdir+$(ENV_DIR) +incdir+$(CFG_RISC_DIR) $(CFG_RISC_DIR)/risc_v_cfg_pkg.svh
seq:
	${VLOG_CMD} +incdir+$(AGT_RISC_MASTER_DIR)/seq +incdir+$(ENV_DIR) $(AGT_RISC_MASTER_DIR)/seq/risc_v_seq_pkg.svh
agt:
	${VLOG_CMD} +incdir+$(AGT_MASTER) +incdir+$(ENV_DIR) $(AGT_MASTER)/risc_v_master_agent_pkg.svh
	${VLOG_CMD} +incdir+$(AGT_SLAVE) +incdir+$(ENV_DIR) $(AGT_SLAVE)/risc_v_slave_agent_pkg.svh
vblocks:
	${VLOG_CMD} +incdir+$(TB_DIR)/vblocks +incdir+$(ENV_DIR) $(TB_DIR)/vblocks/vblocks_pkg.svh
chk:
	${VLOG_CMD} +incdir+$(TLM_DIR) +incdir+$(ENV_DIR) +incdir+$(CHK_DIR) $(CHK_DIR)/uvm_tb_ap_queue_pkg.svh
	${VLOG_CMD} +incdir+$(TLM_DIR) +incdir+$(ENV_DIR) +incdir+$(CHK_DIR) $(CHK_DIR)/risc_v_chk_pkg.svh
cov:
	${VLOG_CMD} +incdir+$(COV_DIR) $(COV_DIR)/uvm_tb_cov_pkg.svh
env:
	${VLOG_CMD} +incdir+$(ENV_DIR) $(ENV_DIR)/risc_v_env_pkg.svh
tst:
	${VLOG_CMD} +incdir+$(ENV_DIR) +incdir+$(TST_DIR) $(TST_DIR)/risc_v_test_pkg.svh
vopt:
	${VOPT_CMD}
vopt_run:
	${VSIM_CMD} -c ${VOPT_TOP} -do sim.do +UVM_TESTNAME=${test_name} ${cmd_args}
vopt_random:
	${VSIM_CMD} -sv_seed random -c ${VOPT_TOP} -do sim.do +UVM_TESTNAME=${test_name} ${cmd_args}
vopt_gui:
	${VSIM_CMD} ${VOPT_TOP} +UVM_TESTNAME=${test_name} 
run:
	${VSIM_CMD} -c $(TOP} -do sim.do +UVM_TESTNAME=${test_name}
	
run_override:
	${VSIM_CMD} -c $(TOP} +UVM_TESTNAME=type_override_test
	
coverage:
	${VSIM_CMD} -c ${VOPT_TOP} -do cov.do +UVM_TESTNAME=${test_name}
	
wave:
	${VSIM_CMD} -voptargs="+acc" $(TOP} +UVM_TESTNAME=${test_name}

vis_run:
	${VSIM_CMD} -c ${VOPT_TOP} -do sim.do +UVM_TESTNAME=${test_name} +NUM_WRITE=${cmd_args} -qwavedb=+signal+class

clean:
	rm -rf  *.wlf *.ucdb transcript work

tar:
	rm -rf  *.wlf log transcript work
	tar cvf ../uvm_tb.tar ../*
	
