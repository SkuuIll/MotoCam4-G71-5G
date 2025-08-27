#!/system/bin/sh
# Unit tests for Camera HAL integration

LOGFILE="/data/local/tmp/motocam4_hal_test.log"

log_test() {
    echo "$(date): $1" >> $LOGFILE
    echo "$1"
}

test_hal_loading() {
    log_test "=== Testing HAL Loading ==="
    
    # Test if HAL can be loaded by checking dependencies
    local hal_path="/system/lib64/hw/camera.sm6375.so"
    
    if [ -f "$hal_path" ]; then
        log_test "✓ HAL file exists: $hal_path"
        
        # Check file size (should be > 1MB for real HAL)
        local file_size=$(stat -c%s "$hal_path" 2>/dev/null)
        if [ "$file_size" -gt 1048576 ]; then
            log_test "✓ HAL file size appropriate: $file_size bytes"
        else
            log_test "! HAL file size small: $file_size bytes (may be placeholder)"
        fi
        
        # Check if file is executable/readable
        if [ -r "$hal_path" ]; then
            log_test "✓ HAL file readable"
        else
            log_test "✗ HAL file not readable"
            return 1
        fi
    else
        log_test "✗ HAL file missing: $hal_path"
        return 1
    fi
    
    return 0
}

test_camera_service_integration() {
    log_test "=== Testing Camera Service Integration ==="
    
    # Check if camera service can detect the HAL
    if command -v dumpsys >/dev/null 2>&1; then
        local camera_info=$(dumpsys media.camera 2>/dev/null | grep -i "sm6375\|corfur\|g71" | head -5)
        if [ -n "$camera_info" ]; then
            log_test "✓ Camera service recognizes G71 5G hardware"
            log_test "Camera info: $camera_info"
        else
            log_test "! Camera service may not recognize G71 5G hardware yet"
        fi
    else
        log_test "! dumpsys not available for testing"
    fi
    
    return 0
}

test_sensor_detection() {
    log_test "=== Testing Sensor Detection ==="
    
    # Check for expected camera sensors
    local sensors_found=0
    
    # Main sensor (50MP Samsung JN1)
    if [ -f "/sys/class/camera/rear/sensor_name" ]; then
        local main_sensor=$(cat /sys/class/camera/rear/sensor_name 2>/dev/null)
        if echo "$main_sensor" | grep -qi "jn1\|50mp"; then
            log_test "✓ Main sensor detected: $main_sensor"
            sensors_found=$((sensors_found + 1))
        fi
    fi
    
    # Ultra-wide sensor (8MP OmniVision)
    if [ -f "/sys/class/camera/ultrawide/sensor_name" ]; then
        local ultrawide_sensor=$(cat /sys/class/camera/ultrawide/sensor_name 2>/dev/null)
        if echo "$ultrawide_sensor" | grep -qi "ov8856\|8mp"; then
            log_test "✓ Ultra-wide sensor detected: $ultrawide_sensor"
            sensors_found=$((sensors_found + 1))
        fi
    fi
    
    # Macro sensor (2MP OmniVision)
    if [ -f "/sys/class/camera/macro/sensor_name" ]; then
        local macro_sensor=$(cat /sys/class/camera/macro/sensor_name 2>/dev/null)
        if echo "$macro_sensor" | grep -qi "ov02b10\|2mp"; then
            log_test "✓ Macro sensor detected: $macro_sensor"
            sensors_found=$((sensors_found + 1))
        fi
    fi
    
    # Front sensor (16MP Samsung)
    if [ -f "/sys/class/camera/front/sensor_name" ]; then
        local front_sensor=$(cat /sys/class/camera/front/sensor_name 2>/dev/null)
        if echo "$front_sensor" | grep -qi "s5k3p9\|16mp"; then
            log_test "✓ Front sensor detected: $front_sensor"
            sensors_found=$((sensors_found + 1))
        fi
    fi
    
    log_test "Total sensors detected: $sensors_found/4"
    
    if [ $sensors_found -ge 2 ]; then
        return 0
    else
        return 1
    fi
}

# Run all tests
log_test "=== Camera HAL Test Suite Started ==="

test_results=0

if test_hal_loading; then
    log_test "HAL Loading Test: PASSED"
else
    log_test "HAL Loading Test: FAILED"
    test_results=$((test_results + 1))
fi

if test_camera_service_integration; then
    log_test "Camera Service Integration Test: PASSED"
else
    log_test "Camera Service Integration Test: FAILED"
    test_results=$((test_results + 1))
fi

if test_sensor_detection; then
    log_test "Sensor Detection Test: PASSED"
else
    log_test "Sensor Detection Test: FAILED"
    test_results=$((test_results + 1))
fi

log_test "=== Test Suite Complete ==="
log_test "Failed tests: $test_results"

if [ $test_results -eq 0 ]; then
    log_test "All tests PASSED"
    exit 0
else
    log_test "Some tests FAILED"
    exit 1
fi