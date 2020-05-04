#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Usage: $0 must provide dependencies"
    exit 1
fi

# check for bsconfig.json in directory
if [ ! -f bsconfig.json ]; then
    echo 👎"${RED}Could not find bsconfig.json 👎\n"
    exit 1
fi

# check for package.json in directory
if [ ! -f package.json ]; then
    echo 👎"${RED}Could not find package.json 👎\n"
    exit 1
fi

# put in parens so its read as array required by jq
DEPS=($@)

echo ✨"Running $1 ${DEPS[@]}  ✨\n"