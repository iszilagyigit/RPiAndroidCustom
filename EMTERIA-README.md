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
---------------------------------------
U-Boot info

```
$ cat ./boot/config.txt | grep kernel
kernel=u-boot.bin
$ file ./boot/u-boot.bin
./boot/u-boot.bin: PCX ver. 2.5 image data bounding box [8223, 54531] - [0, 8], 20-bit uncompressed
$ file ./boot/uboot.scr.uimg
./boot/uboot.scr.uimg: u-boot legacy uImage, uboot.scr, Linux/ARM 64-bit, Script File (Not compressed), 1700 bytes, Thu Jun 17 12:23:00 2021, Load Address: 0x00000000, Entry Point: 0x00000000, Header CRC: 0xF6F932B4, Data CRC: 0xD6B73E58
boot$ mkimage -l uboot.scr.uimg
Image Name:   uboot.scr
Created:      Thu Jun 17 14:23:00 2021
Image Type:   AArch64 Linux Script (uncompressed)
Data Size:    1700 Bytes = 1.66 KiB = 0.00 MiB
Load Address: 00000000
Entry Point:  00000000
Contents:
   Image 0: 1692 Bytes = 1.65 KiB = 0.00 MiB
boot$ mkimage -l u-boot.bin
GP Header: Size a000014 LoadAddr 1f2003d5
```
U-Boot Quelle: https://github.com/emteria/external_u-boot_rpi.git

Boot log (serial with ftdi):
```

U-Boot 2020.04-rc3-00389-g2414bbb7aba2 (Mar 15 2021 - 17:18:31 +0100)

DRAM:  3.9 GiB
RPI 4 Model B (0xc03111)
MMC:   sdhci_setup_cfg: Your controller doesn't support SDMA!!
sdhci_setup_cfg: Your controller doesn't support SDMA!!
mmcnr@7e300000 - probe failed: -22
sdhci_setup_cfg: Your controller doesn't support SDMA!!

Loading Environment from FAT... *** Warning - bad CRC, using default environment

In:    serial
Out:   serial
Err:   serial
Net:   eth0: ethernet@7d580000
starting USB...
No working controllers found
Hit any key to stop autoboot:  2  1  0 
1764 bytes read in 22 ms (78.1 KiB/s)
## Executing script at 03000000
** Unrecognized filesystem type **
** Unrecognized filesystem type **
## Warning: defaulting to text format
## Info: input data size = 865 = 0x361
1931759 bytes read in 119 ms (15.5 MiB/s)
14460172 bytes read in 750 ms (18.4 MiB/s)
Uncompressed size: 32033280 = 0x1E8CA00
## Loading init Ramdisk from Legacy Image at 02700000 ...
   Image Name:   
   Image Type:   AArch64 Linux RAMDisk Image (gzip compressed)
   Data Size:    1931695 Bytes = 1.8 MiB
   Load Address: 00000000
   Entry Point:  00000000
   Verifying Checksum ... OK
## Flattened Device Tree blob at 2eff3900
   Booting using the fdt blob at 0x2eff3900
   Using Device Tree in place at 000000002eff3900, end 000000002f002f89

Starting kernel ...
```




