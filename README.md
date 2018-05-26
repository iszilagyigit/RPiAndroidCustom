# RPiAndroidCustom
Android configuration/setup on RPI3 

Based on RTAndroid from https://rtandroid.embedded.rwth-aachen.de/


## Hardware

- Raspberry PI3 
- 7" Official touch screen
- Ublox NEO 6M-GPS Modul GY-GPS6MV2 UART


---
Device info (from Device Info HW app)

- Android 7.1.1 Nougat API 25, Java VM ART 2.1.0
- Linux: 4.4.47 gcc 4.9 20150123, armeabi-v7a
- Input: FT5406 memory base diver, sysfs: /Devices/virtual/input/input0, handlers:mouse0, event0
- BCM2709 ARM7 (Cortex-A53) 1.2GHZ 1GB RAM, 
- Instruction set: 
half, thumb, fastmult, vfp, edsp, neon, vfpv3,
tls, vfpv4, idiva, idivt, vdpd32 lpae evtstrm, crc32
---


## Directory content

- sdcard (contains -  files from the PI's sdcard having RTAndroid installed) 

## (re)Installation.

Configure the install.sh and execute:
``` bash
sudo ./install.sh /dev/mmcblk0
```

The script will partition the sdcard format the partitions and 
copy the files from:
(TODO)
Notes:
- by the first boot the mouse and the keyboard should be
plugged out in thr RPI.

### Installation of gplay

- install in linux if not yet installed
```
sudo apt-get install android-tools-adb android-tools-fastboot
```
- start WLAN in the RPI
- write RPI's IP in gapps.shp
- start adb in linux and start gpapps.sh
```
adb connect 192.168.2.110 (example)
./gpapps.sh -a arm -i 192.168.2.110
```
Note: Disable playstore autoupdate. 
(Start playstore, menu icon, settings/auto update)

### Partitions

/boot
/system
/cache
/userdata

#### Boot Partition (/boot)

**config.txt** (parts)

setting for display (official 7" touch screen)
```
hdmi_mode=87
hdmi_cvt=800 480 60 6 0 0 0
...
dtoverlay=rpi-ft5406
...
gpu_mem=256
enable_uart=1
lcd_rotate=2
```

The **cmdline.txt** (kernel params)
```
initrd=0x01f00000 dwc_otg.lpm_enable=0 no_console_suspend root=/dev/ram0 acpi_irq_nobalance noirqbalance isolcpus=1 elevator=deadline rootwait androidboot.hardware=rpi3 androidboot.selinux=permissive
```

Note: for GPS removed the option __console=serial0,115200__

#### System Partition (/system)

**build.prop**

changes for GPS

```
ro.kernel.android.gps=ttyS0
ro.kernel.android.gps.speed=9600
ro.kernel.android.gps.max_rate=1
```
#### Root Partition (/)

The *init.rc* file.

The init (/init) is the fist process that starts. It looks for the init.rc file parse and execute it. 
The original init can be found in
[androidsource]/system/core/init and the init.rc in  [androidsource]/system/core/rootdir/init.rc

For Zygote initialization see:
[androidsource]/frameworks/base/
[androidsource]/frameworks/base/core/java/com/android/internal/os/ZygoteInit.java
see also android.R