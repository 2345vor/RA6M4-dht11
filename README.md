# RA6M4-dht11
 temperature and humidity reading
@[toc](【Renesas RA6M4开发板之DHT11温湿度读取】)

# 1.0 DHT11
![在这里插入图片描述](https://img-blog.csdnimg.cn/945c2f6627254d858e05cb93664437aa.png)


**此图转载telesky旗舰店**

*本篇通过Renesas RA6M4开发板DHT11温湿度读取示例程序演示。*
## 1.1 BMP180介绍
DHT11数字温湿度传感器是一款含有已校准数字信号输出的温湿度复合传感器。它应用专用的数字模块采集技术和温湿度传感技术，确保产品具有可靠性与卓越的长期稳定性，成本低、相对湿度和温度测量、快响应、抗干扰能力强、信号传输距离长、数字信号输出、精确校准。传感器包括一个电容式感湿元件和一个NTC测温元件，并与一个高性能8位单片机相连接。
可用于暖通空调、除湿器、测试及检测设备、消费品、汽车、自动控制、数据记录器、气象站、家电、湿度调节器、医疗、其他相关湿度检测控制。


## 1.2 BMP180特点
1、相对湿度和温度一体测量
2、全量程标定。无需重新标定即可互换使用
3、快响应时间
4、单线制数字接回(简单的系统集成,低的价格)
5、高可靠性
6、优化的长期稳定性
7、抗手扰能力强8信号传输距离长
8、需在气体环境中工作，不可测量液体和反接电源😅😅😅
![在这里插入图片描述](https://img-blog.csdnimg.cn/0ba7b37bac664d9288354b6fc635d14d.png)


尺寸大小如下：
![在这里插入图片描述](https://img-blog.csdnimg.cn/0eefc51bcd984ca9aca77654f1c6e381.png)

## 1.3 产品应用
- 暖通空调除湿器
- 测试及检测设备测试及检测设备·汽车
- 数据记录器消费品
 - 自动控制。气象站




# 2. RT-theard配置
## 2.1 硬件需求
1、dht11测量当前气体环境的温度和湿度，采用单线传输，接P102

> 实现功能：
>dht11测量当前气体环境的温度和湿度


2、RA6M4开发板
![在这里插入图片描述](https://img-blog.csdnimg.cn/4c5dcda23c6d4afaacb393dc46a7ae51.png)
3、USB下载线，ch340串口和附带5根母母线，**rx---p613;tx---p614**        
![在这里插入图片描述](https://img-blog.csdnimg.cn/34aa76e89ec748d9bf7d9154036ebcad.png)

## 2.2 软件配置
Renesas RA6M4开发板环境配置参照：[【基于 RT-Thread Studio的CPK-RA6M4 开发板环境搭建】](https://blog.csdn.net/vor234/article/details/125634313)
1、新建项目RA6M4-dht11工程
![在这里插入图片描述](https://img-blog.csdnimg.cn/abaa0555adcc4dd29e436183eaeb644c.png)


2、点击RT-theard Setting，在软件包下添加软件包，然后搜索dht相关软件支持包选择`dhtxx`，点击添加即可,然后出现对应包。
![在这里插入图片描述](https://img-blog.csdnimg.cn/d8922793c80b4bce843c9da5f463b186.png)


3、配置`dhtxx`，右键选择配置项
![在这里插入图片描述](https://img-blog.csdnimg.cn/1a7548bea38e4a1aa5f1c7ce03538cb1.png)


4、在软件包中开启示例程序。
![在这里插入图片描述](https://img-blog.csdnimg.cn/f188b660519742af902f6fec2818521e.png)
5、在`Smart Configuration`中配置P102引脚为`Input mode`

![screenshot_image.png](https://img-blog.csdnimg.cn/img_convert/927157cec5de1485be11c3cdf880a7b9.webp?x-oss-process=image/format,png)

6、全部保存刚刚的配置，更新当前配置文件

**保存完是灰色，没有保存是蓝色。**
# 3. 代码分析
1、刚刚加载软件包在packages文件夹下，修改三处`.c`文件，

> dhtxx_latest的example文件夹下的`dhtxx_sample.c`
> dhtxx_latest的src文件夹下的`dhtxx.c`和`sensor_asair_dhtxx.c`


示例代码更改为如下
![在这里插入图片描述](https://img-blog.csdnimg.cn/d7a6127bc1434895a5dd1cfb58e21e66.png)


（更改内容头文件添加`#include "bsp_api.h"`,端口设置为`BSP_IO_PORT_01_PIN_02`,然后删除微秒`us`定时器）😅😅😅

`dhtxx_sample.c`
```cpp

/*
 * Copyright (c) 2020, RudyLo <luhuadong@163.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2020-01-20     luhuadong    the first version
 * 2020-10-05     luhuadong    v0.9.0
 */

#include <rtthread.h>
#include <rtdevice.h>
#include <board.h>
#include "dhtxx.h"
#include "hal_data.h"
#define DATA_PIN   BSP_IO_PORT_01_PIN_02

/* cat_dhtxx sensor data by dynamic */
static void cat_dhtxx(void)
{
    dht_device_t sensor = dht_create(DATA_PIN);

    if(dht_read(sensor)) {

        rt_int32_t temp = dht_get_temperature(sensor);
        rt_int32_t humi = dht_get_humidity(sensor);

        rt_kprintf("Temp: %d.%d 'C,  Humi: %d '% \n", temp/10, temp%10, humi/10);
    }
    else {
        rt_kprintf("Read dht sensor failed.\n");
    }

    dht_delete(sensor);
}

#ifdef FINSH_USING_MSH
MSH_CMD_EXPORT(cat_dhtxx, read dhtxx humidity and temperature);
#endif

```
`dhtxx.c`

```cpp
/*
 * Copyright (c) 2020, RudyLo <luhuadong@163.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2020-01-20     luhuadong    the first version
 */

#include <board.h>
#include "dhtxx.h"
#include "bsp_api.h"
#define DBG_TAG                  "sensor.asair.dhtxx"
#ifdef PKG_USING_DHTXX_DEBUG
#define DBG_LVL                  DBG_LOG
#else
#define DBG_LVL                  DBG_ERROR
#endif
#include <rtdbg.h>

/* timing */
#define DHT1x_BEGIN_TIME         20  /* ms */
#define DHT2x_BEGIN_TIME         1   /* ms */
#define DHTxx_PULL_TIME          30  /* us */
#define DHTxx_REPLY_TIME         100 /* us */
#define MEASURE_TIME             40  /* us */



/**
 * This function will split a number into two part according to times.
 *
 * @param num      the number will be split
 * @param integer  the integer part
 * @param decimal  the decimal part
 * @param times    how many times of the real number (you should use 10 in this case)
 *
 * @return 0 if num is positive, 1 if num is negative
 */
int split_int(const int num, int *integer, int *decimal, const rt_uint32_t times)
{
    int flag = 0;
    if (num < 0) flag = 1;

    int anum = num<0 ? -num : num;
    *integer = anum / times;
    *decimal = anum % times;

    return flag;
}

/**
 * This function will convert temperature in degree Celsius to Kelvin.
 *
 * @param c  the temperature indicated by degree Celsius
 *
 * @return the result
 */
float convert_c2k(float c)
{
    return c + 273.15;
}

/**
 * This function will convert temperature in degree Celsius to Fahrenheit.
 *
 * @param c  the temperature indicated by degree Celsius
 *
 * @return the result
 */
float convert_c2f(float c)
{
    return c * 1.8 + 32;
}

/**
 * This function will convert temperature in degree Fahrenheit to Celsius.
 *
 * @param f  the temperature indicated by degree Fahrenheit
 *
 * @return the result
 */
float convert_f2c(float f)
{
    return (f - 32) * 0.55555;
}

/**
 * This function will read a bit from sensor.
 *
 * @param pin  the pin of Dout
 *
 * @return the bit value
 */
static uint8_t dht_read_bit(const rt_base_t pin)
{
    uint8_t retry = 0;

    while(rt_pin_read(pin) && retry < DHTxx_REPLY_TIME)
    {
        retry++;
        rt_hw_us_delay(1);
    }

    retry = 0;
    while(!rt_pin_read(pin) && retry < DHTxx_REPLY_TIME)
    {
        retry++;
        rt_hw_us_delay(1);
    }

    rt_hw_us_delay(MEASURE_TIME);
    
    return rt_pin_read(pin);
}

/**
 * This function will read a byte from sensor.
 *
 * @param pin  the pin of Dout
 *
 * @return the byte
 */
static uint8_t dht_read_byte(const rt_base_t pin)
{
    uint8_t i, byte = 0;

    for(i=0; i<8; i++)
    {
        byte <<= 1;
        byte |= dht_read_bit(pin);
    }

    return byte;
}

/**
 * This function will read and update data array.
 *
 * @param dev  the device to be operated
 *
 * @return RT_TRUE if read successfully, otherwise return RT_FALSE.
 */
rt_bool_t dht_read(dht_device_t dev)
{
    RT_ASSERT(dev);

    uint8_t i, retry = 0, sum = 0;

#ifdef PKG_USING_DHTXX_INTERRUPT_DISABLE
    rt_base_t level;
#endif

    /* Reset data buffer */
    rt_memset(dev->data, 0, DHT_DATA_SIZE);

    /* MCU request sampling */
    rt_pin_mode(dev->pin, PIN_MODE_OUTPUT);
    rt_pin_write(dev->pin, PIN_LOW);

    if (dev->type == DHT11 || dev->type == DHT12) {
        rt_thread_mdelay(DHT1x_BEGIN_TIME);        /* Tbe */
    } else {
        rt_thread_mdelay(DHT2x_BEGIN_TIME);
    }

#ifdef PKG_USING_DHTXX_INTERRUPT_DISABLE
    level = rt_hw_interrupt_disable();
#endif

    rt_pin_mode(dev->pin, PIN_MODE_INPUT_PULLUP);
    rt_hw_us_delay(DHTxx_PULL_TIME);               /* Tgo */

    /* Waiting for sensor reply */
    while (rt_pin_read(dev->pin) && retry < DHTxx_REPLY_TIME)
    {
        retry++;
        rt_hw_us_delay(1);                         /* Trel */
    }
    if(retry >= DHTxx_REPLY_TIME) return RT_FALSE;

    retry = 0;
    while (!rt_pin_read(dev->pin) && retry < DHTxx_REPLY_TIME)
    {
        retry++;
        rt_hw_us_delay(1);                         /* Treh */
    };
    if(retry >= DHTxx_REPLY_TIME) return RT_FALSE;

    /* Read data */
    for(i=0; i<DHT_DATA_SIZE; i++)
    {
        dev->data[i] = dht_read_byte(dev->pin);
    }

#ifdef PKG_USING_DHTXX_INTERRUPT_DISABLE
    rt_hw_interrupt_enable(level);
#endif

    /* Checksum */
    for(i=0; i<DHT_DATA_SIZE-1; i++)
    {
        sum += dev->data[i];
    }
    if(sum != dev->data[4]) return RT_FALSE;

    return RT_TRUE;
}

/**
 * This function will get the humidity from dhtxx sensor.
 *
 * @param dev  the device to be operated
 *
 * @return the humidity value
 */
rt_int32_t dht_get_humidity(dht_device_t const dev)
{
    RT_ASSERT(dev);

    rt_int32_t humi = 0;

    switch(dev->type)
    {
    case DHT11:
    case DHT12:
        humi = dev->data[0] * 10 + dev->data[1];
        break;
    case DHT21:
    case DHT22:
        humi = (dev->data[0] << 8) + dev->data[1];
        break;
    default:
        break;
    }

    return humi;
}

/**
 * This function will get the temperature from dhtxx sensor.
 *
 * @param dev  the device to be operated
 *
 * @return the temperature value
 */
rt_int32_t dht_get_temperature(dht_device_t const dev)
{
    RT_ASSERT(dev);

    rt_int32_t temp = 0;

    switch(dev->type)
    {
    case DHT11:
    case DHT12:
        temp = dev->data[2] * 10 + (dev->data[3] & 0x7f);
        if(dev->data[3] & 0x80) {
            temp = -temp;
        }
        break;
    case DHT21:
    case DHT22:
        temp = ((dev->data[2] & 0x7f) << 8) + dev->data[3];
        if(dev->data[2] & 0x80) {
            temp = -temp;
        }
        break;
    default:
        break;
    }

    return temp;
}

/**
 * This function will init dhtxx sensor device.
 *
 * @param dev  the device to init
 * @param pin  the pin of Dout
 *
 * @return the device handler
 */
rt_err_t dht_init(struct dht_device *dev, const rt_base_t pin)
{
    if(dev == NULL)
        return -RT_ERROR;

    dev->type = DHT_TYPE;
    dev->pin  = pin;

    rt_memset(dev->data, 0, DHT_DATA_SIZE);
    rt_pin_mode(dev->pin, PIN_MODE_INPUT_PULLUP);
    
    return RT_EOK;
}

dht_device_t dht_create(const rt_base_t pin)
{
    dht_device_t dev;

    dev = rt_calloc(1, sizeof(struct dht_device));
    if (dev == RT_NULL)
    {
        LOG_E("Can't allocate memory for dhtxx device");
        return RT_NULL;
    }

    dev->type = DHT_TYPE;
    dev->pin  = pin;

    rt_memset(dev->data, 0, DHT_DATA_SIZE);
    rt_pin_mode(dev->pin, PIN_MODE_INPUT_PULLUP);

    return dev;
}

void dht_delete(dht_device_t dev)
{
    if (dev)
        rt_free(dev);
}

```
`sensor_asair_dhtxx.c`

```cpp
/*
 * Copyright (c) 2020, RudyLo <luhuadong@163.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2020-02-17     luhuadong    the first version
 */

#include <board.h>
#include "dhtxx.h"
#include "bsp_api.h"
#define DBG_TAG                  "sensor.asair.dhtxx"
#ifdef PKG_USING_DHTXX_DEBUG
#define DBG_LVL                  DBG_LOG
#else
#define DBG_LVL                  DBG_ERROR
#endif
#include <rtdbg.h>

/* timing */
#define DHT1x_BEGIN_TIME         20  /* ms */
#define DHT2x_BEGIN_TIME         1   /* ms */
#define DHTxx_PULL_TIME          30  /* us */
#define DHTxx_REPLY_TIME         100 /* us */
#define MEASURE_TIME             40  /* us */

/* range by ten times */
#define SENSOR_HUMI_RANGE_MIN    0
#define SENSOR_HUMI_RANGE_MAX    1000
#define SENSOR_TEMP_RANGE_MIN    -400
#define SENSOR_TEMP_RANGE_MAX    800

/* minial period (ms) */
#define SENSOR_PERIOD_MIN        1000
#define SENSOR_HUMI_PERIOD_MIN   SENSOR_PERIOD_MIN
#define SENSOR_TEMP_PERIOD_MIN   SENSOR_PERIOD_MIN

/* fifo max length */
#define SENSOR_FIFO_MAX          1
#define SENSOR_HUMI_FIFO_MAX     SENSOR_FIFO_MAX
#define SENSOR_TEMP_FIFO_MAX     SENSOR_FIFO_MAX

static char *const dht_model_table[] = 
{
    "dht11", 
    "dht12", 
    "dht21", 
    "dht22"
};

RT_WEAK void rt_hw_us_delay(rt_uint32_t us)
{
    rt_uint32_t delta;

    us = us * (SysTick->LOAD / (1000000 / RT_TICK_PER_SECOND));
    delta = SysTick->VAL;

    while (delta - SysTick->VAL < us) continue;
}

/**
 * This function will read a bit from sensor.
 *
 * @param pin  the pin of Dout
 *
 * @return the bit value
 */
static uint8_t _dht_read_bit(const rt_base_t pin)
{
    uint8_t retry = 0;

    while(rt_pin_read(pin) && retry < DHTxx_REPLY_TIME)
    {
        retry++;
        rt_hw_us_delay(1);
    }

    retry = 0;
    while(!rt_pin_read(pin) && retry < DHTxx_REPLY_TIME)
    {
        retry++;
        rt_hw_us_delay(1);
    }

    rt_hw_us_delay(MEASURE_TIME);
    
    return rt_pin_read(pin);
}

/**
 * This function will read a byte from sensor.
 *
 * @param pin  the pin of Dout
 *
 * @return the byte
 */
static uint8_t _dht_read_byte(const rt_base_t pin)
{
    uint8_t i, byte = 0;

    for(i=0; i<8; i++)
    {
        byte <<= 1;
        byte |= _dht_read_bit(pin);
    }

    return byte;
}

/**
 * This function will read and update data array.
 *
 * @param sensor   the sensor device to be operated
 * @param data     read data
 *
 * @return RT_TRUE if read successfully, otherwise return RT_FALSE.
 */
static rt_bool_t _dht_read(struct rt_sensor_device *sensor, rt_uint8_t data[])
{
    RT_ASSERT(data);

    rt_base_t  pin = (rt_base_t)sensor->config.intf.user_data;
    rt_uint8_t type = DHT_TYPE;

    uint8_t i, retry = 0, sum = 0;

#ifdef PKG_USING_DHTXX_INTERRUPT_DISABLE
    rt_base_t level;
#endif

    /* Reset data buffer */
    rt_memset(data, 0, DHT_DATA_SIZE);

    /* MCU request sampling */
    rt_pin_mode(pin, PIN_MODE_OUTPUT);
    rt_pin_write(pin, PIN_LOW);

    if (type == DHT11 || type == DHT12) {
        rt_thread_mdelay(DHT1x_BEGIN_TIME);        /* Tbe */
    } else {
        rt_thread_mdelay(DHT2x_BEGIN_TIME);
    }

#ifdef PKG_USING_DHTXX_INTERRUPT_DISABLE
    level = rt_hw_interrupt_disable();
#endif

    rt_pin_mode(pin, PIN_MODE_INPUT_PULLUP);
    rt_hw_us_delay(DHTxx_PULL_TIME);               /* Tgo */

    /* Waiting for sensor reply */
    while (rt_pin_read(pin) && retry < DHTxx_REPLY_TIME)
    {
        retry++;
        rt_hw_us_delay(1);                         /* Trel */
    }
    if(retry >= DHTxx_REPLY_TIME)
    {
        LOG_D("sensor reply timeout on low level");
        return RT_FALSE;
    }

    retry = 0;
    while (!rt_pin_read(pin) && retry < DHTxx_REPLY_TIME)
    {
        retry++;
        rt_hw_us_delay(1);                         /* Treh */
    };
    if(retry >= DHTxx_REPLY_TIME)
    {
        LOG_D("sensor reply timeout on high level");
        return RT_FALSE;
    }

    /* Read data */
    for(i=0; i<DHT_DATA_SIZE; i++)
    {
        data[i] = _dht_read_byte(pin);
    }

#ifdef PKG_USING_DHTXX_INTERRUPT_DISABLE
    rt_hw_interrupt_enable(level);
#endif

    /* Checksum */
    for(i=0; i<DHT_DATA_SIZE-1; i++)
    {
        sum += data[i];
    }
    if(sum != data[4])
    {
        LOG_D("checksum error");
        return RT_FALSE;
    }

    return RT_TRUE;
}

/**
 * This function will get the humidity from dhtxx sensor.
 *
 * @param sensor   the sensor device to be operated
 * @param raw_data raw data from sensor
 *
 * @return the humidity value
 */
static rt_int32_t _dht_get_humidity(struct rt_sensor_device *sensor, rt_uint8_t raw_data[])
{
    RT_ASSERT(raw_data);

    rt_int32_t humi = 0;

    switch (DHT_TYPE)
    {
    case DHT11:
    case DHT12:
        humi = raw_data[0] * 10 + raw_data[1];
        break;
    case DHT21:
    case DHT22:
        humi = (raw_data[0] << 8) + raw_data[1];
        break;
    default:
        break;
    }

    return humi;
}

/**
 * This function will get the temperature from dhtxx sensor.
 *
 * @param sensor   the sensor device to be operated
 * @param raw_data raw data from sensor
 *
 * @return the temperature value
 */
static rt_int32_t _dht_get_temperature(struct rt_sensor_device *sensor, rt_uint8_t raw_data[])
{
    RT_ASSERT(raw_data);

    rt_int32_t temp = 0;

    switch (DHT_TYPE)
    {
    case DHT11:
    case DHT12:
        temp = raw_data[2] * 10 + (raw_data[3] & 0x7f);
        if(raw_data[3] & 0x80) {
            temp = -temp;
        }
        break;
    case DHT21:
    case DHT22:
        temp = ((raw_data[2] & 0x7f) << 8) + raw_data[3];
        if(raw_data[2] & 0x80) {
            temp = -temp;
        }
        break;
    default:
        break;
    }

    return temp;
}

static rt_size_t _dht_polling_get_data(struct rt_sensor_device *sensor, void *buf)
{
    struct rt_sensor_data *sensor_data = buf;

    rt_uint8_t raw_data[DHT_DATA_SIZE] = {0};
    if (RT_TRUE != _dht_read(sensor, raw_data))
    {
        LOG_D("Can not read from %s", sensor->info.model);
        return 0;
    }
    rt_uint32_t timestamp = rt_sensor_get_ts();
    rt_int32_t temp = _dht_get_temperature(sensor, raw_data);
    rt_int32_t humi = _dht_get_humidity(sensor, raw_data);

    if (temp < SENSOR_TEMP_RANGE_MIN || temp > SENSOR_TEMP_RANGE_MAX || 
        humi < SENSOR_HUMI_RANGE_MIN || humi > SENSOR_HUMI_RANGE_MAX )
    {
        LOG_D("Data out of range");
        return 0;
    }

    if (sensor->info.type == RT_SENSOR_CLASS_HUMI)
    {
        sensor_data->type = RT_SENSOR_CLASS_HUMI;
        sensor_data->data.humi = humi;
        sensor_data->timestamp = timestamp;

        struct rt_sensor_data *partner_data = (struct rt_sensor_data *)sensor->module->sen[1]->data_buf;
        if (partner_data)
        {
            partner_data->type = RT_SENSOR_CLASS_TEMP;
            partner_data->data.temp = temp;
            partner_data->timestamp = timestamp;
            sensor->module->sen[1]->data_len = sizeof(struct rt_sensor_data);
        }
    }
    else if (sensor->info.type == RT_SENSOR_CLASS_TEMP)
    {
        sensor_data->type = RT_SENSOR_CLASS_TEMP;
        sensor_data->data.temp = temp;
        sensor_data->timestamp = timestamp;

        struct rt_sensor_data *partner_data = (struct rt_sensor_data *)sensor->module->sen[0]->data_buf;
        if (partner_data)
        {
            partner_data->type = RT_SENSOR_CLASS_HUMI;
            partner_data->data.humi = humi;
            partner_data->timestamp = timestamp;
            sensor->module->sen[0]->data_len = sizeof(struct rt_sensor_data);
        }
    }

    return 1;
}

static rt_size_t dht_fetch_data(struct rt_sensor_device *sensor, void *buf, rt_size_t len)
{
    if (sensor->config.mode == RT_SENSOR_MODE_POLLING)
    {
        return _dht_polling_get_data(sensor, buf);
    }
    else
        return 0;
}

static rt_err_t dht_control(struct rt_sensor_device *sensor, int cmd, void *args)
{
    rt_err_t result = RT_EOK;

    switch (cmd)
    {
    case RT_SENSOR_CTRL_GET_ID:
        break;
    case RT_SENSOR_CTRL_SET_MODE:
        sensor->config.mode = (rt_uint32_t)args & 0xFF;
        break;
    case RT_SENSOR_CTRL_SET_RANGE:
        break;
    case RT_SENSOR_CTRL_SET_ODR:
        break;
    case RT_SENSOR_CTRL_SET_POWER:
        break;
    case RT_SENSOR_CTRL_SELF_TEST:
        break;
    default:
        break;
    }

    return result;
}

static struct rt_sensor_ops sensor_ops =
{
    dht_fetch_data,
    dht_control
};

/**
 * This function will init dhtxx sensor device.
 *
 * @param intf  interface 
 *
 * @return RT_EOK
 */
static int sensor_init(rt_base_t pin)
{
    rt_pin_mode(pin, PIN_MODE_INPUT_PULLUP);

    return RT_EOK;
}

/**
 * Call function rt_hw_dht_init for initial and register a dhtxx sensor.
 *
 * @param name  the name will be register into device framework
 * @param cfg   sensor config
 *
 * @return the result
 */
rt_err_t rt_hw_dht_init(const char *name, struct rt_sensor_config *cfg)
{
    int result;
    rt_sensor_t sensor_temp = RT_NULL, sensor_humi = RT_NULL;
    struct rt_sensor_module *module = RT_NULL;

    if (sensor_init((rt_base_t)cfg->intf.user_data) != RT_EOK)
    {
        LOG_E("dhtxx sensor init failed");
        result = -RT_ERROR;
        goto __exit;
    }
    
    module = rt_calloc(1, sizeof(struct rt_sensor_module));
    if (module == RT_NULL)
    {
        result = -RT_ENOMEM;
        goto __exit;
    }

    /* humidity sensor register */
    {
        sensor_humi = rt_calloc(1, sizeof(struct rt_sensor_device));
        if (sensor_humi == RT_NULL)
        {
            result = -RT_ENOMEM;
            goto __exit;
        }

        sensor_humi->info.type       = RT_SENSOR_CLASS_HUMI;
        sensor_humi->info.vendor     = RT_SENSOR_VENDOR_ASAIR;
        sensor_humi->info.model      = dht_model_table[DHT_TYPE];
        sensor_humi->info.unit       = RT_SENSOR_UNIT_PERMILLAGE;
        sensor_humi->info.intf_type  = RT_SENSOR_INTF_ONEWIRE;
        sensor_humi->info.range_max  = SENSOR_HUMI_RANGE_MAX;
        sensor_humi->info.range_min  = SENSOR_HUMI_RANGE_MIN;
        sensor_humi->info.period_min = SENSOR_HUMI_PERIOD_MIN;
        sensor_humi->info.fifo_max   = SENSOR_HUMI_FIFO_MAX;
        sensor_humi->data_len        = 0;

        rt_memcpy(&sensor_humi->config, cfg, sizeof(struct rt_sensor_config));
        sensor_humi->ops = &sensor_ops;
        sensor_humi->module = module;
        
        result = rt_hw_sensor_register(sensor_humi, name, RT_DEVICE_FLAG_RDWR, RT_NULL);
        if (result != RT_EOK)
        {
            LOG_E("device register err code: %d", result);
            result = -RT_ERROR;
            goto __exit;
        }
    }

    /* temperature sensor register */
    {
        sensor_temp = rt_calloc(1, sizeof(struct rt_sensor_device));
        if (sensor_temp == RT_NULL)
        {
            result = -RT_ENOMEM;
            goto __exit;
        }

        sensor_temp->info.type       = RT_SENSOR_CLASS_TEMP;
        sensor_temp->info.vendor     = RT_SENSOR_VENDOR_ASAIR;
        sensor_temp->info.model      = dht_model_table[DHT_TYPE];
        sensor_temp->info.unit       = RT_SENSOR_UNIT_DCELSIUS;
        sensor_temp->info.intf_type  = RT_SENSOR_INTF_ONEWIRE;
        sensor_temp->info.range_max  = SENSOR_TEMP_RANGE_MAX;
        sensor_temp->info.range_min  = SENSOR_TEMP_RANGE_MIN;
        sensor_temp->info.period_min = SENSOR_TEMP_PERIOD_MIN;
        sensor_temp->info.fifo_max   = SENSOR_TEMP_FIFO_MAX;
        sensor_temp->data_len        = 0;

        rt_memcpy(&sensor_temp->config, cfg, sizeof(struct rt_sensor_config));
        sensor_temp->ops = &sensor_ops;
        sensor_temp->module = module;

        result = rt_hw_sensor_register(sensor_temp, name, RT_DEVICE_FLAG_RDWR, RT_NULL);
        if (result != RT_EOK)
        {
            LOG_E("device register err code: %d", result);
            result = -RT_ERROR;
            goto __exit;
        }
    }

    module->sen[0] = sensor_humi;
    module->sen[1] = sensor_temp;
    module->sen_num = 2;
    
    LOG_D("sensor init success");
    
    return RT_EOK;
    
__exit:
    if(sensor_humi) 
    {
        if(sensor_humi->data_buf)
            rt_free(sensor_humi->data_buf);

        rt_free(sensor_humi);
    }
    if(sensor_temp) 
    {
        if(sensor_temp->data_buf)
            rt_free(sensor_temp->data_buf);

        rt_free(sensor_temp);
    }
    if (module)
        rt_free(module);

    return result;
}

```

2、此库包含读取I2C信息，解调，添加CMD读取命令`cat_dhtxx`


关键打印代码以及自行校准两项参数

```cpp
if(dht_read(sensor)) {

        rt_int32_t temp = dht_get_temperature(sensor);
        rt_int32_t humi = dht_get_humidity(sensor);

        rt_kprintf("Temp: %d.%d 'C,  Humi: %d '% \n", temp/10, temp%10, humi/10);
    }
```

3、main.c文件在re_gen文件夹下，主程序围绕“hal_entry();”函数（在src文件夹），这些默认不变


# 4. 下载验证
1、编译重构

![在这里插入图片描述](https://img-blog.csdnimg.cn/2a01bda5fe554ce9aed461043ef78b0b.png)


编译成功

2、下载程序
![在这里插入图片描述](https://img-blog.csdnimg.cn/a27e862c080146fba6bf5b86c245dcdb.png)


下载成功


3、CMD串口调试

![在这里插入图片描述](https://img-blog.csdnimg.cn/181227ee2ed64ef2801477ece50cf41c.png)
然后板载复位，初始化成功，输入`cat_dhtxx`命令，开始串口打印温湿度显示！🎉🎉🎉
效果如下
![在这里插入图片描述](https://img-blog.csdnimg.cn/8497acb2a3b34e35848b6743cea380ed.png)


这样我们就可以天马行空啦!![请添加图片描述](https://img-blog.csdnimg.cn/92099d4d054b4b2cbd39b95719739a90.gif)

参考文献；
[【基于 RT-Thread Studio的CPK-RA6M4 开发板环境搭建】](https://blog.csdn.net/vor234/article/details/125634313)
