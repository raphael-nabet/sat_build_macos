#!/bin/sh

help() {
    echo 'OVERVIEW: Script to build SALOME on macOS

    USAGE: build <args> -- [<filenames>]

    OPTIONS:
      -t | --interactive            Enable interactive mode
      -i | --init                   Expose SAT_SALOME to SAT
      -p | --package                Build a specific package
      -s | --show-progress-bar      Show the current progress of the installation
      -n | --no-prepare             Disable prepare step
      -v | --virtual-env            Enable python virtual environement
      -a | --all                    Build all packages
      -d | --display                Show all the installation that have succeeded and failed
      -u | --update                 Update the SAT and SAT_SALOME repositories and execute the build command
      -h | --help                   Display available options'
}
