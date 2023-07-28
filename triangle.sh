#!/usr/bin/env bash
sumAngleInTriangle=180

solve() {

    sumAngle=$(( $1 + $2 + $3 ))

    if [[ $sumAngle -eq $sumAngleInTriangle ]]; then
        echo "Yes"
    else
        echo "No"
    fi
}

solve "$1" "$2" "$3"