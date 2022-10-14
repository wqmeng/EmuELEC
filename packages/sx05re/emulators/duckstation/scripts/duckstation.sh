#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

. /etc/profile

LOCAL_CONFIG="/storage/.local/share"
CONFIG_DIR="/emuelec/configs/duckstation"

mkdir -p "${LOCAL_CONFIG}"

if [ ! -d "${CONFIG_DIR}" ]; then
    mkdir -p "${CONFIG_DIR}"
	cp -rf "/usr/config/emuelec/configs/duckstation/*" "${CONFIG_DIR}"
fi

#Check if textures directory exits, if it is not then create symlink to link textures folder in /storage/roms/psx/textures to enable texture replacement
if [ ! -d "${CONFIG_DIR}/textures" ]; then
    ln -s /storage/roms/psx/textures "${CONFIG_DIR}/textures"
fi

#if texture folder exists and not symlink, remove it and create symlink to link textures folder in /storage/roms/psx/textures to enable texture replacement
if [ ! -L "${CONFIG_DIR}/textures" ]; then
    rm -r "${CONFIG_DIR}/textures"
    ln -s /storage/roms/psx/textures "${CONFIG_DIR}"

fi

if [ -d "${LOCAL_CONFIG}/duckstation" ]; then
	rm -rf "${LOCAL_CONFIG}"
fi

if [ ! -L "${LOCAL_CONFIG}/duckstation" ]; then
    ln -sf "${CONFIG_DIR}" "${LOCAL_CONFIG}/duckstation"
fi

AUTOGP=$(get_ee_setting duckstation_auto_gamepad)
if [[ "${AUTOGP}" == "1" ]]; then
	set_duckstation_joy.sh
fi

if [[ "${1}" == *"duckstation_gui.pbp"* ]]; then
    duckstation-nogui -fullscreen
else
    duckstation-nogui -fullscreen -settings "${CONFIG_DIR}/settings.ini" -- "${1}" > /dev/null 2>&1
fi
