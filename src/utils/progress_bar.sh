#!/bin/sh

draw_progress_bar() {
    local progress=$1
    local total=$2
    local width=70
    
    local percentage=$((progress * 100 / total))
    local completed=$((progress * width / total))
    local remaining=$((width - completed))
    
    local bar=$(printf "%0.s#" $(seq 1 $completed))
    local spaces=$(printf "%0.s-" $(seq 1 $remaining))
    
    printf "\r[%s%s] %d%%  (%d/%d)\n" "$bar" "$spaces" "$percentage" "$progress" "$total"
}
