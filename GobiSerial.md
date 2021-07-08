# Compiling GobiSerial Kernel Module

Download the Latest 4.4 Kernel for RPi3 to a linux and build the kernel 
as described hier:
https://www.raspberrypi.org/documentation/linux/kernel/building.md

```
sudo apt install libssl-dev libc6-dev libncurses5-dev

# for a 32 bit kernel:
sudo apt install crossbuild-essential-armhf

git clone --depth=1 --branch rpi-4.20.y https://github.com/raspberrypi/linux

cd linux
KERNEL=kernel7
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig

make -j 6 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs

adb push modules/usb/serial/gobiserial/GobiSerial.ko  /data/local/temp
```



```
insmod /data/local/temp/GobiSerial.ko

dmesg
[  173.210398] GobiSerial: Unknown symbol usb_wwan_suspend (err 0)
[  173.218663] GobiSerial: Unknown symbol __stack_chk_guard (err 0)
[  173.226670] GobiSerial: disagrees about version of symbol usb_clear_halt
[  173.234539] GobiSerial: Unknown symbol usb_clear_halt (err -22)
[  173.242205] GobiSerial: disagrees about version of symbol usb_bulk_msg
[  173.249741] GobiSerial: Unknown symbol usb_bulk_msg (err -22)
[  173.257120] GobiSerial: Unknown symbol __stack_chk_fail (err 0)
[  173.264300] GobiSerial: Unknown symbol usb_serial_generic_open (err 0)
[  173.271326] GobiSerial: disagrees about version of symbol usb_set_interface
[  173.278220] GobiSerial: Unknown symbol usb_set_interface (err -22)
[  173.284975] GobiSerial: disagrees about version of symbol printk
[  173.291560] GobiSerial: Unknown symbol printk (err -22)
[  173.297985] GobiSerial: Unknown symbol usb_serial_deregister_drivers (err 0)
[  173.304297] GobiSerial: Unknown symbol usb_wwan_resume (err 0)
[  173.310396] GobiSerial: Unknown symbol __gnu_mcount_nc (err 0)
[  173.316273] GobiSerial: Unknown symbol __aeabi_unwind_cpp_pr1 (err 0)
[  173.321993] GobiSerial: disagrees about version of symbol param_ops_int
[  173.327574] GobiSerial: Unknown symbol param_ops_int (err -22)
[  173.332994] GobiSerial: Unknown symbol usb_serial_register_drivers (err 0)
rpi3:/ #
```
