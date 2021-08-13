#!/usr/bin/env bash

find ../work/answer -type f -name "*.ipynb" -print0 | xargs -0 -n 1 notebook jupyter nbconvert --to notebook --execute --ExecutePreprocessor.timeout=1800
