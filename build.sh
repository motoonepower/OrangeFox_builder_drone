#!/bin/bash
MANIFEST="https://gitlab.com/OrangeFox/sync.git"
OEM="motorola"
DEVICE="pokerpatas"
DT_LINK="https://github.com/KatoTempest/motorola_pokerpatas.git -b ofox"
DT_PATH=device/$OEM/$DEVICE


echo " ===+++ Setting up Build Environment +++==="
apt install openssh-server -y
apt update --fix-missing
apt install openssh-server -y

echo " ===+++ Sync OrangeFox +++==="
git clone $MANIFEST ~/FOX && cd ~/FOX
./get_fox_10.sh ~/fox_0.0
cd ~/fox_0.0
git clone $DT_LINK $DT_PATH

echo " ===+++ Running the Extra Command... +++==="
$EXTRA_CMD

echo " ====+++ Building OrangeFox... +++==="
. build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
export LC_ALL="C"
lunch omni_${DEVICE}-eng && mka recoveryimage

# Upload zips & recovery.img
#echo " ===+++ Uploading Recovery +++===
cd out/target/product/$DEVICE

curl -sL https://git.io/file-transfer | sh
./transfer wet OrangeFox*.img
