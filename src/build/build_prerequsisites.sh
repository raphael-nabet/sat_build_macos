#!/bin/sh

build_prerequisite() { 
    prepare=1

    echo $SALOME_WORKSPACE"/"$INSTALLATION_FOLDER"/SOURCES/"$1
    if [ -d "$SALOME_WORKSPACE"/"$INSTALLATION_FOLDER"/SOURCES/"$1" ] || [ $PREPARE -eq 0 ]; then
        echo "No need to prepare"
    else
        "$SALOME_WORKSPACE"/SAT/sat prepare "$SALOME_VERSION" -p "$1"
        prepare=0
    fi

    "$SALOME_WORKSPACE"/SAT/sat compile "$SALOME_VERSION" -p "$1"

    if [ $? -ne 0 ] && [ "$prepare" -eq 1 ] && [ $PREPARE -eq 1 ]; then
        "$SALOME_WORKSPACE"/SAT/sat prepare "$SALOME_VERSION" -p "$1" 
        "$SALOME_WORKSPACE"/SAT/sat compile "$SALOME_VERSION" -p "$1"
    fi

    recovery_error "Compile $1 prerequisite failed"
} 


build_all_prerequisites() {
    "$SALOME_WORKSPACE"/SAT/sat compile "$SALOME_VERSION" --show \
        > /tmp/output.txt 2> /dev/null

    grep 'Compilation of' /tmp/output.txt | cut -d " " -f 3 > /tmp/packages.txt \
        2> /dev/null

    len=$(grep -c ^ /tmp/packages.txt)
    i=0

    while read -u 3 package; do
        build_prerequisite "$package" 

        if [ $PROGRESS_BAR -eq 0 ]; then
            draw_progress_bar "$i" "$len"
        fi

        if [ $INTERACTIVE -eq 0 ]; then
            while true; do
                read -p "Do you want to continue ? (y/n) : " choice
                case "$choice" in
                    [yY]) break ;;
                    [nN]) exit 0 ;;
                    *) echo 'Ínvalid input' ;;
                esac
            done
        fi

        i=$(($i + 1))
    done 3< /tmp/packages.txt
}
