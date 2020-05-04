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

echo $DEPS
# colors
RED='\033[0;31m'
NC='\033[0m'



post() {
    RED='\033[0;31m'

    echo ✨"${DEPS[@]} added to bsconfig.json!✨\n"

    echo ✨"bsconfig.json ocaml-dependencies ✨\n"
    catbs=$(cat bsconfig.json | jq '.["ocaml-dependencies"]')
    echo $catbs
}
# add the dependencies to bsconfig in installed successfully
handle() {
    DP=$1
    $(cat bsconfig.json | jq --arg DP $DP -r '.["ocaml-dependencies"] 
        += [$DP]' | sponge bsconfig.json)
}
# local DEPS2=${DEPS[@]}


for each in "${DEPS[@]}"; do
    handle "$each"
done
post
