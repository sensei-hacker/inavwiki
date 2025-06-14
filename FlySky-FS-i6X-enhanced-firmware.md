/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2025 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "usart.h"
#include "tim.h"
#include "gpio.h"
#include <string.h>
#include <math.h>

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */


#include "main.h"
#include "usart.h"
#include "tim.h"
#include "gpio.h"
#include <string.h>
#include <math.h>
#include <stdlib.h>

#define SERVO_MIN 1000
#define SERVO_MAX 2000
#define MOTOR_MIN 1000
#define MOTOR_MAX 2000
#define PI 3.14159265

// GPS Ð±ÑÑÐµÑ
uint8_t gpsBuffer[100];
uint8_t gpsDataReady = 0;

// GPS ÐºÐ¾Ð¾ÑÐ´Ð¸Ð½Ð°ÑÐ¸
float currentLat = 0.0f, currentLon = 0.0f;
float targetLat = 50.4501f, targetLon = 30.5234f; // ÐÐ¸ÑÐ² Ð´Ð»Ñ Ð¿ÑÐ¸ÐºÐ»Ð°Ð´Ñ

// PPM Ð·Ð¼ÑÐ½Ð½Ñ
volatile uint16_t ppm_channels[8];
volatile uint8_t ppm_index = 0;

// --- ÐÐ±ÑÐ¾Ð±ÐºÐ° ÑÐ°Ð¹Ð¼ÐµÑÐ° PPM ---
void HAL_TIM_IC_CaptureCallback(TIM_HandleTypeDef *htim) {
    static uint32_t last_time = 0;
    if (htim->Instance == TIM2) {
        uint32_t now = HAL_TIM_ReadCapturedValue(htim, TIM_CHANNEL_1);
        uint32_t diff = (now >= last_time) ? (now - last_time) : (0xFFFF - last_time + now);
        last_time = now;

        if (diff > 3000) {
            ppm_index = 0; // sync
        } else if (ppm_index < 8) {
            ppm_channels[ppm_index++] = diff;
        }
    }
}

// --- ÐÐ±ÑÐ¾Ð±ÐºÐ° UART GPS ---
void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart) {
    if (huart->Instance == USART1) {
        if (strstr((char*)gpsBuffer, "$GNGGA") != NULL || strstr((char*)gpsBuffer, "$GPGGA") != NULL) {
            // ÐÐ°ÑÑÐ¸Ð½Ð³ GGA (Ð¿ÑÐ¾ÑÑÐ¸Ð¹)
            char* token = strtok((char*)gpsBuffer, ",");
            int field = 0;
            while (token != NULL) {
                if (field == 2) currentLat = atof(token) / 100.0f;
                if (field == 4) currentLon = atof(token) / 100.0f;
                token = strtok(NULL, ",");
                field++;
            }
        }
        gpsDataReady = 1;
        HAL_UART_Receive_IT(&huart1, gpsBuffer, sizeof(gpsBuffer));
    }
}

// --- Ð¤ÑÐ½ÐºÑÑÑ Ð´Ð»Ñ ÐºÑÑÑÑ ÑÐ° Ð²ÑÐ´ÑÑÐ°Ð½Ñ ---
float calculateDistance(float lat1, float lon1, float lat2, float lon2) {
    float dLat = (lat2 - lat1) * PI / 180.0f;
    float dLon = (lon2 - lon1) * PI / 180.0f;
    float a = sin(dLat / 2) * sin(dLat / 2) +
              cos(lat1 * PI / 180.0f) * cos(lat2 * PI / 180.0f) *
              sin(dLon / 2) * sin(dLon / 2);
    float c = 2 * atan2(sqrt(a), sqrt(1 - a));
    float R = 6371000.0f;
    return R * c;
}

float calculateBearing(float lat1, float lon1, float lat2, float lon2) {
    float dLon = (lon2 - lon1) * PI / 180.0f;
    lat1 = lat1 * PI / 180.0f;
    lat2 = lat2 * PI / 180.0f;

    float y = sin(dLon) * cos(lat2);
    float x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    float bearing = atan2(y, x) * 180.0f / PI;
    return fmod((bearing + 360.0f), 360.0f);
}

// --- ÐÐµÑÑÐ²Ð°Ð½Ð½Ñ ---
void set_servo_angle(uint16_t pwm_us) {
    if (pwm_us < SERVO_MIN) pwm_us = SERVO_MIN;
    if (pwm_us > SERVO_MAX) pwm_us = SERVO_MAX;
    __HAL_TIM_SET_COMPARE(&htim3, TIM_CHANNEL_1, pwm_us);
}

void set_motor_throttle(uint16_t pwm_us) {
    if (pwm_us < MOTOR_MIN) pwm_us = MOTOR_MIN;
    if (pwm_us > MOTOR_MAX) pwm_us = MOTOR_MAX;
    __HAL_TIM_SET_COMPARE(&htim3, TIM_CHANNEL_2, pwm_us);
}

int main(void) {
    HAL_Init();
    SystemClock_Config();
    MX_GPIO_Init();
    MX_USART1_UART_Init();
    MX_TIM2_Init();
    MX_TIM3_Init();

    HAL_TIM_IC_Start_IT(&htim2, TIM_CHANNEL_1);
    HAL_TIM_PWM_Start(&htim3, TIM_CHANNEL_1);
    HAL_TIM_PWM_Start(&htim3, TIM_CHANNEL_2);

    HAL_UART_Receive_IT(&huart1, gpsBuffer, sizeof(gpsBuffer));

    while (1) {
        float distance = calculateDistance(currentLat, currentLon, targetLat, targetLon);
        float bearing = calculateBearing(currentLat, currentLon, targetLat, targetLon);

        if (ppm_channels[4] > 1500) { // Ð°Ð²ÑÐ¾Ð¿ÑÐ»Ð¾Ñ ÑÐ²ÑÐ¼ÐºÐ½ÐµÐ½Ð¸Ð¹
            float current_heading = 0.0f; // GPS-ÐºÑÑÑÑ Ð½ÐµÐ¼Ð° â Ð¾ÑÑÐ½Ð¸ÑÐ¸ Ð·Ð¼ÑÐ½Ð¾Ñ ÐºÐ¾Ð¾ÑÐ´Ð¸Ð½Ð°Ñ (Ð¼Ð¾Ð¶Ð½Ð° Ð´Ð¾Ð´Ð°ÑÐ¸)
            float error = bearing - current_heading;
            if (error > 180) error -= 360;
            if (error < -180) error += 360;

            uint16_t servo_pwm = 1500 + (int)(error * 3.0f);
            set_servo_angle(servo_pwm);

            if (distance > 5) {
                set_motor_throttle(1600); // ÑÑÑ Ð²Ð¿ÐµÑÐµÐ´
            } else {
                set_motor_throttle(1000); // ÑÑÐ¾Ð¿
            }
        } else {
            // Ð ÑÑÐ½Ðµ ÐºÐµÑÑÐ²Ð°Ð½Ð½Ñ
            set_servo_angle(ppm_channels[0]);
            set_motor_throttle(ppm_channels[1]);
        }

        HAL_Delay(20);
    }
}

// --- Ð¡Ð¸ÑÑÐµÐ¼Ð½Ð° ÑÑÐ½ÐºÑÑÑ ÑÐ°ÐºÑÑÐ²Ð°Ð½Ð½Ñ ---
void SystemClock_Config(void) {
    RCC_OscInitTypeDef RCC_OscInitStruct = {0};
    RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

    __HAL_RCC_PWR_CLK_ENABLE();
    __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE2);

    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
    RCC_OscInitStruct.HSEState = RCC_HSE_ON;
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
    RCC_OscInitStruct.PLL.PLLM = 8;
    RCC_OscInitStruct.PLL.PLLN = 336;
    RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV4;
    RCC_OscInitStruct.PLL.PLLQ = 7;
    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK) {
        Error_Handler();
    }

    RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
    RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
    RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_2) != HAL_OK) {
        Error_Handler();
    }
}

void Error_Handler(void) {
    __disable_irq();
    while (1) {
        // ÐÐ±ÑÐ¾Ð±ÐºÐ° Ð¿Ð¾Ð¼Ð¸Ð»ÐºÐ¸
    }
}



#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
