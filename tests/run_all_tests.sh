#!/system/bin/sh
# Complete test suite for MotoCam4 G71 5G optimization

LOGFILE="/data/local/tmp/motocam4_test_suite.log"
TEST_DIR="$(dirname "$0")"

log_test() {
    echo "$(date): $1" >> $LOGFILE
    echo "$1"
}

run_test_script() {
    local test_script=$1
    local test_name=$2
    
    log_test "=== Running $test_name ==="
    
    if [ -f "$TEST_DIR/$test_script" ]; then
        chmod +x "$TEST_DIR/$test_script"
        if "$TEST_DIR/$test_script"; then
            log_test "✓ $test_name: PASSED"
            return 0
        else
            log_test "✗ $test_name: FAILED"
            return 1
        fi
    else
        log_test "✗ $test_name: Test script not found ($test_script)"
        return 1
    fi
}

# Initialize test suite
log_test "=== MotoCam4 G71 5G Test Suite Started ==="
log_test "Test Date: $(date)"
log_test "Device: $(getprop ro.product.system.model)"
log_test "Chipset: $(getprop ro.board.platform)"
log_test "Android: $(getprop ro.build.version.release)"

total_tests=0
passed_tests=0
failed_tests=0

# Run Camera HAL tests
if run_test_script "test_camera_hal.sh" "Camera HAL Integration"; then
    passed_tests=$((passed_tests + 1))
else
    failed_tests=$((failed_tests + 1))
fi
total_tests=$((total_tests + 1))

# Run GPU performance tests
if run_test_script "test_gpu_performance.sh" "GPU Performance"; then
    passed_tests=$((passed_tests + 1))
else
    failed_tests=$((failed_tests + 1))
fi
total_tests=$((total_tests + 1))

# Run Night Mode tests
if run_test_script "test_night_mode.sh" "Night Mode Functionality"; then
    passed_tests=$((passed_tests + 1))
else
    failed_tests=$((failed_tests + 1))
fi
total_tests=$((total_tests + 1))

# Run additional specific tests
log_test "=== Running Additional G71 5G Specific Tests ==="

# Test 5G properties
log_test "--- Testing 5G Properties ---"
if [ "$(getprop ro.vendor.radio.5g)" = "1" ]; then
    log_test "✓ 5G radio enabled"
    passed_tests=$((passed_tests + 1))
else
    log_test "✗ 5G radio not enabled"
    failed_tests=$((failed_tests + 1))
fi
total_tests=$((total_tests + 1))

# Test chipset properties
log_test "--- Testing Chipset Properties ---"
if [ "$(getprop ro.soc.model)" = "SM6375" ]; then
    log_test "✓ SM6375 chipset configured"
    passed_tests=$((passed_tests + 1))
else
    log_test "✗ SM6375 chipset not configured"
    failed_tests=$((failed_tests + 1))
fi
total_tests=$((total_tests + 1))

# Test camera configuration files
log_test "--- Testing Camera Configuration Files ---"
config_files=(
    "/system/etc/camera/camera_config_corfur.xml"
    "/system/etc/camera/sensor_calibration_corfur.xml"
    "/system/etc/camera/night_mode_config_g71.xml"
    "/system/etc/camera/ultrawide_distortion_g71.xml"
    "/system/etc/camera/macro_mode_config_g71.xml"
)

config_passed=0
for config_file in "${config_files[@]}"; do
    if [ -f "$config_file" ]; then
        log_test "✓ Found: $config_file"
        config_passed=$((config_passed + 1))
    else
        log_test "✗ Missing: $config_file"
    fi
done

if [ $config_passed -eq ${#config_files[@]} ]; then
    log_test "✓ All camera configuration files present"
    passed_tests=$((passed_tests + 1))
else
    log_test "✗ Missing camera configuration files ($config_passed/${#config_files[@]})"
    failed_tests=$((failed_tests + 1))
fi
total_tests=$((total_tests + 1))

# Test library files
log_test "--- Testing Library Files ---"
library_files=(
    "/system/lib64/hw/camera.sm6375.so"
    "/system/lib/hw/camera.sm6375.so"
    "/system/lib64/egl/libEGL_adreno.so"
    "/system/lib64/egl/libGLESv2_adreno.so"
    "/system/lib/egl/libEGL_adreno.so"
    "/system/lib/egl/libGLESv2_adreno.so"
)

library_passed=0
for lib_file in "${library_files[@]}"; do
    if [ -f "$lib_file" ]; then
        log_test "✓ Found: $lib_file"
        library_passed=$((library_passed + 1))
    else
        log_test "✗ Missing: $lib_file"
    fi
done

if [ $library_passed -eq ${#library_files[@]} ]; then
    log_test "✓ All library files present"
    passed_tests=$((passed_tests + 1))
else
    log_test "✗ Missing library files ($library_passed/${#library_files[@]})"
    failed_tests=$((failed_tests + 1))
fi
total_tests=$((total_tests + 1))

# Test permissions
log_test "--- Testing File Permissions ---"
permission_errors=0

for lib_file in "${library_files[@]}"; do
    if [ -f "$lib_file" ]; then
        perms=$(stat -c "%a" "$lib_file" 2>/dev/null)
        if [ "$perms" = "644" ]; then
            log_test "✓ Permissions OK: $lib_file ($perms)"
        else
            log_test "✗ Permission issue: $lib_file ($perms, expected 644)"
            permission_errors=$((permission_errors + 1))
        fi
    fi
done

if [ $permission_errors -eq 0 ]; then
    log_test "✓ All file permissions correct"
    passed_tests=$((passed_tests + 1))
else
    log_test "✗ File permission errors: $permission_errors"
    failed_tests=$((failed_tests + 1))
fi
total_tests=$((total_tests + 1))

# Test system stability
log_test "--- Testing System Stability ---"
stability_score=0

# Check if camera server is running
if pgrep -f "cameraserver" > /dev/null; then
    log_test "✓ Camera server running"
    stability_score=$((stability_score + 1))
else
    log_test "! Camera server not running"
fi

# Check memory usage
memory_usage=$(free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}')
log_test "Memory usage: ${memory_usage}%"
if [ "${memory_usage%.*}" -lt "85" ]; then
    log_test "✓ Memory usage acceptable"
    stability_score=$((stability_score + 1))
else
    log_test "! High memory usage detected"
fi

# Check storage space
available_space=$(df /data | tail -1 | awk '{print $4}')
if [ "$available_space" -gt "102400" ]; then  # 100MB
    log_test "✓ Sufficient storage space"
    stability_score=$((stability_score + 1))
else
    log_test "! Low storage space: ${available_space}KB"
fi

if [ $stability_score -eq 3 ]; then
    log_test "✓ System stability good"
    passed_tests=$((passed_tests + 1))
else
    log_test "! System stability issues detected ($stability_score/3)"
    failed_tests=$((failed_tests + 1))
fi
total_tests=$((total_tests + 1))

# Performance benchmark
log_test "--- Performance Benchmark ---"
benchmark_start=$(date +%s%N)

# Simulate camera initialization
for i in $(seq 1 10); do
    getprop persist.vendor.camera.main.sensor > /dev/null
    getprop ro.hardware.egl > /dev/null
    [ -f "/system/lib64/hw/camera.sm6375.so" ] && echo > /dev/null
done

benchmark_end=$(date +%s%N)
benchmark_time=$(( (benchmark_end - benchmark_start) / 1000000 ))  # Convert to milliseconds

log_test "Benchmark time: ${benchmark_time}ms"
if [ $benchmark_time -lt 1000 ]; then  # Less than 1 second
    log_test "✓ Performance benchmark passed"
    passed_tests=$((passed_tests + 1))
else
    log_test "! Performance benchmark slow"
    failed_tests=$((failed_tests + 1))
fi
total_tests=$((total_tests + 1))

# Generate test report
log_test "=== Test Suite Summary ==="
log_test "Total Tests: $total_tests"
log_test "Passed: $passed_tests"
log_test "Failed: $failed_tests"
log_test "Success Rate: $(( passed_tests * 100 / total_tests ))%"

if [ $failed_tests -eq 0 ]; then
    log_test "🎉 ALL TESTS PASSED - MotoCam4 G71 5G optimization successful!"
    exit 0
elif [ $passed_tests -gt $failed_tests ]; then
    log_test "⚠️  MOSTLY SUCCESSFUL - Some issues detected but module should work"
    exit 1
else
    log_test "❌ MULTIPLE FAILURES - Module may not work correctly"
    exit 2
fi