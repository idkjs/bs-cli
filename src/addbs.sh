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

preInstall() {
    echo ✨"Running $1 ${DEPS[@]}  ✨\n"
}
pre() {
    echo ✨"Installing ${DEPS[@]} to package.json and bsconfig.json ✨\n"
}

post_fail() {
    echo 👎"${RED}Failed to install ${DEPS[@]} 👎\n"
    echo 👎"${RED}Could not find package-lock.json, yarn.lock or pnpm-lock.yaml 👎\n"
}

post() {
    RED='\033[0;31m'

    echo ✨"${DEPS[@]} installed!✨\n"
    echo ✨"${RED}package.json dependencies ✨\n"
         
    echo $(cat package.json | jq '.dependencies')

    echo "\n"

    echo ✨"bsconfig.json bs-dependencies✨\n"
    catbs=$(cat bsconfig.json | jq '.["bs-dependencies"]')
    echo $catbs
}
# add the dependencies to bsconfig in installed successfully
bsconfig() {
    handle() {
        DP=$1
        $(cat bsconfig.json | jq --arg DP $DP -r '.["bs-dependencies"] 
        += [$DP]' | sponge bsconfig.json)
    }
    local DEPS2=${DEPS[@]}

    for each in "${DEPS[@]}"; do
        handle "$each"
    done
}
npmInstall() {
    # $DEPS arg not required here..
    preInstall "npm install"
    npm install $DEPS
}

yarnAdd() {
    # $DEPS arg IS required here..
    preInstall "yarn add"
    yarn add $DEPS
}

yarn2Add() {
    # $DEPS arg IS required here..
    preInstall "yarn add "
    yarn set version berry
    yarn add $DEPS
}

pnpmInstall() {
    preInstall "pnpm install "
    pnpm install $DEPS
}

if [ -f package-lock.json ]; then
    pre
    if npmInstall; then
        bsconfig
        post
    else
        post_fail
    fi
fi
if [ -f yarn.lock ]; then
    pre
    if yarnAdd; then
        bsconfig
        post
    else
        post_fail
    fi
fi

if [ -f pnpm-lock.yaml ]; then
    pre
    if pnpmInstall; then
        bsconfig
        post
    else
        post_fail
    fi
fi

if [ ! -f package.json ]; then
    fail_no_package_json
fi

