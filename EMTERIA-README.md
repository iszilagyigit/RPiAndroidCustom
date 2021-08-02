EMTERIA https://emteria.com/ 
(RTANdroid replacement) after installation (5min) 
makes a clean and good first impression!

See: https://about.emteria.com/emteria-os-for-raspberry-pi-4b/

## Hardware

- Raspberry PI4 
- 7" Official touch screen
- Ublox NEO 6M-GPS Modul GY-GPS6MV2 UART

## (re)Installation. (EMPTERIA)
 - Use the empteria installer.
 - After installation and initial config:
 - Settings/Empteria: 
 -- Screen Orientation: Set to 180, Lock Screen orientation.
 -- Enable ADB over ethernet
 -- Enable integrated SSH server

------------------------------------

Kernel clone and compile

https://github.com/iszilagyigit/kernel_brcm_rpi  (tree/v5.10.33-q/arch/arm64)

Cross Compiler:
```
$sudo apt-get install gcc-aarch64-linux-gnu
(cross compiler für ARM64  BCM2711 - RPI4) 
```

```
$make O=build ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2711_aosp11_defconfig
$make O=build -j6 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules dtbs
(gzip -9 Image)
```




