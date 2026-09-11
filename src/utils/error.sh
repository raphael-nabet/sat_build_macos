#!/bin/sh

recovery_error() {
    if [ $? -ne 0 ]; then 
        echo "$1"
    fi
}
