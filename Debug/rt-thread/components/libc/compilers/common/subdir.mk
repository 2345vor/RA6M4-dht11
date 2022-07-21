################################################################################
# �Զ����ɵ��ļ�����Ҫ�༭��
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../rt-thread/components/libc/compilers/common/stdlib.c \
../rt-thread/components/libc/compilers/common/time.c 

OBJS += \
./rt-thread/components/libc/compilers/common/stdlib.o \
./rt-thread/components/libc/compilers/common/time.o 

C_DEPS += \
./rt-thread/components/libc/compilers/common/stdlib.d \
./rt-thread/components/libc/compilers/common/time.d 


# Each subdirectory must supply rules for building sources it contributes
rt-thread/components/libc/compilers/common/%.o: ../rt-thread/components/libc/compilers/common/%.c
	arm-none-eabi-gcc -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\board\ports" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\board" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\libraries\HAL_Drivers\config" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\libraries\HAL_Drivers" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\packages\dhtxx-latest\inc" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\ra\arm\CMSIS_5\CMSIS\Core\Include" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\ra\fsp\inc\api" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\ra\fsp\inc\instances" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\ra\fsp\inc" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\ra_cfg\fsp_cfg\bsp" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\ra_cfg\fsp_cfg" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\ra_gen" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\rt-thread\components\drivers\include" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\rt-thread\components\drivers\sensors" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\rt-thread\components\finsh" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\rt-thread\components\libc\compilers\common" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\rt-thread\components\libc\compilers\newlib" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\rt-thread\components\libc\posix\io\poll" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\rt-thread\components\libc\posix\io\stdio" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\rt-thread\components\libc\posix\ipc" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\rt-thread\include" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\rt-thread\libcpu\arm\common" -I"D:\RT-ThreadStudio\workspace\RA6M4-dht11\rt-thread\libcpu\arm\cortex-m4" -include"D:\RT-ThreadStudio\workspace\RA6M4-dht11\rtconfig_preinc.h" -std=gnu11 -mcpu=cortex-m33 -mthumb -mfpu=fpv5-sp-d16 -mfloat-abi=hard -ffunction-sections -fdata-sections -Dgcc -O0 -gdwarf-2 -g -Wall -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
