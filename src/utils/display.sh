#!/bin/sh

function synthesis() {
    "$SALOME_WORKSPACE"/SAT/sat compile "$SALOME_VERSION" --show \
        > /tmp/output.txt 2> /dev/null

    grep 'Already installed' /tmp/output.txt | cut -d " " -f 3 > /tmp/success-packages.txt \
        2> /dev/null

    grep 'Not installed' /tmp/output.txt | cut -d " " -f 3 > /tmp/failed-packages.txt \
        2> /dev/null

    echo 'Success Packages :'
    while read -r package; do
        echo "   - $package"
    done < /tmp/success-packages.txt

    echo 'Failed Packages :'
    while read -r package; do
        echo "   - $package"
    done < /tmp/failed-packages.txt
}
