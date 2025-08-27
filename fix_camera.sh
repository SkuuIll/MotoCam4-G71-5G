#!/system/bin/sh

# Script simple para reparar la cámara MotoCam4
# Uso: su -c 'sh fix_camera.sh'

echo "🔧 Reparando MotoCam4..."

# Verificar root
if [ "$(id -u)" != "0" ]; then
    echo "❌ Requiere permisos de root"
    echo "Usar: su -c 'sh fix_camera.sh'"
    exit 1
fi

MODULE_PATH="/data/adb/modules/MotoCam4G715G"

# Habilitar módulo
if [ -f "$MODULE_PATH/disable" ]; then
    rm -f "$MODULE_PATH/disable"
    echo "✅ Módulo habilitado"
fi

# Corregir permisos
find "$MODULE_PATH/system" -name "*.apk" -exec chmod 644 {} \; 2>/dev/null
find "$MODULE_PATH/system" -name "*.so" -exec chmod 644 {} \; 2>/dev/null
echo "✅ Permisos corregidos"

# Reinstalar app principal
APK="$MODULE_PATH/system/product/priv-app/MotCamera4/MotCamera4.apk"
if [ -f "$APK" ]; then
    pm install -r -g "$APK" 2>/dev/null
    echo "✅ App reinstalada"
fi

# Reiniciar servicios
killall system_server 2>/dev/null
echo "✅ Servicios reiniciados"

echo "🎉 Reparación completada. Reinicia el dispositivo."