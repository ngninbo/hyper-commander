#!usr/bin/env/bash

min=500;
max=1000;

read input

if [ $input -ge "$min" -a $input -le "$max" ]; then
    echo "Good Job!"
else
    echo "Revise the essay"
fi