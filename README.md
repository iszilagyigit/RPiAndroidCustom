# RPiAndroidCustom
Android configuration/setup on RPI3 

Based on RTAndroid from https://rtandroid.embedded.rwth-aachen.de/


## Hardware

- Raspberry PI3 
- 7" Official touch screen

## Directory content

- sdcard (contains - partially files from the PI's sdcard having android installed) 

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

#### Boot Partition

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

#### System Partition

