# Get the directory where env.sh is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if command -v cygpath >/dev/null 2>&1; then
    # Git Bash on Windows: convert to mixed path (C:/path/to/dir) for ModelSim
    export RISC_V_TB_DIR=$(cygpath -m "$SCRIPT_DIR")
    
    # Setup QuestaSim License and Path (Industry-style automatic setup)
    export LM_LICENSE_FILE="D:/questasim/win64/LICENSE.dat"
    # Adding QuestaSim to PATH so 'vlog' and 'vsim' commands work in Git Bash
    export PATH="/d/questasim/win64:$PATH"
    
    echo "Environment setup for Windows (Git Bash):"
    echo "  RISC_V_TB_DIR: $RISC_V_TB_DIR"
    echo "  LM_LICENSE_FILE: $LM_LICENSE_FILE"
else
    # Linux
    export RISC_V_TB_DIR="$SCRIPT_DIR"
fi
