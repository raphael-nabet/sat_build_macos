#!/bin/sh

parse_arguments() {
    if [ "$#" -eq 0 ]; then
        help
        exit 1
    fi
    while [ "$#" -gt 0 ]; do
        case "$1" in
            -h | --help)
                help
                exit 1
                ;;
            -t | --interactive)
                INTERACTIVE=0
                shift
                ;;
            -p | --package)
                PACKAGE=$2
                shift
                shift
                ;;
            -a | --all)
                ALL=0 
                shift
                ;;
            -d | --display)
                DISPLAY=0
                shift
                ;;
            -n | --no-prepare)
                PREPARE=0
                shift
                ;;
            -v | --virtual-env)
                VIRTUAL=0
                shift
                ;;
            -i | --init)
                INIT=0
                shift 
                ;;
            --)
                shift
                ;;
            *)
                echo 'Invalid Arguments'
                help
                exit 1
                ;;
        esac
    done
}
