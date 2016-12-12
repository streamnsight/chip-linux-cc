#!/usr/bin/env bash

if [ -e "/home/workspace/shared/config" ];
then
	echo "Using CONFIG file from shared folder"
	cp /home/workspace/shared/config /home/workspace/CHIP-linux/.config
fi

cd $WORKSPACE/CHIP-linux
# menu config
make ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf- menuconfig

# make kernel
make -j9 ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf- zImage dtbs

# build and install modules
make -j9 ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf- INSTALL_MOD_PATH=$WORKSPACE modules
make -j9 ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf- INSTALL_MOD_PATH=$WORKSPACE modules_install

# get the name registered for this kernel from the modules directory
export KERNEL_VERSION=$(ls $WORKSPACE/lib/modules/)

# move the firmware to the right folder
mkdir -p $WORKSPACE/lib/firmware/$KERNEL_VERSION

shopt -s extglob
mv $WORKSPACE/lib/firmware/!($KERNEL_VERSION) ${WORKSPACE}/lib/firmware/${KERNEL_VERSION}

mkdir -p $WORKSPACE/boot
cp $WORKSPACE/CHIP-linux/arch/arm/boot/zImage $WORKSPACE/boot/vmlinuz-${KERNEL_VERSION}
cp $WORKSPACE/CHIP-linux/arch/arm/boot/dts/sun5i-r8-chip.dtb $WORKSPACE/boot/
cp $WORKSPACE/CHIP-linux/.config $WORKSPACE/boot/config-${KERNEL_VERSION}
cp $WORKSPACE/CHIP-linux/System.map $WORKSPACE/boot/System.map-${KERNEL_VERSION}

mkdir -p $WORKSPACE/shared
cd $WORKSPACE
tar -cvzf ./shared/CHIP-linux-${KERNEL_VERSION}.tar.gz boot lib