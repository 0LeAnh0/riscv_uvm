#!/bin/bash
# ==============================================================================
# Script: run_test.sh
# Description: Industry-style script to run RISC-V UVM tests.
# Usage: ./run_test.sh [TEST_NAME] [INSTR_FILE]
# Example: ./run_test.sh risc_v_random_reset_test ../dut/binary_1.txt
# ==============================================================================

# Exit on first error
set -e

# Default test name
TEST_NAME=${1:-risc_v_demo_test}
# Default instruction file (optional)
INSTR_FILE=${2:-}

echo "================================================================"
echo " Starting UVM Verification for RISC-V DUT"
echo " Test: $TEST_NAME"
if [ ! -z "$INSTR_FILE" ]; then
    echo " Instruction File: $INSTR_FILE"
fi
echo "================================================================"

# Source the environment variables if not set
if [ -z "$RISC_V_TB_DIR" ]; then
    echo "Sourcing ../env.sh..."
    source ../env.sh
fi

echo "[1/3] Cleaning previous run artifacts..."
make clean > /dev/null 2>&1 || true

echo "[2/3] Compiling testbench..."
make compile_risc

echo "[3/3] Running Simulation..."
if [ ! -z "$INSTR_FILE" ]; then
    make vopt_run test_name=$TEST_NAME cmd_args="+INSTR_FILE=$INSTR_FILE"
else
    make vopt_run test_name=$TEST_NAME
fi

echo "================================================================"
echo " Simulation Completed: $TEST_NAME"
echo "================================================================"
