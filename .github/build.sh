#!/usr/bin/env bash

DEVICE=lavender

echo "Cloning dependencies"
#lets keep our directories clean
mkdir chute
pushd chute

#git clone --depth=1 https://github.com/kdrag0n/proton-clang clang
git clone --depth=1 https://github.com/wantguns/AnyKernel3 AnyKernel

echo "Done"

ANYKERNELDIR=$(pwd)/AnyKernel/
#GCC="$(pwd)/aarch64-linux-android-"
#IMAGE=$(pwd)/out/arch/arm64/boot/Image.gz-dtb

#PATH="${PWD}/clang/bin:$PATH"
export ARCH=arm64
export KBUILD_BUILD_HOST=SharkBait
export KBUILD_BUILD_USER="wantguns"

popd #now inside the kernel root

# Compile plox
function compile() {
   make O=out ARCH=arm64 sharkbait-lavender_defconfig
       make -j6 O=out \
                             ARCH=arm64 \
			     CROSS_COMPILE_ARM32=arm-linux-gnueabi-
			     CC=gcc \
			     CROSS_COMPILE=aarch64-linux-gnu- \
			     KBUILD_CFLAGS+=-Wno-error
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
