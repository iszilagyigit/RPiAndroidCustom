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

Boot log (serial with ftdi - GND, TX, RX connected, baud 115200):
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

U-Boot info
```
U-Boot> printenv
arch=arm
baudrate=115200
board=rpi
board_name=4 Model B
board_rev=0x11
board_rev_scheme=1
board_revision=0xC03111
boot_a_script=load ${devtype} ${devnum}:${distro_bootpart} ${scriptaddr} ${prefix}${script}; source ${scriptaddr}
boot_efi_binary=if fdt addr ${fdt_addr_r}; then bootefi bootmgr ${fdt_addr_r};else bootefi bootmgr ${fdtcontroladdr};fi;load ${devtype} ${devnum}:${distro_bootpart} ${kernel_addr_r} efi/boot/bootaa64.efi; if fdt addr ${fdt_addr_r}; then bootefi ${kernel_addr_r} ${fdt_addr_r};else bootefi ${kernel_addr_r} ${fdtcontroladdr};fi
boot_extlinux=sysboot ${devtype} ${devnum}:${distro_bootpart} any ${scriptaddr} ${prefix}${boot_syslinux_conf}
boot_net_usb_start=usb start
boot_pci_enum=pci enum
boot_prefixes=/ /boot/
boot_script_dhcp=boot.scr.uimg
boot_scripts=boot.scr.uimg boot.scr
boot_syslinux_conf=extlinux/extlinux.conf
boot_targets=mmc0 mmc1 usb0 pxe dhcp 
bootcmd=setenv mmc_bootdev 0 && setenv scriptaddr 0x3000000 && load mmc 0:1 ${scriptaddr} uboot.scr.uimg && source ${scriptaddr}
bootcmd_dhcp=run boot_net_usb_start; run boot_pci_enum; if dhcp ${scriptaddr} ${boot_script_dhcp}; then source ${scriptaddr}; fi;setenv efi_fdtfile ${fdtfile}; setenv efi_old_vci ${bootp_vci};setenv efi_old_arch ${bootp_arch};setenv bootp_vci PXEClient:Arch:00011:UNDI:003000;setenv bootp_arch 0xb;if dhcp ${kernel_addr_r}; then tftpboot ${fdt_addr_r} dtb/${efi_fdtfile};if fdt addr ${fdt_addr_r}; then bootefi ${kernel_addr_r} ${fdt_addr_r}; else bootefi ${kernel_addr_r} ${fdtcontroladdr};fi;fi;setenv bootp_vci ${efi_old_vci};setenv bootp_arch ${efi_old_arch};setenv efi_fdtfile;setenv efi_old_arch;setenv efi_old_vci;
bootcmd_mmc0=devnum=0; run mmc_boot
bootcmd_mmc1=devnum=1; run mmc_boot
bootcmd_pxe=run boot_net_usb_start; run boot_pci_enum; dhcp; if pxe get; then pxe boot; fi
bootcmd_usb0=devnum=0; run usb_boot
bootdelay=2
cpu=armv8
dfu_alt_info=u-boot.bin fat 0 1;uboot.env fat 0 1;config.txt fat 0 1;Image fat 0 1
dhcpuboot=usb start; dhcp u-boot.uimg; bootm
distro_bootcmd=for target in ${boot_targets}; do run bootcmd_${target}; done
efi_dtb_prefixes=/ /dtb/ /dtb/current/
ethaddr=dc:a6:32:47:74:fa
fdt_addr=2eff3900
fdt_addr_r=0x02600000
fdt_high=ffffffffffffffff
fdtcontroladdr=3af39700
fdtfile=broadcom/bcm2711-rpi-4-b.dtb
initrd_high=ffffffffffffffff
kernel_addr_r=0x00080000
load_efi_dtb=load ${devtype} ${devnum}:${distro_bootpart} ${fdt_addr_r} ${prefix}${efi_fdtfile}
loadaddr=0x00200000
mmc_boot=if mmc dev ${devnum}; then devtype=mmc; run scan_dev_for_boot_part; fi
preboot=pci enum; usb start;
pxefile_addr_r=0x02500000
ramdisk_addr_r=0x02700000
scan_dev_for_boot=echo Scanning ${devtype} ${devnum}:${distro_bootpart}...; for prefix in ${boot_prefixes}; do run scan_dev_for_extlinux; run scan_dev_for_scripts; done;run scan_dev_for_efi;
scan_dev_for_boot_part=part list ${devtype} ${devnum} -bootable devplist; env exists devplist || setenv devplist 1; for distro_bootpart in ${devplist}; do if fstype ${devtype} ${devnum}:${distro_bootpart} bootfstype; then run scan_dev_for_boot; fi; done; setenv devplist
scan_dev_for_efi=setenv efi_fdtfile ${fdtfile}; for prefix in ${efi_dtb_prefixes}; do if test -e ${devtype} ${devnum}:${distro_bootpart} ${prefix}${efi_fdtfile}; then run load_efi_dtb; fi;done;if test -e ${devtype} ${devnum}:${distro_bootpart} efi/boot/bootaa64.efi; then echo Found EFI removable media binary efi/boot/bootaa64.efi; run boot_efi_binary; echo EFI LOAD FAILED: continuing...; fi; setenv efi_fdtfile
scan_dev_for_extlinux=if test -e ${devtype} ${devnum}:${distro_bootpart} ${prefix}${boot_syslinux_conf}; then echo Found ${prefix}${boot_syslinux_conf}; run boot_extlinux; echo SCRIPT FAILED: continuing...; fi
scan_dev_for_scripts=for script in ${boot_scripts}; do if test -e ${devtype} ${devnum}:${distro_bootpart} ${prefix}${script}; then echo Found U-Boot script ${prefix}${script}; run boot_a_script; echo SCRIPT FAILED: continuing...; fi; done
scriptaddr=0x02400000
serial#=10000000fcc271ba
soc=bcm283x
stderr=serial,vidconsole
stdin=serial,usbkbd
stdout=serial,vidconsole
usb_boot=usb start; if usb dev ${devnum}; then devtype=usb; run scan_dev_for_boot_part; fi
usbethaddr=dc:a6:32:47:74:fa
vendor=raspberrypi

Environment size: 4182/16380 bytes
U-Boot> 

```
(!) For booting with a Serial GPS Sensor connected to Pins 14,15 disable U-Boot boot delay:

```
u-boot> setenv bootdelay -2
u-boot> saveenv
```







