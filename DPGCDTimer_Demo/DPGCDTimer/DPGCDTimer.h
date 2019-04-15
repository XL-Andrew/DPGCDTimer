//
//  DPGCDTimer.h
//  demo
//
//  Created by Andrew on 2017/8/15.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TimerStartBlock)(void);      //定时器开始回调
typedef void (^TimerRunBlock)(NSUInteger runTimes, NSUInteger currentTime);        //定时器运行回调
typedef void (^TimerRunFloatBlock)(NSUInteger runTimes, CGFloat currentTime);        //定时器运行回调
typedef void (^TimerStopBlock)(void);       //定时器结束计时回调

@interface DPGCDTimer : NSObject

@property (nonatomic, assign) BOOL isTimerRuning;                 //定时器是否正在运行

@property (nonatomic, assign) BOOL isTimerPausing;                //定时器是否正在暂停状态

@property (nonatomic, copy) TimerStartBlock timerStartBlock;

@property (nonatomic, copy) TimerStopBlock timerStopBlock;

@property (nonatomic, copy) TimerRunBlock timerRunBlock;

@property (nonatomic, copy) TimerRunFloatBlock timerRunFloatBlock;

/**
 循环定时器（每秒循环一次）
 
 @param immediatelyCallBack 开启定时器时是否立即进行运行回调
 @param timerRunBlock 运行回调
 */
- (void)initTimerWithImmediatelyCallBack:(BOOL)immediatelyCallBack timerRunBlock:(TimerRunBlock)timerRunBlock;

/**
 循环计时器
 
 @param interval 计时间隔
 @param immediatelyCallBack 开启定时器时是否立即进行运行回调
 @param timerRunBlock 运行回调
 */
- (void)initTimerWithInterval:(double)interval immediatelyCallBack:(BOOL)immediatelyCallBack timerRunBlock:(TimerRunBlock)timerRunBlock;

/**
 倒计时计时器（每秒循环一次）
 
 @param timeDuration 倒计时时长
 @param immediatelyCallBack 开启定时器时是否立即进行运行回调
 @param timerRunBlock 运行回调
 */
- (void)initTimerWithTimeDuration:(double)timeDuration immediatelyCallBack:(BOOL)immediatelyCallBack timerRunBlock:(TimerRunBlock)timerRunBlock;

/**
 倒计时计时器
 
 @param timeDuration 倒计时时长
 @param interval 计时间隔
 @param immediatelyCallBack 开启定时器时是否立即进行运行回调
 @param timerRunBlock 运行回调
 */
- (void)initTimerWithTimeDuration:(double)timeDuration interval:(double)interval immediatelyCallBack:(BOOL)immediatelyCallBack timerRunBlock:(TimerRunBlock)timerRunBlock;

/**
 *  定时器停止
 */
- (void)stopTimer;

/**
 *  定时器恢复
 */
- (void)resumeTimer;

/**
 *  定时器暂停
 */
- (void)suspendTimer;

@end

