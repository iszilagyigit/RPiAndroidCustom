// log01.s

// example for an extenal log call in android for logcat

/* corresponding C:

// log example

#include <android/log.h>

char* tag = "TAG";
char* msg = "___TEST LOG MESSAGE___";

int main() {
	return __android_log_write(ANDROID_LOG_INFO (4), tag, msg);
}
to compile  ~/work/arm7-andoid-toolchain/bin/arm-linux-androideabi-gcc -pie   -llog  -Wall -o logexample logexample

the "log" library (-llog) has the following functions

 ~/work/arm7-andoid-toolchain $ readelf -a ./sysroot/usr/lib/liblog.so | grep FUNC
     1: 000002ed     2 FUNC    GLOBAL DEFAULT    5 __android_log_is_loggable
     2: 000002ed     2 FUNC    GLOBAL DEFAULT    5 __android_log_is_loggable
     5: 000002ed     2 FUNC    GLOBAL DEFAULT    5 __android_log_assert
     6: 000002ed     2 FUNC    GLOBAL DEFAULT    5 __android_log_print
     7: 000002ed     2 FUNC    GLOBAL DEFAULT    5 __android_log_vprint
     8: 000002ed     2 FUNC    GLOBAL DEFAULT    5 __android_log_write
    22: 000002ed     2 FUNC    GLOBAL DEFAULT    5 __android_log_assert
    23: 000002ed     2 FUNC    GLOBAL DEFAULT    5 __android_log_is_loggable
    24: 000002ed     2 FUNC    GLOBAL DEFAULT    5 __android_log_is_loggable
    25: 000002ed     2 FUNC    GLOBAL DEFAULT    5 __android_log_print
    26: 000002ed     2 FUNC    GLOBAL DEFAULT    5 __android_log_vprint
    27: 000002ed     2 FUNC    GLOBAL DEFAULT    5 __android_log_write
 ~/work/arm7-andoid-toolchain $ 
find a list of functions in a shared library:(TYP: shared object file!) readelf -a ...so | grep FUNC
*/




.data


.text

.global main

main:
	dbg #0
	push {lr} 
	// alias for str lr, [sp, #-4]! (preindexing mode)
	// sp = sp -4; *sp = lr (store the lr to address pointed by sp)

	mov r0, #4 // ANDROID_LOG_INFO = 4
	adr r1, strLOGCAT // r1 = &strLOGCAT (note diference between adr and ldr!)
	adr r2, strLOGMSG1 // r2 = &strLOGMSG
	bl __android_log_write

	pop {lr}
	bx lr

strLOGCAT:  .asciz "APPLOG"
strLOGMSG1: .asciz "ASM_LOG_MESSAGE04"


