//
//  DPGCDTimer.m
//  demo
//
//  Created by Andrew on 2017/8/15.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "DPGCDTimer.h"

@interface DPGCDTimer ()
{
    dispatch_source_t __block timer;
}

@end

@implementation DPGCDTimer

/**
 循环定时器（每秒循环一次）
 
 @param immediatelyCallBack 开启定时器时是否立即进行运行回调
 @param timerRunBlock 运行回调
 */
- (void)initTimerWithImmediatelyCallBack:(BOOL)immediatelyCallBack timerRunBlock:(TimerRunBlock)timerRunBlock
{
    [self crateTimerWithTimeDuration:0 interval:1 immediatelyCallBack:immediatelyCallBack runWithCountBlock:^(NSUInteger runTimes, NSUInteger currentTime) {
        if (timerRunBlock) {
            timerRunBlock(runTimes, currentTime);
        }
    }];
}

/**
 循环计时器
 
 @param interval 计时间隔
 @param immediatelyCallBack 开启定时器时是否立即进行运行回调
 @param timerRunBlock 运行回调
 */
- (void)initTimerWithInterval:(double)interval immediatelyCallBack:(BOOL)immediatelyCallBack timerRunBlock:(TimerRunBlock)timerRunBlock
{
    [self crateTimerWithTimeDuration:0 interval:interval immediatelyCallBack:immediatelyCallBack runWithCountBlock:^(NSUInteger runTimes, NSUInteger currentTime) {
        if (timerRunBlock) {
            timerRunBlock(runTimes, currentTime);
        }
    }];
}

/**
 倒计时计时器（每秒循环一次）
 
 @param timeDuration 倒计时时长
 @param immediatelyCallBack 开启定时器时是否立即进行运行回调
 @param timerRunBlock 运行回调
 */
- (void)initTimerWithTimeDuration:(double)timeDuration immediatelyCallBack:(BOOL)immediatelyCallBack timerRunBlock:(TimerRunBlock)timerRunBlock
{
    [self crateTimerWithTimeDuration:timeDuration interval:1 immediatelyCallBack:immediatelyCallBack runWithCountBlock:^(NSUInteger runTimes, NSUInteger currentTime) {
        if (timerRunBlock) {
            timerRunBlock(runTimes, currentTime);
        }
    }];
}

/**
 倒计时计时器
 
 @param timeDuration 倒计时时长
 @param interval 计时间隔
 @param immediatelyCallBack 开启定时器时是否立即进行运行回调
 @param timerRunBlock 运行回调
 */
- (void)initTimerWithTimeDuration:(double)timeDuration interval:(double)interval immediatelyCallBack:(BOOL)immediatelyCallBack timerRunBlock:(TimerRunBlock)timerRunBlock
{
    [self crateTimerWithTimeDuration:timeDuration interval:interval immediatelyCallBack:immediatelyCallBack runWithCountBlock:^(NSUInteger runTimes, NSUInteger currentTime) {
        if (timerRunBlock) {
            timerRunBlock(runTimes, currentTime);
        }
    }];
}


//停止
- (void)stopTimer
{
    if(timer){
        if (_isTimerPausing) {
            [self resumeTimer];
        }
        if (_isTimerRuning) {
            dispatch_source_cancel(timer);
            timer = nil;
            _isTimerRuning = NO;
            if (self.timerStopBlock) {
                self.timerStopBlock();
            }
        }
        
    }
}

//恢复
- (void)resumeTimer
{
    if(timer){
        if (!_isTimerRuning) {
            dispatch_resume(timer);
            _isTimerRuning = YES;
            _isTimerPausing = NO;
        }
    }
}

//暂停
- (void)suspendTimer
{
    if(timer){
        if (_isTimerRuning) {
            dispatch_suspend(timer);
            _isTimerRuning = NO;
            _isTimerPausing = YES;
        }
    }
}

#pragma privite
- (void)crateTimerWithTimeDuration:(double)timeDuration interval:(double)interval immediatelyCallBack:(BOOL)immediatelyCallBack runWithCountBlock:(TimerRunBlock)timerRunBlock
{
    if (!timer) {
        //创建定时器
        _isTimerRuning = YES;
        
        BOOL __block kImmediatelyCallBack = immediatelyCallBack;
        
        double __block kTimeDuration = timeDuration <= 0 ? HUGE_VAL : timeDuration;
        
        NSUInteger __block runTimes = 0;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),interval * NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(timer, ^{
            runTimes ++;
            if (kTimeDuration <= 0) {
                [self stopTimer];
            } else {
                kTimeDuration = kTimeDuration - interval;
                if (kImmediatelyCallBack) {
                    if (timerRunBlock) {
                        timerRunBlock(runTimes, kTimeDuration != INFINITY ?kTimeDuration:0);
                    }
                    if (self.timerRunBlock) {
                        self.timerRunBlock(runTimes, kTimeDuration != INFINITY ?kTimeDuration:0);
                    }
                    if (self.timerRunFloatBlock) {
                        self.timerRunFloatBlock(runTimes, kTimeDuration != INFINITY ?kTimeDuration:0);
                    }
                }
                kImmediatelyCallBack = YES;
            }
        });
        dispatch_resume(timer);
        
        if (self.timerStartBlock) {
            self.timerStartBlock();
        }
    }
}


@end
