#!/bin/sh

function synthesis() {
    "$SALOME_WORKSPACE"/SAT/sat compile "$SALOME_VERSION" --show \
        > /tmp/output.txt 2> /dev/null

    grep 'Compilation of' /tmp/output.txt | cut -d " " -f 3 > /tmp/packages-display.txt \
        2> /dev/null

    len=$(grep -c ^ /tmp/packages-display.txt)

    grep 'Already installed' /tmp/output.txt | cut -d " " -f 3 > /tmp/success-packages.txt \
        2> /dev/null

    grep 'Not installed' /tmp/output.txt | cut -d " " -f 3 > /tmp/failed-packages.txt \
        2> /dev/null

    success=$(grep -c ^ /tmp/success-packages.txt)
    failed=$(grep -c ^ /tmp/failed-packages.txt)

    python3 "$SCRIPT_DIR"/utils/chart.py "$success" "$len"

#    echo 'Success Packages :'
#    while read -r package; do
#        echo "   - $package"
#    done < /tmp/success-packages.txt

#    echo 'Failed Packages :'
#    while read -r package; do
#        echo "   - $package"
#    done < /tmp/failed-packages.txt
#
}
