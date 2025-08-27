#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in post-fs-data mode

# Basic device properties for Moto G71 5G
resetprop ro.product.system.brand motorola
resetprop ro.product.system.device corfur
resetprop ro.product.system.manufacturer motorola
resetprop ro.product.system.model "moto g71 5G"
resetprop ro.product.system.name corfur_retail
resetprop ro.product.product.brand motorola
resetprop ro.product.product.manufacturer motorola
resetprop ro.product.product.model "moto g71 5G"
resetprop ro.product.product.name corfur_retail
resetprop ro.product.system_ext.brand motorola
resetprop ro.product.system_ext.device corfur
resetprop ro.product.system_ext.manufacturer motorola
resetprop ro.product.system_ext.model "moto g71 5G"
resetprop ro.product.system_ext.name corfur_retail
resetprop ro.product.model_for_attestation "moto g71 5G"
resetprop ro.product.brand_for_attestation motorola
resetprop ro.product.name_for_attestation corfur_retail

# Chipset specific properties (Snapdragon 695 5G - SM6375)
resetprop ro.soc.manufacturer Qualcomm
resetprop ro.soc.model SM6375
resetprop ro.vendor.qti.soc_name SM6375
resetprop ro.board.platform sm6375

# GPU properties (Adreno 619)
resetprop ro.hardware.egl adreno
resetprop ro.hardware.vulkan adreno
resetprop ro.opengles.version 196610
resetprop ro.vendor.gpu.available_frequencies "315000000 401800000 490000000 555000000"

# 5G Radio properties
resetprop ro.telephony.default_network 33,33
resetprop ro.vendor.radio.5g 1
resetprop ro.vendor.radio.features_common 3
resetprop persist.vendor.radio.enable_vodata 1
resetprop persist.vendor.radio.enable_fd_plmn 1
resetprop persist.vendor.radio.rat_on "combine"

# Camera specific properties
resetprop ro.vendor.camera.aux.packagelist "org.codeaurora.snapcam,com.motorola.camera2"
resetprop ro.vendor.camera.res.fmq.size 1048576
resetprop ro.vendor.camera.req.fmq.size 67108864
resetprop persist.vendor.camera.privapp.list "org.codeaurora.snapcam,com.motorola.camera2"

# Display properties specific to G71 5G
resetprop ro.sf.lcd_density 400
resetprop vendor.display.comp_mask 0
resetprop vendor.display.enable_default_color_mode 1

# Audio properties
resetprop ro.vendor.audio.sdk.fluencetype fluence
resetprop persist.vendor.audio.fluence.voicecall true
resetprop persist.vendor.audio.fluence.voicecomm true

# Performance properties
resetprop ro.vendor.perf.scroll_opt true
resetprop ro.vendor.extension_library /vendor/lib64/libqti-perfd-client.so

# Fingerprint properties (if applicable)
resetprop ro.hardware.fingerprint fpc
resetprop persist.vendor.sys.fp.fod.location.X_Y "540,2030"

# Thermal properties
resetprop persist.vendor.sys.thermal.enable true
resetprop ro.vendor.thermal.config thermal_info_config.json
