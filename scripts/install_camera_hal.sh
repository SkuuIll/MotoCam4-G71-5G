#!/system/bin/sh
# Camera HAL installation script for Moto G71 5G

MODDIR=${0%/*}
LOGFILE="/data/local/tmp/motocam4_hal_install.log"

log_message() {
    echo "$(date): $1" >> $LOGFILE
    echo "$1"
}

install_camera_hal() {
    log_message "=== Installing Camera HAL for SM6375 ==="
    
    # Check if target directories exist
    if [ ! -d "/system/lib64/hw" ]; then
        log_message "Creating /system/lib64/hw directory"
        mkdir -p /system/lib64/hw
    fi
    
    if [ ! -d "/system/lib/hw" ]; then
        log_message "Creating /system/lib/hw directory"
        mkdir -p /system/lib/hw
    fi
    
    # Install 64-bit HAL
    if [ -f "$MODDIR/system/lib64/hw/camera.sm6375.so" ]; then
        log_message "Installing 64-bit camera HAL"
        cp "$MODDIR/system/lib64/hw/camera.sm6375.so" "/system/lib64/hw/"
        chmod 644 "/system/lib64/hw/camera.sm6375.so"
        chcon u:object_r:system_lib_file:s0 "/system/lib64/hw/camera.sm6375.so"
    else
        log_message "ERROR: 64-bit camera HAL not found"
        return 1
    fi
    
    # Install 32-bit HAL
    if [ -f "$MODDIR/system/lib/hw/camera.sm6375.so" ]; then
        log_message "Installing 32-bit camera HAL"
        cp "$MODDIR/system/lib/hw/camera.sm6375.so" "/system/lib/hw/"
        chmod 644 "/system/lib/hw/camera.sm6375.so"
        chcon u:object_r:system_lib_file:s0 "/system/lib/hw/camera.sm6375.so"
    else
        log_message "ERROR: 32-bit camera HAL not found"
        return 1
    fi
    
    log_message "Camera HAL installation completed"
    return 0
}

# Validate HAL installation
validate_hal_installation() {
    log_message "=== Validating HAL Installation ==="
    
    local errors=0
    
    # Check 64-bit HAL
    if [ -f "/system/lib64/hw/camera.sm6375.so" ]; then
        log_message "✓ 64-bit camera HAL installed"
    else
        log_message "✗ 64-bit camera HAL missing"
        errors=$((errors + 1))
    fi
    
    # Check 32-bit HAL
    if [ -f "/system/lib/hw/camera.sm6375.so" ]; then
        log_message "✓ 32-bit camera HAL installed"
    else
        log_message "✗ 32-bit camera HAL missing"
        errors=$((errors + 1))
    fi
    
    # Check permissions
    hal_perms=$(stat -c "%a" "/system/lib64/hw/camera.sm6375.so" 2>/dev/null)
    if [ "$hal_perms" = "644" ]; then
        log_message "✓ HAL permissions correct (644)"
    else
        log_message "✗ HAL permissions incorrect: $hal_perms"
        errors=$((errors + 1))
    fi
    
    if [ $errors -eq 0 ]; then
        log_message "HAL validation passed"
        return 0
    else
        log_message "HAL validation failed with $errors errors"
        return 1
    fi
}

# Main execution
if install_camera_hal; then
    validate_hal_installation
else
    log_message "HAL installation failed"
    exit 1
fi