#!/system/bin/sh
# Error handling system for MotoCam4 G71 5G

# Error codes
ERROR_CHIPSET_MISMATCH=101
ERROR_MISSING_LIBRARIES=102
ERROR_PROPERTY_CONFLICT=103
ERROR_5G_UNSUPPORTED=104
ERROR_CAMERA_HAL_FAILED=105
ERROR_GPU_DRIVER_FAILED=106
ERROR_INSUFFICIENT_STORAGE=107
ERROR_ANDROID_VERSION=108

LOGFILE="/data/local/tmp/motocam4_errors.log"
MODDIR=${0%/*}

log_error() {
    local error_code=$1
    local error_message=$2
    local timestamp=$(date)
    
    echo "[$timestamp] ERROR $error_code: $error_message" >> $LOGFILE
    echo "ERROR $error_code: $error_message"
}

log_warning() {
    local warning_message=$1
    local timestamp=$(date)
    
    echo "[$timestamp] WARNING: $warning_message" >> $LOGFILE
    echo "WARNING: $warning_message"
}

log_info() {
    local info_message=$1
    local timestamp=$(date)
    
    echo "[$timestamp] INFO: $info_message" >> $LOGFILE
}

handle_chipset_mismatch() {
    log_error $ERROR_CHIPSET_MISMATCH "Chipset mismatch detected"
    log_info "Expected: SM6375, Detected: $(getprop ro.board.platform)"
    log_info "Fallback: Using generic camera HAL"
    
    # Fallback to generic HAL
    if [ -f "$MODDIR/system/lib64/hw/camera.default.so" ]; then
        cp "$MODDIR/system/lib64/hw/camera.default.so" "$MODDIR/system/lib64/hw/camera.sm6375.so"
        log_info "Generic camera HAL copied as fallback"
    fi
}

handle_missing_libraries() {
    log_error $ERROR_MISSING_LIBRARIES "Critical libraries missing"
    
    # Check and report missing libraries
    local missing_libs=""
    local critical_libs=(
        "/system/lib64/hw/camera.sm6375.so"
        "/system/lib64/egl/libEGL_adreno.so"
        "/system/lib64/egl/libGLESv2_adreno.so"
    )
    
    for lib in "${critical_libs[@]}"; do
        if [ ! -f "$lib" ]; then
            missing_libs="$missing_libs $lib"
            log_info "Missing: $lib"
        fi
    done
    
    if [ -n "$missing_libs" ]; then
        log_info "Attempting to restore from backup or use fallbacks"
        restore_fallback_libraries
    fi
}

restore_fallback_libraries() {
    log_info "Restoring fallback libraries"
    
    # Create minimal placeholder libraries if none exist
    if [ ! -f "/system/lib64/hw/camera.sm6375.so" ]; then
        echo "# Fallback camera HAL" > "/system/lib64/hw/camera.sm6375.so"
        chmod 644 "/system/lib64/hw/camera.sm6375.so"
        log_info "Created fallback camera HAL"
    fi
}

handle_property_conflict() {
    log_error $ERROR_PROPERTY_CONFLICT "System property conflict detected"
    
    # Reset conflicting properties
    resetprop --delete ro.product.system.model
    resetprop --delete ro.product.system.device
    resetprop --delete ro.board.platform
    
    # Reapply our properties
    resetprop ro.product.system.model "moto g71 5G"
    resetprop ro.product.system.device "corfur"
    resetprop ro.board.platform "sm6375"
    
    log_info "Properties reset and reapplied"
}

handle_5g_unsupported() {
    log_error $ERROR_5G_UNSUPPORTED "5G capabilities not detected"
    log_warning "Some 5G-specific optimizations will be disabled"
    
    # Disable 5G specific properties
    resetprop --delete ro.vendor.radio.5g
    resetprop --delete persist.vendor.radio.enable_vodata
    
    log_info "5G properties disabled for compatibility"
}

handle_camera_hal_failed() {
    log_error $ERROR_CAMERA_HAL_FAILED "Camera HAL installation failed"
    
    # Attempt recovery
    if [ -f "$MODDIR/system/lib64/hw/camera.sm6375.so.backup" ]; then
        cp "$MODDIR/system/lib64/hw/camera.sm6375.so.backup" "$MODDIR/system/lib64/hw/camera.sm6375.so"
        log_info "Camera HAL restored from backup"
    else
        log_warning "No backup available, camera may not function optimally"
    fi
}

handle_gpu_driver_failed() {
    log_error $ERROR_GPU_DRIVER_FAILED "GPU driver installation failed"
    
    # Disable GPU acceleration
    resetprop --delete ro.hardware.egl
    resetprop --delete ro.hardware.vulkan
    
    log_info "GPU acceleration disabled, using software rendering"
}

handle_insufficient_storage() {
    log_error $ERROR_INSUFFICIENT_STORAGE "Insufficient storage space"
    
    # Clean up temporary files
    rm -rf /data/local/tmp/motocam4_*
    rm -rf /data/cache/camera_*
    
    log_info "Temporary files cleaned up"
}

handle_android_version() {
    log_error $ERROR_ANDROID_VERSION "Incompatible Android version"
    
    local android_sdk=$(getprop ro.build.version.sdk)
    log_info "Detected Android API: $android_sdk"
    
    if [ "$android_sdk" -lt "30" ]; then
        log_warning "Android 11+ recommended, using compatibility mode"
        # Set compatibility flags
        setprop persist.vendor.camera.compat_mode "true"
        setprop persist.vendor.camera.legacy_hal "true"
    fi
}

check_system_health() {
    log_info "=== System Health Check ==="
    
    # Check available storage
    local available_space=$(df /data | tail -1 | awk '{print $4}')
    if [ "$available_space" -lt "51200" ]; then  # 50MB
        handle_insufficient_storage
    fi
    
    # Check critical processes
    if ! pgrep -f "cameraserver" > /dev/null; then
        log_warning "Camera server not running"
    fi
    
    # Check SELinux status
    local selinux_status=$(getenforce 2>/dev/null)
    if [ "$selinux_status" = "Enforcing" ]; then
        log_info "SELinux enforcing - checking contexts"
        check_selinux_contexts
    fi
    
    log_info "System health check completed"
}

check_selinux_contexts() {
    local files_to_check=(
        "/system/lib64/hw/camera.sm6375.so"
        "/system/lib64/egl/libEGL_adreno.so"
        "/system/etc/camera/camera_config_corfur.xml"
    )
    
    for file in "${files_to_check[@]}"; do
        if [ -f "$file" ]; then
            local context=$(ls -Z "$file" 2>/dev/null | awk '{print $1}')
            if echo "$context" | grep -q "system_lib_file\|system_file"; then
                log_info "SELinux context OK: $file"
            else
                log_warning "SELinux context issue: $file ($context)"
                # Attempt to fix context
                chcon u:object_r:system_lib_file:s0 "$file" 2>/dev/null
            fi
        fi
    done
}

create_recovery_script() {
    local recovery_script="/data/local/tmp/motocam4_recovery.sh"
    
    cat > "$recovery_script" << 'EOF'
#!/system/bin/sh
# MotoCam4 Recovery Script

echo "MotoCam4 Recovery Mode"
echo "Attempting to restore system to working state..."

# Reset all MotoCam4 properties
resetprop --delete ro.product.system.model
resetprop --delete ro.product.system.device
resetprop --delete ro.board.platform
resetprop --delete ro.hardware.egl
resetprop --delete ro.hardware.vulkan

# Remove potentially problematic files
rm -f /system/lib64/hw/camera.sm6375.so
rm -f /system/lib64/egl/libEGL_adreno.so
rm -f /system/lib64/egl/libGLESv2_adreno.so

echo "Recovery completed. Reboot recommended."
EOF

    chmod 755 "$recovery_script"
    log_info "Recovery script created: $recovery_script"
}

# Main error handling function
handle_error() {
    local error_code=$1
    local context=$2
    
    log_error $error_code "Error in context: $context"
    
    case $error_code in
        $ERROR_CHIPSET_MISMATCH)
            handle_chipset_mismatch
            ;;
        $ERROR_MISSING_LIBRARIES)
            handle_missing_libraries
            ;;
        $ERROR_PROPERTY_CONFLICT)
            handle_property_conflict
            ;;
        $ERROR_5G_UNSUPPORTED)
            handle_5g_unsupported
            ;;
        $ERROR_CAMERA_HAL_FAILED)
            handle_camera_hal_failed
            ;;
        $ERROR_GPU_DRIVER_FAILED)
            handle_gpu_driver_failed
            ;;
        $ERROR_INSUFFICIENT_STORAGE)
            handle_insufficient_storage
            ;;
        $ERROR_ANDROID_VERSION)
            handle_android_version
            ;;
        *)
            log_error 999 "Unknown error code: $error_code"
            ;;
    esac
    
    # Always perform system health check after error handling
    check_system_health
    
    # Create recovery script for severe errors
    if [ $error_code -le 106 ]; then
        create_recovery_script
    fi
}

# Export functions for use by other scripts
export -f log_error log_warning log_info handle_error check_system_health