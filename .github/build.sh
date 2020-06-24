#!/usr/bin/env bash
echo "Cloning dependencies"

#lets keep our directories clean
mkdir chute
pushd chute

git clone --depth=1 https://github.com/kdrag0n/proton-clang clang
git clone --depth=1 https://github.com/wantguns/AnyKernel3 AnyKernel

echo "Done"
ANYKERNELDIR=$(pwd)/AnyKernel/
GCC="$(pwd)/aarch64-linux-android-"
IMAGE=$(pwd)/out/arch/arm64/boot/Image.gz-dtb
TANGGAL=$(date +"%F-%S")
START=$(date +"%s")
export CONFIG_PATH=$PWD/arch/arm64/configs/lavender-perf_defconfig
PATH="${PWD}/clang/bin:$PATH"
export ARCH=arm64
export KBUILD_BUILD_HOST=SharkBait
export KBUILD_BUILD_USER="wantguns"
popd
#now inside the kernel root


# Compile plox
function compile() {
   make O=out ARCH=arm64 sharkbait-lavender_defconfig
       make -j$(nproc --all) O=out \
                             ARCH=arm64 \
			     CC=clang -w \
			     CROSS_COMPILE=aarch64-linux-gnu- \
			     CROSS_COMPILE_ARM32=arm-linux-gnueabi-
   cp out/arch/arm64/boot/Image.gz-dtb $ANYKERNELDIR
}
# Zipping
function zipping() {
    pushd .github/chute/AnyKernel || exit 1
    zip -r9 sharkbait-lavender-${TANGGAL}.zip *
    popd ..
}

compile
zipping
END=$(date +"%s")
DIFF=$(($END - $START))
