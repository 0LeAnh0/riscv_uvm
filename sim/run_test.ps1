<#
.SYNOPSIS
Industry-style script to run RISC-V UVM tests on Windows.

.DESCRIPTION
This script sets up the environment variables and runs the simulation
with optional arguments for test name and instruction file.

.PARAMETER TestName
The name of the UVM test to run.

.PARAMETER InstrFile
Path to the hex instruction file to be loaded in the instruction memory.

.EXAMPLE
.\run_test.ps1 -TestName risc_v_random_reset_test -InstrFile ..\dut\binary_1.txt
#>

param (
    [string]$TestName = "risc_v_demo_test",
    [string]$InstrFile = ""
)

Write-Host "================================================================"
Write-Host " Starting UVM Verification for RISC-V DUT"
Write-Host " Test: $TestName"
if ($InstrFile -ne "") {
    Write-Host " Instruction File: $InstrFile"
}
Write-Host "================================================================"

# Source the environment variables if not set
if (-not (Test-Path Env:\RISC_V_TB_DIR)) {
    Write-Host "Setting Environment Variables (RISC_V_TB_DIR, LM_LICENSE_FILE, PATH)..."
    $env:RISC_V_TB_DIR = (Resolve-Path ..).Path
    $env:LM_LICENSE_FILE = "D:/questasim/win64/LICENSE.dat"
    $env:PATH = "D:\questasim\win64;" + $env:PATH
}

Write-Host "[1/3] Cleaning previous run artifacts..."
make clean > $null 2>&1

Write-Host "[2/3] Compiling testbench..."
make compile_risc

Write-Host "[3/3] Running Simulation..."
if ($InstrFile -ne "") {
    make vopt_run test_name=$TestName cmd_args="+INSTR_FILE=$InstrFile"
} else {
    make vopt_run test_name=$TestName
}

Write-Host "================================================================"
Write-Host " Simulation Completed: $TestName"
Write-Host "================================================================"
