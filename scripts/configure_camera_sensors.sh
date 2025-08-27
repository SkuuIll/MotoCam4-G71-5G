#!/system/bin/sh
# Camera sensor configuration script for Moto G71 5G

MODDIR=${0%/*}
LOGFILE="/data/local/tmp/motocam4_sensor_config.log"

log_message() {
    echo "$(date): $1" >> $LOGFILE
    echo "$1"
}

configure_main_sensor() {
    log_message "=== Configuring Main Sensor (Samsung JN1 50MP) ==="
    
    # Set sensor-specific properties
    setprop persist.vendor.camera.main.sensor "samsung_jn1"
    setprop persist.vendor.camera.main.resolution "50MP"
    setprop persist.vendor.camera.main.ois "true"
    setprop persist.vendor.camera.main.pdaf "true"
    
    # Configure image processing
    setprop persist.vendor.camera.main.hdr "auto"
    setprop persist.vendor.camera.main.night_mode "available"
    setprop persist.vendor.camera.main.burst_mode "enabled"
    
    # Video capabilities
    setprop persist.vendor.camera.main.video.4k "true"
    setprop persist.vendor.camera.main.video.stabilization "true"
    setprop persist.vendor.camera.main.video.slowmo "120fps"
    
    log_message "Main sensor configured"
}

configure_front_sensor() {
    log_message "=== Configuring Front Sensor (Samsung S5K3P9 16MP) ==="
    
    # Set sensor-specific properties
    setprop persist.vendor.camera.front.sensor "samsung_s5k3p9"
    setprop persist.vendor.camera.front.resolution "16MP"
    setprop persist.vendor.camera.front.beauty_mode "available"
    setprop persist.vendor.camera.front.portrait_mode "available"
    
    # Configure features
    setprop persist.vendor.camera.front.face_detection "enabled"
    setprop persist.vendor.camera.front.hdr "auto"
    
    log_message "Front sensor configured"
}

configure_ultrawide_sensor() {
    log_message "=== Configuring Ultra Wide Sensor (OmniVision OV8856 8MP) ==="
    
    # Set sensor-specific properties
    setprop persist.vendor.camera.ultrawide.sensor "omnivision_ov8856"
    setprop persist.vendor.camera.ultrawide.resolution "8MP"
    setprop persist.vendor.camera.ultrawide.fov "118"
    setprop persist.vendor.camera.ultrawide.distortion_correction "enabled"
    
    # Configure processing
    setprop persist.vendor.camera.ultrawide.edge_enhancement "moderate"
    setprop persist.vendor.camera.ultrawide.vignetting_correction "enabled"
    
    log_message "Ultra wide sensor configured"
}

configure_macro_sensor() {
    log_message "=== Configuring Macro Sensor (OmniVision OV02B10 2MP) ==="
    
    # Set sensor-specific properties
    setprop persist.vendor.camera.macro.sensor "omnivision_ov02b10"
    setprop persist.vendor.camera.macro.resolution "2MP"
    setprop persist.vendor.camera.macro.min_focus "4cm"
    setprop persist.vendor.camera.macro.depth_detection "enabled"
    
    # Configure autofocus
    setprop persist.vendor.camera.macro.af_type "VCM"
    setprop persist.vendor.camera.macro.af_precision "high"
    
    log_message "Macro sensor configured"
}

configure_global_camera_settings() {
    log_message "=== Configuring Global Camera Settings ==="
    
    # Chipset optimization
    setprop persist.vendor.camera.chipset "SM6375"
    setprop persist.vendor.camera.isp "Spectra340"
    setprop persist.vendor.camera.gpu_acceleration "Adreno619"
    
    # Multi-camera settings
    setprop persist.vendor.camera.concurrent_cameras "2"
    setprop persist.vendor.camera.seamless_zoom "enabled"
    
    # Performance settings
    setprop persist.vendor.camera.performance_mode "optimized"
    setprop persist.vendor.camera.thermal_throttling "adaptive"
    
    # 5G specific settings
    setprop persist.vendor.camera.5g.streaming "enabled"
    setprop persist.vendor.camera.5g.cloud_processing "available"
    
    log_message "Global camera settings configured"
}

install_camera_configs() {
    log_message "=== Installing Camera Configuration Files ==="
    
    # Create camera config directories
    mkdir -p /system/etc/camera
    mkdir -p /system/product/etc/permissions
    
    # Copy configuration files
    if [ -f "$MODDIR/system/etc/camera/camera_config_corfur.xml" ]; then
        cp "$MODDIR/system/etc/camera/camera_config_corfur.xml" "/system/etc/camera/"
        chmod 644 "/system/etc/camera/camera_config_corfur.xml"
        chcon u:object_r:system_file:s0 "/system/etc/camera/camera_config_corfur.xml"
        log_message "Camera configuration installed"
    fi
    
    if [ -f "$MODDIR/system/etc/camera/sensor_calibration_corfur.xml" ]; then
        cp "$MODDIR/system/etc/camera/sensor_calibration_corfur.xml" "/system/etc/camera/"
        chmod 644 "/system/etc/camera/sensor_calibration_corfur.xml"
        chcon u:object_r:system_file:s0 "/system/etc/camera/sensor_calibration_corfur.xml"
        log_message "Sensor calibration installed"
    fi
    
    if [ -f "$MODDIR/system/product/etc/permissions/camera_features_corfur.xml" ]; then
        cp "$MODDIR/system/product/etc/permissions/camera_features_corfur.xml" "/system/product/etc/permissions/"
        chmod 644 "/system/product/etc/permissions/camera_features_corfur.xml"
        chcon u:object_r:system_file:s0 "/system/product/etc/permissions/camera_features_corfur.xml"
        log_message "Camera features permissions installed"
    fi
}

validate_sensor_configuration() {
    log_message "=== Validating Sensor Configuration ==="
    
    local errors=0
    
    # Check main sensor properties
    local main_sensor=$(getprop persist.vendor.camera.main.sensor)
    if [ "$main_sensor" = "samsung_jn1" ]; then
        log_message "✓ Main sensor configured correctly"
    else
        log_message "✗ Main sensor configuration error: $main_sensor"
        errors=$((errors + 1))
    fi
    
    # Check configuration files
    if [ -f "/system/etc/camera/camera_config_corfur.xml" ]; then
        log_message "✓ Camera configuration file present"
    else
        log_message "✗ Camera configuration file missing"
        errors=$((errors + 1))
    fi
    
    if [ -f "/system/etc/camera/sensor_calibration_corfur.xml" ]; then
        log_message "✓ Sensor calibration file present"
    else
        log_message "✗ Sensor calibration file missing"
        errors=$((errors + 1))
    fi
    
    if [ -f "/system/product/etc/permissions/camera_features_corfur.xml" ]; then
        log_message "✓ Camera features file present"
    else
        log_message "✗ Camera features file missing"
        errors=$((errors + 1))
    fi
    
    if [ $errors -eq 0 ]; then
        log_message "Sensor configuration validation passed"
        return 0
    else
        log_message "Sensor configuration validation failed with $errors errors"
        return 1
    fi
}

# Main execution
log_message "=== Camera Sensor Configuration Started ==="

configure_main_sensor
configure_front_sensor
configure_ultrawide_sensor
configure_macro_sensor
configure_global_camera_settings
install_camera_configs
validate_sensor_configuration

log_message "=== Camera Sensor Configuration Complete ==="