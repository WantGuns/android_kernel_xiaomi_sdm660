#!/usr/bin/env bash

DEVICE=lavender

echo "Cloning dependencies"
#lets keep our directories clean
mkdir chute
pushd chute

git clone --depth=1 https://github.com/wantguns/AnyKernel3 AnyKernel
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential

echo "Done"

ANYKERNELDIR=$(pwd)/AnyKernel/

export ARCH=arm64
export KBUILD_BUILD_HOST=SharkBait
export KBUILD_BUILD_USER="wantguns"

popd #now inside the kernel root

# Compile plox
function compile() {
   make O=out ARCH=arm64 sharkbait-lavender_defconfig
   make -j$(nproc --all) O=out ARCH=arm64
   cp out/arch/arm64/boot/Image.gz-dtb $ANYKERNELDIR
}
# Zipping
function zipping() {
    pushd chute/AnyKernel || exit 1
    zip -r9 sharkbait-$DEVICE.zip *
    popd
}

compile
zipping
