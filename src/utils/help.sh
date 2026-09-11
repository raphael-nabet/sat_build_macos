#!/bin/sh 

help() {                                                               
    echo 'OVERVIEW: Script to build SALOME on macOS

    USAGE: compile_macOS <args> -- [<filenames>]
    
    OPTIONS:                                                                    
      -t | --interactive            Enable interactive mode
      -i | --init                   Expose SAT_SALOME to SAT
      -p | --package                Build a specific package
      -n | --no-prepare             Disable prepare step
      -v | --virtual-env            Enable python virtual environement
      -a | --all                    Build all packages
      -d | --display                Show all the installation that have succeeded and failed
      -h | --help                   Display available options'
}
