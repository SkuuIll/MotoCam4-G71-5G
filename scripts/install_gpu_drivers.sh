#!/system/bin/sh
# GPU driver installation script for Adreno 619 (Moto G71 5G)

MODDIR=${0%/*}
LOGFILE="/data/local/tmp/motocam4_gpu_install.log"

log_message() {
    echo "$(date): $1" >> $LOGFILE
    echo "$1"
}

install_gpu_drivers() {
    log_message "=== Installing Adreno 619 GPU Drivers ==="
    
    # Create EGL directories if they don't exist
    mkdir -p /system/lib64/egl
    mkdir -p /system/lib/egl
    
    # Install 64-bit EGL drivers
    local drivers_64bit=(
        "libEGL_adreno.so"
        "libGLESv2_adreno.so"
    )
    
    for driver in "${drivers_64bit[@]}"; do
        if [ -f "$MODDIR/system/lib64/egl/$driver" ]; then
            log_message "Installing 64-bit driver: $driver"
            cp "$MODDIR/system/lib64/egl/$driver" "/system/lib64/egl/"
            chmod 644 "/system/lib64/egl/$driver"
            chcon u:object_r:system_lib_file:s0 "/system/lib64/egl/$driver"
        else
            log_message "WARNING: 64-bit driver not found: $driver"
        fi
    done
    
    # Install 32-bit EGL drivers
    local drivers_32bit=(
        "libEGL_adreno.so"
        "libGLESv2_adreno.so"
    )
    
    for driver in "${drivers_32bit[@]}"; do
        if [ -f "$MODDIR/system/lib/egl/$driver" ]; then
            log_message "Installing 32-bit driver: $driver"
            cp "$MODDIR/system/lib/egl/$driver" "/system/lib/egl/"
            chmod 644 "/system/lib/egl/$driver"
            chcon u:object_r:system_lib_file:s0 "/system/lib/egl/$driver"
        else
            log_message "WARNING: 32-bit driver not found: $driver"
        fi
    done
    
    # Install LLVM compiler library
    if [ -f "$MODDIR/system/lib64/libllvm-glnext.so" ]; then
        log_message "Installing LLVM compiler library"
        cp "$MODDIR/system/lib64/libllvm-glnext.so" "/system/lib64/"
        chmod 644 "/system/lib64/libllvm-glnext.so"
        chcon u:object_r:system_lib_file:s0 "/system/lib64/libllvm-glnext.so"
    else
        log_message "WARNING: LLVM compiler library not found"
    fi
    
    log_message "GPU driver installation completed"
}

configure_gpu_properties() {
    log_message "=== Configuring GPU Properties ==="
    
    # Set Adreno 619 specific properties
    setprop ro.hardware.egl adreno
    setprop ro.hardware.vulkan adreno
    setprop ro.opengles.version 196610
    
    # Set GPU frequency scaling
    if [ -f "/sys/class/kgsl/kgsl-3d0/devfreq/available_frequencies" ]; then
        local available_freqs=$(cat /sys/class/kgsl/kgsl-3d0/devfreq/available_frequencies)
        log_message "Available GPU frequencies: $available_freqs"
        
        # Set performance governor for better camera performance
        if [ -f "/sys/class/kgsl/kgsl-3d0/devfreq/governor" ]; then
            echo "performance" > /sys/class/kgsl/kgsl-3d0/devfreq/governor 2>/dev/null
            log_message "GPU governor set to performance"
        fi
    fi
    
    log_message "GPU properties configured"
}

validate_gpu_installation() {
    log_message "=== Validating GPU Installation ==="
    
    local errors=0
    
    # Check 64-bit drivers
    local drivers_64bit=(
        "/system/lib64/egl/libEGL_adreno.so"
        "/system/lib64/egl/libGLESv2_adreno.so"
        "/system/lib64/libllvm-glnext.so"
    )
    
    for driver in "${drivers_64bit[@]}"; do
        if [ -f "$driver" ]; then
            log_message "✓ Found: $driver"
        else
            log_message "✗ Missing: $driver"
            errors=$((errors + 1))
        fi
    done
    
    # Check 32-bit drivers
    local drivers_32bit=(
        "/system/lib/egl/libEGL_adreno.so"
        "/system/lib/egl/libGLESv2_adreno.so"
    )
    
    for driver in "${drivers_32bit[@]}"; do
        if [ -f "$driver" ]; then
            log_message "✓ Found: $driver"
        else
            log_message "✗ Missing: $driver"
            errors=$((errors + 1))
        fi
    done
    
    # Check GPU properties
    local egl_prop=$(getprop ro.hardware.egl)
    if [ "$egl_prop" = "adreno" ]; then
        log_message "✓ EGL property set correctly"
    else
        log_message "✗ EGL property incorrect: $egl_prop"
        errors=$((errors + 1))
    fi
    
    if [ $errors -eq 0 ]; then
        log_message "GPU validation passed"
        return 0
    else
        log_message "GPU validation failed with $errors errors"
        return 1
    fi
}

# Main execution
install_gpu_drivers
configure_gpu_properties
validate_gpu_installation