#!/system/bin/sh
# Property validation script for Moto G71 5G optimization
# This script validates that all required properties are set correctly

LOGFILE="/data/local/tmp/motocam4_validation.log"

log_message() {
    echo "$(date): $1" >> $LOGFILE
}

validate_property() {
    local prop_name="$1"
    local expected_value="$2"
    local actual_value=$(getprop "$prop_name")
    
    if [ "$actual_value" = "$expected_value" ]; then
        log_message "✓ $prop_name = $actual_value"
        return 0
    else
        log_message "✗ $prop_name = $actual_value (expected: $expected_value)"
        return 1
    fi
}

log_message "=== MotoCam4 G71 5G Property Validation Started ==="

# Validate basic device properties
validate_property "ro.product.system.model" "moto g71 5G"
validate_property "ro.product.system.device" "corfur"
validate_property "ro.product.system.brand" "motorola"

# Validate chipset properties
validate_property "ro.soc.model" "SM6375"
validate_property "ro.board.platform" "sm6375"

# Validate GPU properties
validate_property "ro.hardware.egl" "adreno"
validate_property "ro.opengles.version" "196610"

# Validate 5G properties
validate_property "ro.telephony.default_network" "33,33"
validate_property "ro.vendor.radio.5g" "1"

# Validate camera properties
camera_packages=$(getprop "ro.vendor.camera.aux.packagelist")
if echo "$camera_packages" | grep -q "com.motorola.camera2"; then
    log_message "✓ Camera package list includes Motorola Camera"
else
    log_message "✗ Camera package list missing Motorola Camera"
fi

# Check if critical libraries exist
check_library() {
    local lib_path="$1"
    if [ -f "$lib_path" ]; then
        log_message "✓ Library found: $lib_path"
    else
        log_message "✗ Library missing: $lib_path"
    fi
}

log_message "=== Library Validation ==="
check_library "/system/lib64/hw/camera.sm6375.so"
check_library "/system/lib64/egl/libEGL_adreno.so"
check_library "/system/lib64/egl/libGLESv2_adreno.so"

log_message "=== Validation Complete ==="
log_message "Check $LOGFILE for detailed results"