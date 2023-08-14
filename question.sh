#!/usr/bin/env bash

item="$(cat question.txt)"

question="$(python3 -c "data=$item; print(data.get('question'))")"

echo "$question"