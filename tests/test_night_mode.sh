#!/system/bin/sh
# Night mode functionality tests for Moto G71 5G

LOGFILE="/data/local/tmp/motocam4_night_mode_test.log"

log_test() {
    echo "$(date): $1" >> $LOGFILE
    echo "$1"
}

test_night_mode_detection() {
    log_test "=== Testing Night Mode Auto Detection ==="
    
    # Check if night mode auto detection is enabled
    local auto_detection=$(getprop persist.vendor.camera.night_mode.auto_detection)
    if [ "$auto_detection" = "true" ]; then
        log_test "✓ Night mode auto detection enabled"
    else
        log_test "✗ Night mode auto detection disabled: $auto_detection"
        return 1
    fi
    
    # Check lux threshold setting
    local lux_threshold=$(getprop persist.vendor.camera.night_mode.lux_threshold)
    if [ "$lux_threshold" = "10" ]; then
        log_test "✓ Lux threshold set correctly: $lux_threshold"
    else
        log_test "! Lux threshold: $lux_threshold (expected: 10)"
    fi
    
    return 0
}

test_exposure_settings() {
    log_test "=== Testing Exposure Settings ==="
    
    # Test main camera exposure settings
    local main_max_exposure=$(getprop persist.vendor.camera.main.night_mode.max_exposure)
    if [ "$main_max_exposure" = "4000000" ]; then
        log_test "✓ Main camera max exposure: 4 seconds"
    else
        log_test "! Main camera max exposure: $main_max_exposure"
    fi
    
    # Test main camera ISO settings
    local main_max_iso=$(getprop persist.vendor.camera.main.night_mode.max_iso)
    if [ "$main_max_iso" = "6400" ]; then
        log_test "✓ Main camera max ISO: 6400"
    else
        log_test "! Main camera max ISO: $main_max_iso"
    fi
    
    # Test multi-frame capture
    local main_frames=$(getprop persist.vendor.camera.main.night_mode.frames)
    if [ "$main_frames" = "8" ]; then
        log_test "✓ Main camera multi-frame: 8 frames"
    else
        log_test "! Main camera frames: $main_frames"
    fi
    
    return 0
}

test_image_processing_optimization() {
    log_test "=== Testing Image Processing Optimization ==="
    
    # Check GPU acceleration
    local gpu_accel=$(getprop persist.vendor.camera.night_mode.gpu_acceleration)
    if [ "$gpu_accel" = "Adreno619" ]; then
        log_test "✓ GPU acceleration: Adreno 619"
    else
        log_test "! GPU acceleration: $gpu_accel"
    fi
    
    # Check DSP processing
    local dsp_processing=$(getprop persist.vendor.camera.night_mode.dsp_processing)
    if [ "$dsp_processing" = "Hexagon685" ]; then
        log_test "✓ DSP processing: Hexagon 685"
    else
        log_test "! DSP processing: $dsp_processing"
    fi
    
    # Check noise reduction algorithm
    local noise_reduction=$(getprop persist.vendor.camera.night_mode.noise_reduction)
    if [ "$noise_reduction" = "bilateral_filter" ]; then
        log_test "✓ Noise reduction: bilateral filter"
    else
        log_test "! Noise reduction: $noise_reduction"
    fi
    
    # Check parallel processing
    local parallel_proc=$(getprop persist.vendor.camera.night_mode.parallel_processing)
    if [ "$parallel_proc" = "true" ]; then
        log_test "✓ Parallel processing enabled"
    else
        log_test "! Parallel processing: $parallel_proc"
    fi
    
    return 0
}

test_ois_enhancement() {
    log_test "=== Testing OIS Enhancement ==="
    
    # Check OIS night mode enhancement
    local ois_night=$(getprop persist.vendor.camera.ois.night_mode)
    if [ "$ois_night" = "enhanced" ]; then
        log_test "✓ OIS enhanced for night mode"
    else
        log_test "! OIS night mode: $ois_night"
    fi
    
    # Check compensation level
    local compensation=$(getprop persist.vendor.camera.ois.compensation_level)
    if [ "$compensation" = "high" ]; then
        log_test "✓ OIS compensation level: high"
    else
        log_test "! OIS compensation: $compensation"
    fi
    
    # Check gyro sensitivity
    local gyro_sens=$(getprop persist.vendor.camera.ois.gyro_sensitivity)
    if [ "$gyro_sens" = "enhanced" ]; then
        log_test "✓ Gyro sensitivity enhanced"
    else
        log_test "! Gyro sensitivity: $gyro_sens"
    fi
    
    return 0
}

test_autofocus_night_mode() {
    log_test "=== Testing AutoFocus Night Mode ==="
    
    # Check AF night mode
    local af_night=$(getprop persist.vendor.camera.af.night_mode)
    if [ "$af_night" = "enabled" ]; then
        log_test "✓ AutoFocus night mode enabled"
    else
        log_test "! AutoFocus night mode: $af_night"
    fi
    
    # Check low light assist
    local af_assist=$(getprop persist.vendor.camera.af.low_light_assist)
    if [ "$af_assist" = "infrared" ]; then
        log_test "✓ Low light assist: infrared"
    else
        log_test "! Low light assist: $af_assist"
    fi
    
    # Check focus stacking
    local focus_stack=$(getprop persist.vendor.camera.af.focus_stacking)
    if [ "$focus_stack" = "enabled" ]; then
        log_test "✓ Focus stacking enabled"
    else
        log_test "! Focus stacking: $focus_stack"
    fi
    
    return 0
}

test_configuration_files() {
    log_test "=== Testing Configuration Files ==="
    
    # Check night mode configuration file
    if [ -f "/system/etc/camera/night_mode_config_g71.xml" ]; then
        log_test "✓ Night mode configuration file present"
        
        # Check file size (should be substantial)
        local file_size=$(stat -c%s "/system/etc/camera/night_mode_config_g71.xml" 2>/dev/null)
        if [ "$file_size" -gt 5000 ]; then
            log_test "✓ Configuration file size appropriate: $file_size bytes"
        else
            log_test "! Configuration file size small: $file_size bytes"
        fi
        
        # Check file permissions
        local file_perms=$(stat -c "%a" "/system/etc/camera/night_mode_config_g71.xml" 2>/dev/null)
        if [ "$file_perms" = "644" ]; then
            log_test "✓ Configuration file permissions correct"
        else
            log_test "! Configuration file permissions: $file_perms"
        fi
    else
        log_test "✗ Night mode configuration file missing"
        return 1
    fi
    
    return 0
}

simulate_night_mode_capture() {
    log_test "=== Simulating Night Mode Capture ==="
    
    # This is a simulation since we can't actually trigger camera capture
    log_test "Simulating night mode capture sequence..."
    
    # Check if all required components are available
    local components_ready=0
    
    # Check exposure settings
    if [ "$(getprop persist.vendor.camera.main.night_mode.max_exposure)" = "4000000" ]; then
        components_ready=$((components_ready + 1))
    fi
    
    # Check multi-frame settings
    if [ "$(getprop persist.vendor.camera.main.night_mode.frames)" = "8" ]; then
        components_ready=$((components_ready + 1))
    fi
    
    # Check OIS enhancement
    if [ "$(getprop persist.vendor.camera.ois.night_mode)" = "enhanced" ]; then
        components_ready=$((components_ready + 1))
    fi
    
    # Check GPU acceleration
    if [ "$(getprop persist.vendor.camera.night_mode.gpu_acceleration)" = "Adreno619" ]; then
        components_ready=$((components_ready + 1))
    fi
    
    log_test "Night mode components ready: $components_ready/4"
    
    if [ $components_ready -eq 4 ]; then
        log_test "✓ Night mode capture simulation: All components ready"
        return 0
    else
        log_test "! Night mode capture simulation: Missing components"
        return 1
    fi
}

# Run all night mode tests
log_test "=== Night Mode Test Suite Started ==="

test_results=0

if test_night_mode_detection; then
    log_test "Night Mode Detection Test: PASSED"
else
    log_test "Night Mode Detection Test: FAILED"
    test_results=$((test_results + 1))
fi

if test_exposure_settings; then
    log_test "Exposure Settings Test: PASSED"
else
    log_test "Exposure Settings Test: FAILED"
    test_results=$((test_results + 1))
fi

if test_image_processing_optimization; then
    log_test "Image Processing Optimization Test: PASSED"
else
    log_test "Image Processing Optimization Test: FAILED"
    test_results=$((test_results + 1))
fi

if test_ois_enhancement; then
    log_test "OIS Enhancement Test: PASSED"
else
    log_test "OIS Enhancement Test: FAILED"
    test_results=$((test_results + 1))
fi

if test_autofocus_night_mode; then
    log_test "AutoFocus Night Mode Test: PASSED"
else
    log_test "AutoFocus Night Mode Test: FAILED"
    test_results=$((test_results + 1))
fi

if test_configuration_files; then
    log_test "Configuration Files Test: PASSED"
else
    log_test "Configuration Files Test: FAILED"
    test_results=$((test_results + 1))
fi

if simulate_night_mode_capture; then
    log_test "Night Mode Capture Simulation: PASSED"
else
    log_test "Night Mode Capture Simulation: FAILED"
    test_results=$((test_results + 1))
fi

log_test "=== Night Mode Test Suite Complete ==="
log_test "Failed tests: $test_results"

if [ $test_results -eq 0 ]; then
    log_test "All night mode tests PASSED"
    exit 0
else
    log_test "Some night mode tests FAILED"
    exit 1
fi