#!/usr/bin/env bash

min=500;
max=1000;

# shellcheck disable=SC2162
read input

if [[ "$input" -ge "$min" && "$input" -le "$max" ]]; then
    echo "Good Job!"
else
    echo "Revise the essay"
fi