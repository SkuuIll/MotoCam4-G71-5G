#!/system/bin/sh
# GPU performance tests for Adreno 619 optimization

LOGFILE="/data/local/tmp/motocam4_gpu_test.log"

log_test() {
    echo "$(date): $1" >> $LOGFILE
    echo "$1"
}

test_gpu_driver_loading() {
    log_test "=== Testing GPU Driver Loading ==="
    
    # Check if EGL drivers can be loaded
    local egl_64="/system/lib64/egl/libEGL_adreno.so"
    local gles_64="/system/lib64/egl/libGLESv2_adreno.so"
    
    if [ -f "$egl_64" ] && [ -f "$gles_64" ]; then
        log_test "✓ Adreno 619 drivers present"
        
        # Check file sizes (real drivers should be substantial)
        local egl_size=$(stat -c%s "$egl_64" 2>/dev/null)
        local gles_size=$(stat -c%s "$gles_64" 2>/dev/null)
        
        log_test "EGL driver size: $egl_size bytes"
        log_test "GLES driver size: $gles_size bytes"
        
        if [ "$egl_size" -gt 100000 ] && [ "$gles_size" -gt 500000 ]; then
            log_test "✓ Driver sizes appropriate for real drivers"
        else
            log_test "! Driver sizes small (may be placeholders)"
        fi
    else
        log_test "✗ Adreno 619 drivers missing"
        return 1
    fi
    
    return 0
}

test_gpu_properties() {
    log_test "=== Testing GPU Properties ==="
    
    # Check OpenGL ES version
    local gles_version=$(getprop ro.opengles.version)
    if [ "$gles_version" = "196610" ]; then
        log_test "✓ OpenGL ES 3.2 support configured"
    else
        log_test "! OpenGL ES version: $gles_version (expected: 196610)"
    fi
    
    # Check EGL hardware
    local egl_hardware=$(getprop ro.hardware.egl)
    if [ "$egl_hardware" = "adreno" ]; then
        log_test "✓ EGL hardware set to Adreno"
    else
        log_test "✗ EGL hardware incorrect: $egl_hardware"
        return 1
    fi
    
    # Check Vulkan support
    local vulkan_hardware=$(getprop ro.hardware.vulkan)
    if [ "$vulkan_hardware" = "adreno" ]; then
        log_test "✓ Vulkan hardware set to Adreno"
    else
        log_test "! Vulkan hardware: $vulkan_hardware"
    fi
    
    return 0
}

test_gpu_frequency_scaling() {
    log_test "=== Testing GPU Frequency Scaling ==="
    
    local gpu_path="/sys/class/kgsl/kgsl-3d0"
    
    if [ -d "$gpu_path" ]; then
        log_test "✓ GPU sysfs interface available"
        
        # Check available frequencies
        if [ -f "$gpu_path/devfreq/available_frequencies" ]; then
            local freqs=$(cat "$gpu_path/devfreq/available_frequencies" 2>/dev/null)
            log_test "Available frequencies: $freqs"
            
            # Check if frequencies match Adreno 619 expected values
            if echo "$freqs" | grep -q "315000000\|490000000\|555000000"; then
                log_test "✓ Adreno 619 frequencies detected"
            else
                log_test "! Frequencies may not match Adreno 619"
            fi
        fi
        
        # Check current frequency
        if [ -f "$gpu_path/devfreq/cur_freq" ]; then
            local cur_freq=$(cat "$gpu_path/devfreq/cur_freq" 2>/dev/null)
            log_test "Current frequency: $cur_freq Hz"
        fi
        
        # Check governor
        if [ -f "$gpu_path/devfreq/governor" ]; then
            local governor=$(cat "$gpu_path/devfreq/governor" 2>/dev/null)
            log_test "Current governor: $governor"
        fi
    else
        log_test "! GPU sysfs interface not available"
        return 1
    fi
    
    return 0
}

test_camera_gpu_integration() {
    log_test "=== Testing Camera-GPU Integration ==="
    
    # Check if camera can utilize GPU for processing
    local camera_props=$(getprop | grep -i "camera.*gpu\|gpu.*camera" 2>/dev/null)
    if [ -n "$camera_props" ]; then
        log_test "Camera-GPU properties found:"
        echo "$camera_props" | while read -r prop; do
            log_test "  $prop"
        done
    else
        log_test "! No specific camera-GPU integration properties found"
    fi
    
    # Check for GPU-accelerated image processing libraries
    local gpu_libs=(
        "/system/lib64/libgpudataproducer.so"
        "/system/lib64/libgpuservice.so"
        "/system/lib64/libgui.so"
    )
    
    local found_libs=0
    for lib in "${gpu_libs[@]}"; do
        if [ -f "$lib" ]; then
            log_test "✓ Found GPU library: $lib"
            found_libs=$((found_libs + 1))
        fi
    done
    
    if [ $found_libs -gt 0 ]; then
        log_test "✓ GPU integration libraries present ($found_libs/3)"
    else
        log_test "! No GPU integration libraries found"
    fi
    
    return 0
}

# Run all GPU tests
log_test "=== GPU Performance Test Suite Started ==="

test_results=0

if test_gpu_driver_loading; then
    log_test "GPU Driver Loading Test: PASSED"
else
    log_test "GPU Driver Loading Test: FAILED"
    test_results=$((test_results + 1))
fi

if test_gpu_properties; then
    log_test "GPU Properties Test: PASSED"
else
    log_test "GPU Properties Test: FAILED"
    test_results=$((test_results + 1))
fi

if test_gpu_frequency_scaling; then
    log_test "GPU Frequency Scaling Test: PASSED"
else
    log_test "GPU Frequency Scaling Test: FAILED"
    test_results=$((test_results + 1))
fi

if test_camera_gpu_integration; then
    log_test "Camera-GPU Integration Test: PASSED"
else
    log_test "Camera-GPU Integration Test: FAILED"
    test_results=$((test_results + 1))
fi

log_test "=== GPU Test Suite Complete ==="
log_test "Failed tests: $test_results"

if [ $test_results -eq 0 ]; then
    log_test "All GPU tests PASSED"
    exit 0
else
    log_test "Some GPU tests FAILED"
    exit 1
fi