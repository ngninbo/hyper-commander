#!/usr/bin/env bash
sumAngleInTriangle=180

solve() {
    [[ $(( $1 + $2 + $3 )) -eq $sumAngleInTriangle ]] && echo "Yes" || echo "No"
}

solve "$1" "$2" "$3"