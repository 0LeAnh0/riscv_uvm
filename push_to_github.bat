@echo off
echo Cleaning simulation files...
cd sim
make clean
cd ..

echo Initializing Git repository...
git init

echo Adding files...
git add .

echo Committing...
git commit -m "Initial commit: Complete UVM Verification Environment for RISC-V with 0 Errors and >90% Coverage"

echo Setting up remote repository...
git branch -M main
git remote add origin https://github.com/0LeAnh0/riscv_uvm.git

echo Pushing to GitHub...
git push -u origin main --force

echo Done!
pause
