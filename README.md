# RPiAndroidCustom
Android configuration/setup on RPI3 

Based on RTAndroid from https://rtandroid.embedded.rwth-aachen.de/
Note: RTAndroid not available any more for download.
Replacement EMTERIA https://emteria.com/ after installation (5min) 
makes a clean and good first impresion!

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

## Loaded Kernel Module(s)

```
rpi3:/ # lsmod
Module                  Size  Used by
getroot                 2116  0
1|rpi3:/ # modinfo getroot
modinfo: /lib/modules/4.4.47+: No such file or directory
1|rpi3:/ # modinfo /system/lib/modules/getroot.ko
filename:       /system/lib/modules/getroot.ko
license:        GPL
description:    Permission elevator for Android apps
author:         Igor Kalkov, Maximilian Schander
srcversion:     F62F83B6C88F54CCB762A29
depends:
vermagic:       4.4.47+ SMP preempt mod_unload modversions ARMv7 p2v8
rpi3:/ #
```

## Directory content

- sdcard (contains -  files from the PI's sdcard having RTAndroid installed) 

## (re)Installation. (RTAndroid)

Configure the install.sh and execute:
``` bash
sudo ./install.sh /dev/mmcblk0
```

The script will partition the sdcard format the partitions and 
copy the files from: and7rpi2016....img

Notes:
- by the first boot the mouse and the keyboard should be
plugged out in thr RPI.



### Installation of gplay (only for RTAndroid)

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

### Packagelisting

[packageslist.txt](packageslist.txt)

```
rpi3:/ $ pm list packages -3
package:stericson.busybox
package:com.ghisler.android.TotalCommander
package:com.chartcross.gpstest
package:media.audioplayer.musicplayer
package:com.spotify.music
package:com.termux
package:com.nng.igo.primong.igoworld
package:com.pdc.main.parkdistancecontrol2
package:com.alphabetlabs.deviceinfo
package:de.zorillasoft.musicfolderplayer
```


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
dtoverlay=spi=on
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

/system/lib/hw/gps.default.so (size 20412 md5: )
source: https://github.com/iszilagyigit/android-serial-gps-driver

used libraries:
```
 ~/work/arm7-andoid-toolchain/bin/arm-linux-androideabi-readelf -d gps.default.so | grep NEEDED  
 0x00000001 (NEEDED)                     Shared library: [liblog.so]
 0x00000001 (NEEDED)                     Shared library: [libm.so]
 0x00000001 (NEEDED)                     Shared library: [libdl.so]
 0x00000001 (NEEDED)                     Shared library: [libc.so]
```

 
Toubleshooting:
- view serial (when gps connected) `cat /dev/ttyS0`
```
$GPGGA,191250.00,4930.68208,N,01058.85689,E,1,05,1.62,352.6,M,47.1,M,,*5E
$GPGSA,A,3,11,27,10,14,01,,,,,,,,8.48,1.62,8.32*0A
$GPGSV,3,1,12,01,40,283,26,03,11,226,,08,70,201,12,10,37,056,23*7D
$GPGSV,3,2,12,11,51,291,23,14,29,133,23,18,66,291,,22,36,225,18*70
```


#### Changes for SIM7600E-H (usb breakout board)

```
$insmod /system/lib/modules/usbserial.ko vendor=0x1e0e product=0x9001
$dmesg 
# The third mounted ttyUSB? is the "AT" interface. Example:
cat /dev/ttyUSB2
+CPIN: READY
SMS DONE
PB DONE

AT
OK

ATI
Manufacturer: SIMCOM INCORPORATED
Model: SIMCOM_SIM7600E-H
Revision: SIM7600M22_V1.1
IMEI: 860147050680683
+GCAP: +CGSM
OK
```
Connect to ttyUSB with 'microcom'
```
/system/xbin/busybox microcom /dev/ttyUSB2
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

#### Boot loglines to check

```
1970-01-01 01:00:16.954 442-442/? D/PackageManager: No files in app dir /system/vendor/app
1970-01-01 01:00:16.954 442-442/? D/PackageManager: No files in app dir /oem/app
...
1970-01-01 01:00:19.389 442-442/? D/PackageManager: No files in app dir /data/app-private
1970-01-01 01:00:19.390 442-442/? D/PackageManager: No files in app dir /data/app-ephemeral
1970-01-01 01:00:19.391 442-442/? E/PackageManager: There should probably be exactly one setup wizard; found 2: matches=[ResolveInfo{1f38235 com.google.android.setupwizard/.SetupWizardActivity p=5 m=0x108000}, ResolveInfo{58c6ca com.android.provision/.DefaultActivity p=1 m=0x108000}]

...

1970-01-01 01:00:20.340 442-442/? D/SensorService: nuSensorService starting...
1970-01-01 01:00:20.340 442-442/? E/SensorService: couldn't load sensors module (No such file or directory)
1970-01-01 01:00:20.347 442-442/? I/SystemServiceManager: Starting com.android.server.BatteryService
1970-01-01 01:00:20.365 442-442/? I/SystemServiceManager: Starting com.android.server.usage.UsageStatsService
1970-01-01 01:00:20.395 442-442/? I/SystemServiceManager: Starting com.android.server.webkit.WebViewUpdateService
...
1970-01-01 01:00:20.847 442-442/? D/BluetoothManagerService: Loading stored name and address
1970-01-01 01:00:20.848 442-442/? D/BluetoothManagerService: Stored bluetooth Name=RPI3,Address=22:22:1E:41:34:59
1970-01-01 01:00:20.848 442-442/? D/BluetoothManagerService: Bluetooth persisted state: 0
...
1970-01-01 01:00:24.226 442-582/? D/gps_glonass_serial: GPS sent to device: $PUBX,40,GGA,100,100,100,0*5b
1970-01-01 01:00:24.226 442-582/? D/gps_glonass_serial: GPS sent to device: $PUBX,40,GLL,100,100,100,0*5d
1970-01-01 01:00:24.226 442-582/? D/gps_glonass_serial: GPS sent to device: $PUBX,40,VTG,100,100,100,0*5f
1970-01-01 01:00:24.226 442-582/? D/gps_glonass_serial: GPS sent to device: $PUBX,40,GSA,100,100,100,0*4f
1970-01-01 01:00:24.226 442-582/? D/gps_glonass_serial: GPS sent to device: $PUBX,40,GSV,100,100,100,0*58
1970-01-01 01:00:24.226 442-582/? D/gps_glonass_serial: GPS sent to device: $PUBX,40,RMC,100,100,100,0*46
1970-01-01 01:00:24.226 442-582/? D/gps_glonass_serial: GPS thread running
...
1970-01-01 01:00:25.299 584-584/com.android.phone I/Telephony: AccountEntry: Registered phoneAccount: [[ ] PhoneAccount: ComponentInfo{com.android.phone/com.android.services.telephony.TelephonyConnectionService}, [e0184adedf913b076626646d3f52c3b49c39ad6d], UserHandle{0} Capabilities: CallProvider MultiUser PlaceEmerg SimSub  Schemes: tel voicemail  Extras: null GroupId: [da39a3ee5e6b4b0d3255bfef95601890afd80709]] with handle: ComponentInfo{com.android.phone/com.android.services.telephony.TelephonyConnectionService}, [e0184adedf913b076626646d3f52c3b49c39ad6d], UserHandle{0}
1970-01-01 01:00:25.307 584-584/com.android.phone I/Telephony: PstnIncomingCallNotifier: Registering: Handler (com.android.internal.telephony.GsmCdmaPhone) {543cef1}
1970-01-01 01:00:25.323 584-584/com.android.phone E/PhoneInterfaceManager: [PhoneIntfMgr] getIccId: No UICC
1970-01-01 01:00:25.327 442-454/? W/Telecom: : registerPhoneAccount not allowed on non-voice capable device.: TSI.rPA@AAY
```

#### FTDI support?!

Linux kernel driver in:
```
rpi3:/ # ls -al /system/lib/modules/*ftdi*.ko
-rw-r--r-- 1 root root  39088 2017-02-11 06:35 /system/lib/modules/ftdi-elan.ko
-rw-r--r-- 1 root root 107816 2017-02-11 06:35 /system/lib/modules/ftdi_sio.ko

-rw-r--r-- 1 root root 15988 2017-02-11 06:35 /system/lib/modules/usb_wwan.ko
-rw-r--r-- 1 root root 45612 2017-02-11 06:35 /system/lib/modules/usbserial.ko
rpi3:/ #
```
Kernel modules from the SoC vendor that are required for full Android or Charger modes should be located in /vendor/lib/modules.
See: https://source.android.com/devices/architecture/kernel/loadable-kernel-modules
```
rpi3:/ # ls -al /vendor/lib/
total 88
drwxr-xr-x 3 root shell  4096 2017-02-11 07:38 .
drwxr-xr-x 3 root shell  4096 2017-02-11 07:08 ..
-rw-r--r-- 1 root root  30612 2017-02-11 07:08 libbt-vendor.so
drwxr-xr-x 2 root shell  4096 2017-02-11 07:38 mediadrm
rpi3:/ #
```
adding in /system/etc/banner 


```
insmod /system/lib/modules/usbserial.ko

rpi3:/ # dmesg -s 300
[ 1562.551828] usbcore: registered new interface driver usbserial
[ 1562.557129] usbcore: registered new interface driver usbserial_generic
[ 1562.562193] usbserial: USB Serial support registered for generic
rpi3:/ # lsmod
Module                  Size  Used by
usbserial              19826  0
getroot                 2116  0
rpi3:/ #


insmod /system/lib/modules/ftdi_sio.ko
chmod 666 /dev/ttyUSB0
```

```
[  340.938008] usb 1-1.2: new full-speed USB device number 4 using dwc_otg
[  341.060553] usb 1-1.2: New USB device found, idVendor=0403, idProduct=6001
[  341.068553] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  341.076372] usb 1-1.2: Product: FT232R USB UART
[  341.084465] usb 1-1.2: Manufacturer: FTDI
[  341.091850] usb 1-1.2: SerialNumber: 00000000
[  341.108495] ftdi_sio 1-1.2:1.0: FTDI USB Serial Device converter detected
[  341.116152] usb 1-1.2: Detected FT232RL
[  341.124486] usb 1-1.2: FTDI USB Serial Device converter now attached to ttyUSB0
```

#### Usefull apps

- *stericson.busybox* (linux commands) 
 some of them already in RTAndroid some might be missing.
to list all busybox commands: `/system/xbin/busybox --help `

- *com.chartcross.gpstest* android app in apk

#### wiringPi (directory)

origin from http://wiringpi.com/ compilation for android (not full compilation!)

files (binary)
/system/lib/libwiringPi.so
/system/xbin/gpio

#### Telephony (ril)

https://source.android.com/devices/tech/connect/ril
https://www.e-consystems.com/Articles/Android/Android-RIL-Architecture.asp
http://www.wless.ru/files/GSM/Neoway/N720/Neoway_Android_RIL_Driver_User_Guide_V1_0.pdf
Quectel_Android_RIL_Driver_User_Guide_V1.8.pdf


```
1|rpi3:/etc/init # cat /etc/init/rild.rc
service ril-daemon /system/bin/rild
    class main
    socket rild stream 660 root radio
    socket sap_uim_socket1 stream 660 bluetooth bluetooth
    socket rild-debug stream 660 radio system
    user root
    group radio cache inet misc audio log readproc wakelock
rpi3:/etc/init # /system/bin/rild --help
Usage: /system/bin/rild -l <ril impl library> [-- <args for impl library>]
1|rpi3:/etc/init #
1|rpi3:/etc/init # ls -al /system/lib/libreference-ril.so
-rw-r--r-- 1 root root 42608 2017-02-11 07:31 /system/lib/libreference-ril.so

130|rpi3:/ # /system/bin/rild -l /system/lib/libreference-ril.so -- -d /dev/ttyUSB2
fatal error opening "/sys/power/wake_lock": No such file or directory
fatal error opening "/sys/android_power/acquire_partial_wake_lock": No such file or directory
255|rpi3:/ #


rpi3:/data/data # getprop | grep gsm
[gsm.current.phone-type]: [1]
[gsm.network.type]: [Unknown]
[gsm.operator.alpha]: []
[gsm.operator.iso-country]: []
[gsm.operator.isroaming]: [false]
[gsm.operator.numeric]: []
[gsm.sim.operator.alpha]: []
[gsm.sim.operator.iso-country]: []
[gsm.sim.operator.numeric]: []
[gsm.sim.state]: [NOT_READY]
rpi3:/data/data # getprop | grep radio
[ro.radio.noril]: [1]
rpi3:/data/data #
```

