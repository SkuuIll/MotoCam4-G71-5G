#!/system/bin/sh

# Script de instalación manual para MotoCam4 G71 5G
# Corrige el problema de estructura de directorios

echo "🚀 Iniciando instalación manual de MotoCam4..."

# Directorio base del módulo
MODULE_DIR="/data/adb/modules/MotoCam4G715G"
TEMP_DIR="/data/local/tmp/motocam_install"

# Crear estructura de directorios
echo "📁 Creando estructura de directorios..."
mkdir -p "$MODULE_DIR/system/product/priv-app/MotCamera4/oat/arm64"
mkdir -p "$MODULE_DIR/system/product/app/MotCamera3AI/oat/arm64"
mkdir -p "$MODULE_DIR/system/product/app/MotoPhotoEditor/oat/arm64"
mkdir -p "$MODULE_DIR/system/product/etc/permissions"
mkdir -p "$MODULE_DIR/system/product/etc/sysconfig"
mkdir -p "$MODULE_DIR/system/system_ext/priv-app/ImagerTuning-V2/oat/arm64"
mkdir -p "$MODULE_DIR/system/system_ext/etc/permissions"
mkdir -p "$MODULE_DIR/system/system_ext/framework"
mkdir -p "$MODULE_DIR/system/system_ext/lib64"
mkdir -p "$MODULE_DIR/system/system_ext/lib"
mkdir -p "$MODULE_DIR/system/app/MotoSignatureApp"
mkdir -p "$MODULE_DIR/system/etc/permissions"
mkdir -p "$MODULE_DIR/system/framework"

# Copiar archivos principales
echo "📱 Copiando APKs principales..."

# MotCamera4 (APK principal)
cp "$TEMP_DIR/system\\product\\priv-app\\MotCamera4\\MotCamera4.apk" "$MODULE_DIR/system/product/priv-app/MotCamera4/MotCamera4.apk"
cp "$TEMP_DIR/system\\product\\priv-app\\MotCamera4\\oat\\arm64\\MotCamera4.odex" "$MODULE_DIR/system/product/priv-app/MotCamera4/oat/arm64/MotCamera4.odex"
cp "$TEMP_DIR/system\\product\\priv-app\\MotCamera4\\oat\\arm64\\MotCamera4.vdex" "$MODULE_DIR/system/product/priv-app/MotCamera4/oat/arm64/MotCamera4.vdex"

# MotCamera3AI
cp "$TEMP_DIR/system\\product\\app\\MotCamera3AI\\MotCamera3AI.apk" "$MODULE_DIR/system/product/app/MotCamera3AI/MotCamera3AI.apk"
cp "$TEMP_DIR/system\\product\\app\\MotCamera3AI\\oat\\arm64\\MotCamera3AI.odex" "$MODULE_DIR/system/product/app/MotCamera3AI/oat/arm64/MotCamera3AI.odex"
cp "$TEMP_DIR/system\\product\\app\\MotCamera3AI\\oat\\arm64\\MotCamera3AI.vdex" "$MODULE_DIR/system/product/app/MotCamera3AI/oat/arm64/MotCamera3AI.vdex"

# MotoPhotoEditor
cp "$TEMP_DIR/system\\product\\app\\MotoPhotoEditor\\MotoPhotoEditor.apk" "$MODULE_DIR/system/product/app/MotoPhotoEditor/MotoPhotoEditor.apk"
cp "$TEMP_DIR/system\\product\\app\\MotoPhotoEditor\\oat\\arm64\\MotoPhotoEditor.odex" "$MODULE_DIR/system/product/app/MotoPhotoEditor/oat/arm64/MotoPhotoEditor.odex"
cp "$TEMP_DIR/system\\product\\app\\MotoPhotoEditor\\oat\\arm64\\MotoPhotoEditor.vdex" "$MODULE_DIR/system/product/app/MotoPhotoEditor/oat/arm64/MotoPhotoEditor.vdex"

# ImagerTuning-V2
cp "$TEMP_DIR/system\\system_ext\\priv-app\\ImagerTuning-V2\\ImagerTuning-V2.apk" "$MODULE_DIR/system/system_ext/priv-app/ImagerTuning-V2/ImagerTuning-V2.apk"
cp "$TEMP_DIR/system\\system_ext\\priv-app\\ImagerTuning-V2\\oat\\arm64\\ImagerTuning-V2.odex" "$MODULE_DIR/system/system_ext/priv-app/ImagerTuning-V2/oat/arm64/ImagerTuning-V2.odex"
cp "$TEMP_DIR/system\\system_ext\\priv-app\\ImagerTuning-V2\\oat\\arm64\\ImagerTuning-V2.vdex" "$MODULE_DIR/system/system_ext/priv-app/ImagerTuning-V2/oat/arm64/ImagerTuning-V2.vdex"

# MotoSignatureApp
cp "$TEMP_DIR/system\\app\\MotoSignatureApp\\MotoSignatureApp.apk" "$MODULE_DIR/system/app/MotoSignatureApp/MotoSignatureApp.apk"

echo "📋 Copiando permisos y configuraciones..."

# Permisos de product
cp "$TEMP_DIR/system\\product\\etc\\permissions\\com.motorola.camera3.xml" "$MODULE_DIR/system/product/etc/permissions/com.motorola.camera3.xml"
cp "$TEMP_DIR/system\\product\\etc\\permissions\\com.motorola.camera3.content.ai.xml" "$MODULE_DIR/system/product/etc/permissions/com.motorola.camera3.content.ai.xml"
cp "$TEMP_DIR/system\\product\\etc\\permissions\\com.motorola.camera3.hanoip.xml" "$MODULE_DIR/system/product/etc/permissions/com.motorola.camera3.hanoip.xml"
cp "$TEMP_DIR/system\\product\\etc\\permissions\\com.motorola.camera3.lens.xml" "$MODULE_DIR/system/product/etc/permissions/com.motorola.camera3.lens.xml"
cp "$TEMP_DIR/system\\product\\etc\\permissions\\com.motorola.photoeditor.xml" "$MODULE_DIR/system/product/etc/permissions/com.motorola.photoeditor.xml"
cp "$TEMP_DIR/system\\product\\etc\\permissions\\privapp-permissions-com.motorola.camera3.xml" "$MODULE_DIR/system/product/etc/permissions/privapp-permissions-com.motorola.camera3.xml"

# Configuraciones del sistema
cp "$TEMP_DIR/system\\product\\etc\\sysconfig\\hiddenapi-whitelist-com.motorola.camera3.xml" "$MODULE_DIR/system/product/etc/sysconfig/hiddenapi-whitelist-com.motorola.camera3.xml"

# Frameworks y librerías
cp "$TEMP_DIR/system\\system_ext\\framework\\com.motorola.androidx.camera.extensions.jar" "$MODULE_DIR/system/system_ext/framework/com.motorola.androidx.camera.extensions.jar"
cp "$TEMP_DIR/system\\system_ext\\framework\\com.motorola.imager.V2.jar" "$MODULE_DIR/system/system_ext/framework/com.motorola.imager.V2.jar"
cp "$TEMP_DIR/system\\system_ext\\framework\\com.motorola.libimgTuner.jar" "$MODULE_DIR/system/system_ext/framework/com.motorola.libimgTuner.jar"

# Librerías nativas
cp "$TEMP_DIR/system\\system_ext\\lib64\\libimgTuner_jni.motoimagetuner.so" "$MODULE_DIR/system/system_ext/lib64/libimgTuner_jni.motoimagetuner.so"
cp "$TEMP_DIR/system\\system_ext\\lib64\\libmcf_native_window_helper.motocamera.so" "$MODULE_DIR/system/system_ext/lib64/libmcf_native_window_helper.motocamera.so"
cp "$TEMP_DIR/system\\system_ext\\lib\\libimgTuner_jni.motoimagetuner.so" "$MODULE_DIR/system/system_ext/lib/libimgTuner_jni.motoimagetuner.so"
cp "$TEMP_DIR/system\\system_ext\\lib\\libmcf_native_window_helper.motocamera.so" "$MODULE_DIR/system/system_ext/lib/libmcf_native_window_helper.motocamera.so"

# Permisos system_ext
cp "$TEMP_DIR/system\\system_ext\\etc\\permissions\\com.motorola.imager.V2.xml" "$MODULE_DIR/system/system_ext/etc/permissions/com.motorola.imager.V2.xml"
cp "$TEMP_DIR/system\\system_ext\\etc\\permissions\\com.motorola.imager.access_V2.xml" "$MODULE_DIR/system/system_ext/etc/permissions/com.motorola.imager.access_V2.xml"
cp "$TEMP_DIR/system\\system_ext\\etc\\permissions\\privapp-permissions-com.motorola.imagertuning_V2.xml" "$MODULE_DIR/system/system_ext/etc/permissions/privapp-permissions-com.motorola.imagertuning_V2.xml"

# Framework del sistema
cp "$TEMP_DIR/system\\framework\\com.motorola.motosignature.jar" "$MODULE_DIR/system/framework/com.motorola.motosignature.jar"

# Permisos del sistema
cp "$TEMP_DIR/system\\etc\\permissions\\com.motorola.frameworks.core.addon.xml" "$MODULE_DIR/system/etc/permissions/com.motorola.frameworks.core.addon.xml"
cp "$TEMP_DIR/system\\etc\\permissions\\com.motorola.motosignature.xml" "$MODULE_DIR/system/etc/permissions/com.motorola.motosignature.xml"

# Copiar archivos de configuración del módulo
echo "⚙️ Copiando configuración del módulo..."
cp "$TEMP_DIR/common/service.sh" "$MODULE_DIR/service.sh" 2>/dev/null || true
cp "$TEMP_DIR/common/post-fs-data.sh" "$MODULE_DIR/post-fs-data.sh" 2>/dev/null || true
cp "$TEMP_DIR/common/system.prop" "$MODULE_DIR/system.prop" 2>/dev/null || true

# Establecer permisos correctos
echo "🔐 Estableciendo permisos..."
chmod -R 755 "$MODULE_DIR"
chown -R root:root "$MODULE_DIR"

# Permisos específicos para APKs
chmod 644 "$MODULE_DIR/system/product/priv-app/MotCamera4/MotCamera4.apk"
chmod 644 "$MODULE_DIR/system/product/app/MotCamera3AI/MotCamera3AI.apk"
chmod 644 "$MODULE_DIR/system/product/app/MotoPhotoEditor/MotoPhotoEditor.apk"
chmod 644 "$MODULE_DIR/system/system_ext/priv-app/ImagerTuning-V2/ImagerTuning-V2.apk"
chmod 644 "$MODULE_DIR/system/app/MotoSignatureApp/MotoSignatureApp.apk"

# Permisos para librerías
chmod 644 "$MODULE_DIR"/system/system_ext/lib*/*.so

echo "✅ Instalación manual completada!"
echo "📱 Módulo instalado en: $MODULE_DIR"
echo "🔄 Reinicia el dispositivo para aplicar los cambios"