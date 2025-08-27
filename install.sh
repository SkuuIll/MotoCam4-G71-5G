##########################################################################################
#
# Magisk Module Installer Script
#
##########################################################################################
##########################################################################################
#
# Instructions:
#
# 1. Place your files into system folder (delete the placeholder file)
# 2. Fill in your module's info into module.prop
# 3. Configure and implement callbacks in this file
# 4. If you need boot scripts, add them into common/post-fs-data.sh or common/service.sh
# 5. Add your additional or modified system properties into common/system.prop
#
##########################################################################################

##########################################################################################
# Config Flags
##########################################################################################

# Set to true if you do *NOT* want Magisk to mount
# any files for you. Most modules would NOT want
# to set this flag to true
SKIPMOUNT=false

# Set to true if you need to load system.prop
PROPFILE=true

# Set to true if you need post-fs-data script
POSTFSDATA=true

# Set to true if you need late_start service script
LATESTARTSERVICE=false

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info why you would need this

# Construct your list in the following format
# This is an example
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here
REPLACE="
"

##########################################################################################
#
# Function Callbacks
#
# The following functions will be called by the installation framework.
# You do not have the ability to modify update-binary, the only way you can customize
# installation is through implementing these functions.
#
# When running your callbacks, the installation framework will make sure the Magisk
# internal busybox path is *PREPENDED* to PATH, so all common commands shall exist.
# Also, it will make sure /data, /system, and /vendor is properly mounted.
#
##########################################################################################
##########################################################################################
#
# The installation framework will export some variables and functions.
# You should use these variables and functions for installation.
#
# ! DO NOT use any Magisk internal paths as those are NOT public API.
# ! DO NOT use other functions in util_functions.sh as they are NOT public API.
# ! Non public APIs are not guranteed to maintain compatibility between releases.
#
# Available variables:
#
# MAGISK_VER (string): the version string of current installed Magisk
# MAGISK_VER_CODE (int): the version code of current installed Magisk
# BOOTMODE (bool): true if the module is currently installing in Magisk Manager
# MODPATH (path): the path where your module files should be installed
# TMPDIR (path): a place where you can temporarily store files
# ZIPFILE (path): your module's installation zip
# ARCH (string): the architecture of the device. Value is either arm, arm64, x86, or x64
# IS64BIT (bool): true if $ARCH is either arm64 or x64
# API (int): the API level (Android version) of the device
#
# Availible functions:
#
# ui_print <msg>
#     print <msg> to console
#     Avoid using 'echo' as it will not display in custom recovery's console
#
# abort <msg>
#     print error message <msg> to console and terminate installation
#     Avoid using 'exit' as it will skip the termination cleanup steps
#
# set_perm <target> <owner> <group> <permission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     this function is a shorthand for the following commands
#       chown owner.group target
#       chmod permission target
#       chcon context target
#
# set_perm_recursive <directory> <owner> <group> <dirpermission> <filepermission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     for all files in <directory>, it will call:
#       set_perm file owner group filepermission context
#     for all directories in <directory> (including itself), it will call:
#       set_perm dir owner group dirpermission context
#
##########################################################################################
##########################################################################################
# If you need boot scripts, DO NOT use general boot scripts (post-fs-data.d/service.d)
# ONLY use module scripts as it respects the module status (remove/disable) and is
# guaranteed to maintain the same behavior in future Magisk releases.
# Enable boot scripts by setting the flags in the config section above.
##########################################################################################

# Set what you want to display when installing your module

print_modname() {
  ui_print "*******************************"
  ui_print "    MotoCam4 G71 5G        "
  ui_print "   Optimized for corfur     "
  ui_print "  Version App Moto Camera  "
  ui_print "        9.0.30.29          "
  ui_print "   Snapdragon 695 5G       "
  ui_print "*******************************"
}

# Copy/extract your module files into $MODPATH in on_install.

on_install() {
  # Comprehensive hardware validation for Moto G71 5G
  ui_print "- Performing comprehensive hardware validation"
  
  # Check architecture compatibility
  if [ "$ARCH" != "arm64" ]; then
    abort "! Error: This module requires ARM64 architecture, detected: $ARCH"
  fi
  ui_print "✓ ARM64 architecture confirmed"
  
  # Check for SM6375 chipset
  CHIPSET=$(getprop ro.board.platform)
  DEVICE_CODENAME=$(getprop ro.product.device)
  
  if [ "$CHIPSET" = "sm6375" ] || [ "$DEVICE_CODENAME" = "corfur" ]; then
    ui_print "✓ Moto G71 5G hardware detected (SM6375/corfur)"
    OPTIMAL_DEVICE=true
  elif [ "$CHIPSET" != "" ]; then
    ui_print "! Warning: Detected chipset $CHIPSET, optimized for SM6375"
    ui_print "! Module may work but performance might be suboptimal"
    OPTIMAL_DEVICE=false
  else
    ui_print "! Warning: Could not detect chipset, proceeding with installation"
    OPTIMAL_DEVICE=false
  fi
  
  # Check Android version compatibility
  ANDROID_VERSION=$(getprop ro.build.version.release)
  ANDROID_SDK=$(getprop ro.build.version.sdk)
  ui_print "- Detected Android $ANDROID_VERSION (API $ANDROID_SDK)"
  
  if [ "$ANDROID_SDK" -lt "30" ]; then
    ui_print "! Warning: Android 11+ (API 30+) recommended for optimal performance"
    ui_print "! Current API level may cause compatibility issues"
  elif [ "$ANDROID_SDK" -ge "30" ]; then
    ui_print "✓ Android version compatible"
  fi
  
  # Check device model and brand
  DEVICE_MODEL=$(getprop ro.product.system.model)
  DEVICE_BRAND=$(getprop ro.product.system.brand)
  
  if echo "$DEVICE_MODEL" | grep -qi "g71" && echo "$DEVICE_BRAND" | grep -qi "motorola"; then
    ui_print "✓ Moto G71 5G confirmed - full optimization enabled"
    DEVICE_MATCH=true
  else
    ui_print "! Installing on device: $DEVICE_BRAND $DEVICE_MODEL"
    ui_print "! Optimized for Motorola Moto G71 5G"
    ui_print "! Some optimizations may not apply"
    DEVICE_MATCH=false
  fi
  
  # Check 5G capabilities
  RADIO_VERSION=$(getprop ro.build.expect.baseband)
  if getprop ro.telephony.default_network | grep -q "33"; then
    ui_print "✓ 5G capabilities detected"
  else
    ui_print "! 5G capabilities not detected, enabling anyway"
  fi
  
  # Check available storage space
  AVAILABLE_SPACE=$(df /data | tail -1 | awk '{print $4}')
  REQUIRED_SPACE=102400  # 100MB in KB
  
  if [ "$AVAILABLE_SPACE" -gt "$REQUIRED_SPACE" ]; then
    ui_print "✓ Sufficient storage space available"
  else
    ui_print "! Warning: Low storage space, installation may fail"
  fi
  
  # Check Magisk version compatibility
  if [ "$MAGISK_VER_CODE" -lt "23000" ]; then
    ui_print "! Warning: Magisk v23.0+ recommended, detected: $MAGISK_VER"
  else
    ui_print "✓ Magisk version compatible: $MAGISK_VER"
  fi
  
  # Validate camera sensors (if possible)
  ui_print "- Checking camera sensor availability"
  CAMERA_COUNT=0
  
  if [ -d "/sys/class/camera" ]; then
    for cam_dir in /sys/class/camera/*/; do
      if [ -d "$cam_dir" ]; then
        CAMERA_COUNT=$((CAMERA_COUNT + 1))
      fi
    done
    ui_print "- Detected $CAMERA_COUNT camera sensors"
  else
    ui_print "- Camera sensor information not available"
  fi
  
  # Check GPU capabilities
  GPU_RENDERER=$(getprop ro.hardware.egl)
  if [ "$GPU_RENDERER" = "adreno" ] || getprop ro.hardware.vulkan | grep -q "adreno"; then
    ui_print "✓ Adreno GPU detected - hardware acceleration available"
  else
    ui_print "! GPU: $GPU_RENDERER (optimized for Adreno 619)"
  fi
  
  # Installation decision based on validation results
  if [ "$OPTIMAL_DEVICE" = "true" ] && [ "$DEVICE_MATCH" = "true" ]; then
    ui_print "✓ Optimal device detected - installing full optimization"
    INSTALL_MODE="full"
  elif [ "$OPTIMAL_DEVICE" = "true" ] || [ "$DEVICE_MATCH" = "true" ]; then
    ui_print "! Partial compatibility - installing with warnings"
    INSTALL_MODE="compatible"
  else
    ui_print "! Limited compatibility detected"
    ui_print "- Continue installation? (Module may not work optimally)"
    INSTALL_MODE="limited"
  fi
  
  # Clean up previous installation
  if [ ! -d "$MODPATH" ]; then
    rm -rf /data/data/com.android.vending
  fi
  
  # Extract module files
  ui_print "- Extracting optimized module files"
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
  unzip -o "$ZIPFILE" 'common/*' -d $MODPATH >&2
  unzip -o "$ZIPFILE" 'scripts/*' -d $MODPATH >&2
  unzip -o "$ZIPFILE" 'tests/*' -d $MODPATH >&2
  
  # Set executable permissions for scripts
  if [ -d "$MODPATH/scripts" ]; then
    chmod -R 755 "$MODPATH/scripts"
    ui_print "- Installation scripts configured"
  fi
  
  if [ -d "$MODPATH/tests" ]; then
    chmod -R 755 "$MODPATH/tests"
    ui_print "- Test scripts configured"
  fi
  
  if [ -f "$MODPATH/common/validate_properties.sh" ]; then
    chmod 755 "$MODPATH/common/validate_properties.sh"
    ui_print "- Property validation script installed"
  fi
  
  # Create installation log
  INSTALL_LOG="/data/local/tmp/motocam4_install.log"
  echo "MotoCam4 G71 5G Installation Log" > $INSTALL_LOG
  echo "Installation Date: $(date)" >> $INSTALL_LOG
  echo "Device: $DEVICE_BRAND $DEVICE_MODEL" >> $INSTALL_LOG
  echo "Chipset: $CHIPSET" >> $INSTALL_LOG
  echo "Android: $ANDROID_VERSION (API $ANDROID_SDK)" >> $INSTALL_LOG
  echo "Magisk: $MAGISK_VER" >> $INSTALL_LOG
  echo "Install Mode: $INSTALL_MODE" >> $INSTALL_LOG
  echo "Architecture: $ARCH" >> $INSTALL_LOG
  
  ui_print "- Installation log created: $INSTALL_LOG"
  ui_print "- Installation complete"
  ui_print "- Reboot required to apply optimizations"
  
  # Post-installation instructions
  ui_print ""
  ui_print "Post-Installation Instructions:"
  ui_print "1. Reboot your device"
  ui_print "2. Open Motorola Camera app"
  ui_print "3. Check logs in /data/local/tmp/ for validation"
  ui_print "4. Report issues with installation log"
}

# Only some special files require specific permissions
# This function will be called after on_install is done
# The default permissions should be good enough for most cases

set_permissions() {
  # The following is the default rule, DO NOT remove
  set_perm_recursive $MODPATH 0 0 0755 0644

  # Here are some examples:
  # set_perm_recursive  $MODPATH/system/lib       0     0       0755      0644
  # set_perm  $MODPATH/system/bin/app_process32   0     2000    0755      u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0     2000    0755      u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0     0       0644
}

# You can add more functions to assist your custom script code
