#!/system/bin/sh
# Night mode optimization script for Moto G71 5G

MODDIR=${0%/*}
LOGFILE="/data/local/tmp/motocam4_night_mode.log"

log_message() {
    echo "$(date): $1" >> $LOGFILE
    echo "$1"
}

configure_night_mode_properties() {
    log_message "=== Configuring Night Mode Properties ==="
    
    # Enable night mode for all cameras
    setprop persist.vendor.camera.night_mode.enabled "true"
    setprop persist.vendor.camera.night_mode.auto_detection "true"
    setprop persist.vendor.camera.night_mode.lux_threshold "10"
    
    # Main camera night mode settings
    setprop persist.vendor.camera.main.night_mode.max_exposure "4000000"
    setprop persist.vendor.camera.main.night_mode.max_iso "6400"
    setprop persist.vendor.camera.main.night_mode.frames "8"
    setprop persist.vendor.camera.main.night_mode.ois "enhanced"
    
    # Front camera night mode settings
    setprop persist.vendor.camera.front.night_mode.max_exposure "2000000"
    setprop persist.vendor.camera.front.night_mode.max_iso "3200"
    setprop persist.vendor.camera.front.night_mode.frames "6"
    setprop persist.vendor.camera.front.night_mode.face_enhancement "enabled"
    
    # Ultra wide night mode settings
    setprop persist.vendor.camera.ultrawide.night_mode.max_exposure "3000000"
    setprop persist.vendor.camera.ultrawide.night_mode.max_iso "3200"
    setprop persist.vendor.camera.ultrawide.night_mode.frames "6"
    setprop persist.vendor.camera.ultrawide.night_mode.distortion_correction "optimized"
    
    log_message "Night mode properties configured"
}

optimize_image_processing() {
    log_message "=== Optimizing Image Processing for Night Mode ==="
    
    # GPU acceleration settings
    setprop persist.vendor.camera.night_mode.gpu_acceleration "Adreno619"
    setprop persist.vendor.camera.night_mode.gpu_compute "enabled"
    setprop persist.vendor.camera.night_mode.parallel_processing "true"
    
    # DSP processing settings
    setprop persist.vendor.camera.night_mode.dsp_processing "Hexagon685"
    setprop persist.vendor.camera.night_mode.dsp_offload "aggressive"
    
    # Memory optimization
    setprop persist.vendor.camera.night_mode.memory_optimization "enabled"
    setprop persist.vendor.camera.night_mode.buffer_management "dynamic"
    
    # Noise reduction algorithms
    setprop persist.vendor.camera.night_mode.noise_reduction "bilateral_filter"
    setprop persist.vendor.camera.night_mode.chroma_denoising "enabled"
    setprop persist.vendor.camera.night_mode.detail_preservation "high"
    
    log_message "Image processing optimization completed"
}

configure_exposure_algorithms() {
    log_message "=== Configuring Exposure Algorithms ==="
    
    # Multi-frame exposure settings
    setprop persist.vendor.camera.night_mode.multi_frame "enabled"
    setprop persist.vendor.camera.night_mode.alignment_method "optical_flow"
    setprop persist.vendor.camera.night_mode.merging_algorithm "weighted_average"
    
    # Tone mapping settings
    setprop persist.vendor.camera.night_mode.tone_mapping "adaptive_histogram"
    setprop persist.vendor.camera.night_mode.local_contrast "enhanced"
    setprop persist.vendor.camera.night_mode.shadow_boost "moderate"
    setprop persist.vendor.camera.night_mode.highlight_recovery "enabled"
    
    # Color enhancement
    setprop persist.vendor.camera.night_mode.saturation "1.2"
    setprop persist.vendor.camera.night_mode.vibrance "1.1"
    setprop persist.vendor.camera.night_mode.warmth_adjustment "subtle"
    
    log_message "Exposure algorithms configured"
}

optimize_ois_for_night_mode() {
    log_message "=== Optimizing OIS for Night Mode ==="
    
    # Enhanced OIS settings for long exposures
    setprop persist.vendor.camera.ois.night_mode "enhanced"
    setprop persist.vendor.camera.ois.compensation_level "high"
    setprop persist.vendor.camera.ois.gyro_sensitivity "enhanced"
    setprop persist.vendor.camera.ois.stabilization_algorithm "advanced"
    
    # Motion detection for handheld stability
    setprop persist.vendor.camera.night_mode.motion_detection "enabled"
    setprop persist.vendor.camera.night_mode.stability_warning "enabled"
    setprop persist.vendor.camera.night_mode.tripod_detection "auto"
    
    log_message "OIS optimization for night mode completed"
}

configure_autofocus_night_mode() {
    log_message "=== Configuring AutoFocus for Night Mode ==="
    
    # Low light autofocus settings
    setprop persist.vendor.camera.af.night_mode "enabled"
    setprop persist.vendor.camera.af.low_light_assist "infrared"
    setprop persist.vendor.camera.af.focus_stacking "enabled"
    setprop persist.vendor.camera.af.pdaf_night_mode "enhanced"
    
    # Focus assist settings
    setprop persist.vendor.camera.af.assist_light "auto"
    setprop persist.vendor.camera.af.contrast_detection "enhanced"
    setprop persist.vendor.camera.af.search_range "extended"
    
    log_message "AutoFocus night mode configuration completed"
}

install_night_mode_config() {
    log_message "=== Installing Night Mode Configuration ==="
    
    # Create camera config directory
    mkdir -p /system/etc/camera
    
    # Install night mode configuration
    if [ -f "$MODDIR/system/etc/camera/night_mode_config_g71.xml" ]; then
        cp "$MODDIR/system/etc/camera/night_mode_config_g71.xml" "/system/etc/camera/"
        chmod 644 "/system/etc/camera/night_mode_config_g71.xml"
        chcon u:object_r:system_file:s0 "/system/etc/camera/night_mode_config_g71.xml"
        log_message "Night mode configuration installed"
    else
        log_message "ERROR: Night mode configuration file not found"
        return 1
    fi
    
    return 0
}

validate_night_mode_setup() {
    log_message "=== Validating Night Mode Setup ==="
    
    local errors=0
    
    # Check night mode properties
    local night_mode_enabled=$(getprop persist.vendor.camera.night_mode.enabled)
    if [ "$night_mode_enabled" = "true" ]; then
        log_message "✓ Night mode enabled"
    else
        log_message "✗ Night mode not enabled: $night_mode_enabled"
        errors=$((errors + 1))
    fi
    
    # Check configuration file
    if [ -f "/system/etc/camera/night_mode_config_g71.xml" ]; then
        log_message "✓ Night mode configuration file present"
    else
        log_message "✗ Night mode configuration file missing"
        errors=$((errors + 1))
    fi
    
    # Check GPU acceleration
    local gpu_accel=$(getprop persist.vendor.camera.night_mode.gpu_acceleration)
    if [ "$gpu_accel" = "Adreno619" ]; then
        log_message "✓ GPU acceleration configured for Adreno 619"
    else
        log_message "! GPU acceleration: $gpu_accel"
    fi
    
    # Check OIS enhancement
    local ois_night=$(getprop persist.vendor.camera.ois.night_mode)
    if [ "$ois_night" = "enhanced" ]; then
        log_message "✓ OIS enhanced for night mode"
    else
        log_message "! OIS night mode: $ois_night"
    fi
    
    if [ $errors -eq 0 ]; then
        log_message "Night mode validation passed"
        return 0
    else
        log_message "Night mode validation failed with $errors errors"
        return 1
    fi
}

# Main execution
log_message "=== Night Mode Optimization Started ==="

configure_night_mode_properties
optimize_image_processing
configure_exposure_algorithms
optimize_ois_for_night_mode
configure_autofocus_night_mode

if install_night_mode_config; then
    validate_night_mode_setup
    log_message "=== Night Mode Optimization Complete ==="
else
    log_message "=== Night Mode Optimization Failed ==="
    exit 1
fi