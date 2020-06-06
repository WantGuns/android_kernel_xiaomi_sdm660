#!/usr/bin/env bash
echo "Cloning dependencies"

#lets keep our directories clean
mkdir chute
cd chute

#git clone --depth=1 https://github.com/Haseo97/Clang-10.0.0 clang
#git clone --depth=1 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 -b android-9.0.0_r39 stock
#git clone --depth=1 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 -b android-9.0.0_r39 stock_32
#git clone --depth=1 https://github.com/Yasir-siddiqui/AnyKernel3 AnyKernel

git clone --depth=1 https://github.com/kdrag0n/proton-clang clang
git clone --depth=1 https://github.com/sohamxda7/AnyKernel3 AnyKernel

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

#now back inside the kernel root
cd .. 

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
    cd chute/AnyKernel || exit 1
    zip -r9 sharkbait-lavender-${TANGGAL}.zip *
    cd ..
}

compile
zipping
END=$(date +"%s")
DIFF=$(($END - $START))

