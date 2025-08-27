# 📱 MotoCam4 G71 5G - Cámara Motorola Original

Módulo Magisk que instala la cámara Motorola original (9.0.33.40) en el Moto G71 5G con todas sus funcionalidades completas.

## 🎯 **Características**

- ✅ **Cámara Motorola Original** (9.0.33.40) completa y funcional
- ✅ **4 Sensores Activos:** Principal 50MP + Frontal 16MP + Ultra Gran Angular 8MP + Macro 2MP
- ✅ **Modos Avanzados:** Nocturno, Retrato, Macro, Ultra Gran Angular, Video 1080p@60fps
- ✅ **IA Integrada:** Procesamiento inteligente de imagen y reconocimiento de escenas
- ✅ **Editor Incluido:** MotoPhotoEditor con filtros profesionales y herramientas avanzadas
- ✅ **Optimizado para SM6375** (Snapdragon 695 5G) y GPU Adreno 619

## 📦 **APKs Incluidos**

| APK | Tamaño | Función |
|-----|--------|---------|
| **MotCamera4.apk** | 160MB | Aplicación principal de cámara |
| **MotCamera3AI.apk** | 13MB | Inteligencia artificial para cámara |
| **MotoPhotoEditor.apk** | 57MB | Editor de fotos profesional |
| **ImagerTuning-V2.apk** | 37MB | Ajustes avanzados de imagen |
| **MotoSignatureApp.apk** | 1MB | Verificación de firma Motorola |

## 🚀 **Instalación**

### **Requisitos Previos:**
- ✅ **Dispositivo:** Motorola Moto G71 5G únicamente
- ✅ **Android:** Versión 11 o superior
- ✅ **Magisk:** Versión 23.0 o superior
- ✅ **Bootloader:** Desbloqueado y root activo

### **Pasos de Instalación:**

1. **Descargar** el archivo `MotoCam4_G71_5G.zip`
2. **Abrir Magisk Manager** en tu dispositivo
3. **Instalar** → Seleccionar el archivo ZIP descargado
4. **Reiniciar** el dispositivo completamente
5. **Buscar "Cámara"** en el launcher de aplicaciones

## 🔧 **Solución de Problemas**

### Si la aplicación no aparece después de la instalación:

```bash
# Ejecutar script de reparación automática
su -c 'sh /data/adb/modules/MotoCam4G715G/fix_camera.sh'
```

### Si hay problemas de permisos:

```bash
# Verificar instalación manual
su -c 'sh /data/adb/modules/MotoCam4G715G/install_motocam_manual.sh'
```

## 📁 **Estructura del Módulo**

```
MotoCam4G715G/
├── system/
│   ├── app/           # APKs del sistema
│   └── lib64/         # Librerías nativas
├── scripts/
│   ├── install.sh     # Script de instalación
│   └── fix_camera.sh  # Script de reparación
├── tests/             # Scripts de prueba
└── module.prop        # Propiedades del módulo
```

## ⚠️ **Advertencias Importantes**

- 🔴 **Solo compatible con Moto G71 5G** - otros dispositivos pueden experimentar problemas
- 🔴 **Crear respaldo completo** antes de la instalación (TWRP/Nandroid)
- 🔴 **Uso bajo tu propia responsabilidad** - no nos hacemos responsables por daños
- 🔴 **Verificar compatibilidad** de tu firmware antes de instalar

## 🧪 **Testing**

El módulo incluye scripts de prueba para verificar el funcionamiento:

```bash
# Ejecutar todas las pruebas
su -c 'sh /data/adb/modules/MotoCam4G715G/tests/run_all_tests.sh'
```

## 📸 **Funcionalidades Verificadas**

- ✅ Captura de fotos en todos los sensores
- ✅ Grabación de video 1080p
- ✅ Modo nocturno con procesamiento IA
- ✅ Modo retrato con desenfoque
- ✅ Ultra gran angular funcional
- ✅ Macro con enfoque automático
- ✅ Editor de fotos integrado

## 🤝 **Contribuciones**

Si encuentras problemas o mejoras, puedes:
- Reportar issues con logs detallados en: [https://github.com/SkuuIll/MotoCam4_G71_5G](https://github.com/SkuuIll/MotoCam4-G71-5G/issues)
- Sugerir mejoras en la compatibilidad
- Compartir resultados de pruebas

---

**¡Disfruta tu cámara Motorola original con todas sus funcionalidades!** 📸✨

*Desarrollado y probado en Moto G71 5G con Android 12*
