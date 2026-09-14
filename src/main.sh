#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR"/config.sh
. "$SCRIPT_DIR"/utils/help.sh
. "$SCRIPT_DIR"/utils/error.sh
. "$SCRIPT_DIR"/utils/parse_args.sh
. "$SCRIPT_DIR"/build/build_prerequsisites.sh

init() {
    cd $SALOME_WORKSPACE/SAT
    git restore data/local.pyconf
    cd ..
    SAT/sat init --add_project $SALOME_WORKSPACE/SAT_SALOME/salome.pyconf
    SAT/sat prepare "$SALOME_VERSION" -p CONFIGURATION
}

setup() {
    python3 -m venv .venv
    source .venv/bin/activate 
    pip install distro
} 

main() {
    parse_arguments "$@"
    cd $SALOME_WORKSPACE
    if [ "$VIRTUAL" -eq 0 ]; then 
        setup 
    fi
    if [ "$INIT" -eq 0 ]; then
        init
    fi
    if [ -n "$PACKAGE" ]; then
        build_prerequisite "$PACKAGE" 
    elif [ "$ALL" -eq 0 ]; then 
        build_all_prerequisites 
    fi
    if [ "$DISPLAY" -eq 0 ]; then 
        synthesis 
    fi
    exit 0
}

main "$@"
