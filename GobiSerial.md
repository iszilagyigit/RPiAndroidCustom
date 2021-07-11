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

Fixes(?)

* For (Stack_chk): If GCC sees both fstack-protector and fno-stack-protector in the set of options, the last one on the command line is the one that takes effect.

* For (aeabi_unwind_cpp_pr1): It turns out exceptions are enabled by default (which is what generates the code that calls eabi_unwind_cpp_pr1). To disable them all that is needed is to pass: -fno-exceptions as an argument to the gcc/g++ compiler and the problem is solved.


-----------

```
diff --git a/Makefile b/Makefile
index a93e38cdd..d2160329a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
-PATCHLEVEL = 19
-SUBLEVEL = 127
+PATCHLEVEL = 4
+SUBLEVEL = 47
 EXTRAVERSION =
 NAME = "People's Front"

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 0cce54182..c67759340 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -185,7 +185,7 @@ config CPU_BIG_ENDIAN

 config SMP
        bool "Symmetric Multi-Processing"
-       default n
+       default y
        select ARC_MCIP if ISA_ARCV2
        help
          This enables support for systems with more than one CPU.
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e2f7c50db..e0998767d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1278,6 +1278,7 @@ menu "Kernel Features"

 config HAVE_SMP
        bool
+       default y
        help
          This option should be selected by machines which have an SMP-
          capable CPU.
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 166920ae2..1bc1b7ecc 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -40,7 +40,7 @@ source "drivers/net/wireless/intersil/Kconfig"
 source "drivers/net/wireless/marvell/Kconfig"
 source "drivers/net/wireless/mediatek/Kconfig"
 source "drivers/net/wireless/ralink/Kconfig"
-source "drivers/net/wireless/realtek/Kconfig"
+# source "drivers/net/wireless/realtek/Kconfig"
 source "drivers/net/wireless/rsi/Kconfig"
 source "drivers/net/wireless/st/Kconfig"
 source "drivers/net/wireless/ti/Kconfig"
diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index 533f127c3..0c4fcf57c 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -19,6 +19,13 @@ menuconfig USB_SERIAL

 if USB_SERIAL

+config USB_GOBISERIAL
+    tristate "SIMCOM Modem USB Serial driver"
+    default m
+    help
+      usb serial driver for SIMCOM modem
+
+
 config USB_SERIAL_CONSOLE
        bool "USB Serial Console device support"
        depends on USB_SERIAL=y
diff --git a/drivers/usb/serial/Makefile b/drivers/usb/serial/Makefile
index 2d491e434..e5f79afe3 100644
--- a/drivers/usb/serial/Makefile
+++ b/drivers/usb/serial/Makefile
@@ -11,6 +11,8 @@ usbserial-y := usb-serial.o generic.o bus.o

 usbserial-$(CONFIG_USB_SERIAL_CONSOLE) += console.o

+obj-m += lxkernmod01.o
+obj-$(CONFIG_USB_GOBISERIAL)                    += gobiserial/
 obj-$(CONFIG_USB_SERIAL_AIRCABLE)              += aircable.o
 obj-$(CONFIG_USB_SERIAL_ARK3116)               += ark3116.o
 obj-$(CONFIG_USB_SERIAL_BELKIN)                        += belkin_sa.o
diff --git a/init/Kconfig b/init/Kconfig
index 47035b5a4..123b0fd9c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -54,7 +54,7 @@ config BROKEN
 config BROKEN_ON_SMP
        bool
        depends on BROKEN || !SMP
-       default y
+       default n

 config INIT_ENV_ARG_LIMIT
        int
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 5e3de28c7..918597b14 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -16,6 +16,7 @@ config HAVE_FTRACE_NMI_ENTER

 config HAVE_FUNCTION_TRACER
        bool
+       default n
        help
          See Documentation/trace/ftrace-design.rst
```
