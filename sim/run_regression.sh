#!/bin/bash
# ==============================================================================
# Script: run_regression.sh
# Description: Run multiple tests and merge coverage for RISC-V DUT.
# ==============================================================================

# Exit on first error
set -e

# Source environment
source ../env.sh

# Directory for coverage results
COV_DIR="coverage_results"
mkdir -p $COV_DIR

# List of tests to run (HexFile TestName)
declare -a tests=(
    "../tests/alu_test.hex risc_v_alu_test"
    "../tests/branch_test.hex risc_v_branch_test"
    "../tests/reg_test.hex risc_v_reg_test"
    "../tests/mem_test.hex risc_v_mem_test"
    "../dut/binary_1.txt risc_v_full_program_test"
)

echo "================================================================"
echo " Starting Regression Run"
echo "================================================================"

# Loop through tests
for test in "${tests[@]}"; do
    read -r hex name <<< "$test"
    echo "Running Test: $name with $hex"
    
    # Run simulation with coverage
    vsim -c vopt_top -do "coverage save -onexit $COV_DIR/$name.ucdb; run -all; quit" +UVM_TESTNAME=risc_v_full_program_test +INSTR_FILE=$hex
done

echo "================================================================"
echo " Merging Coverage"
echo "================================================================"

# Merge all UCDB files
vcover merge $COV_DIR/merged.ucdb $COV_DIR/*.ucdb

# Generate Report
vcover report -html $COV_DIR/merged.ucdb -htmldir $COV_DIR/html_report
vcover report -details -all -output $COV_DIR/coverage_report.txt $COV_DIR/merged.ucdb

echo "================================================================"
echo " Regression Completed"
echo " Report generated in $COV_DIR/coverage_report.txt"
echo "================================================================"
