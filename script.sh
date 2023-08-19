#!/usr/bin/env bash

case "${1}" in

    "") echo "No option was selected." ;;
    [1-3]) echo "You selected '${1}'." ;;
    *) echo "Unknown number '${1}'." ;;

esac