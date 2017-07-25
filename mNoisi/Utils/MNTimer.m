//
//  MNTimar.m
//  mNoisi
//
//  Created by yan on 2017/07/12.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

#import "MNTimer.h"

@interface MNTimer ()
{
    NSTimer *_timer;
    NSTimeInterval _interval;
    BOOL _paused;
    BOOL _start;
    CFTimeInterval _startTime;
    CFTimeInterval _resumeTime;
    CFTimeInterval _pauseTime;
    CFTimeInterval _remainTime;
    CFTimeInterval _spentTime;
}

@end

@implementation MNTimer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _interval = -1;
        _duration = -1;
        _paused = NO;
        _start = NO;
        _startTime = -1;
        _resumeTime = -1;
        _pauseTime = -1;
        _remainTime = -1;
        _spentTime = -1;
    }
    return self;
}

- (BOOL)isPaused
{
    return _paused;
}

- (BOOL)isStarted
{
    return _start;
}

- (void)start
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(_repeatCheck) userInfo:nil repeats:YES];
    _startTime = CFAbsoluteTimeGetCurrent();
    _spentTime = 0;
    _start = YES;
    _paused = NO;
}

- (void)pause
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_resume) object:nil];
    if (_start != YES || _paused != NO) {
        return;
    }

    _paused = YES;
    if (_resumeTime < 0) {
        _pauseTime = CFAbsoluteTimeGetCurrent();
        CFTimeInterval timeDiff = _pauseTime - _startTime;
        NSInteger times = (NSInteger) (timeDiff / _interval);
        _remainTime = timeDiff - _interval * times;
    } else {
        _pauseTime = CFAbsoluteTimeGetCurrent();
        _remainTime += (_pauseTime - _resumeTime);
    }
    [_timer invalidate];
    _timer = nil;
}

- (void)resume
{
    if (_start != YES || _paused != YES) {
        return;
    }
    _paused = NO;
    _resumeTime = CFAbsoluteTimeGetCurrent();
    CFTimeInterval afterTime = _interval - _remainTime;

    [self performSelector:@selector(_resume) withObject:nil afterDelay:afterTime];
}

- (void)stop
{
    [self _reset];
}


#pragma mark -  Private methods
- (void)_resume
{
    _remainTime = -1;
    _resumeTime = -1;
    _pauseTime = -1;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_interval
                                              target:self
                                            selector:@selector(_repeatCheck)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)_repeatCheck
{
    _spentTime += _interval;

    if ([_delegate respondsToSelector:@selector(timerDidTip:)]) {
        [_delegate timerDidTip:self];
    }

    if (_duration > 0) {
        if (_spentTime >= _duration) {
            // finish
            if ([_delegate respondsToSelector:@selector(timerDidFinish:)]) {
                [_delegate timerDidFinish:self];
            }

            [self _reset];
        }
    }
}

- (void)_reset
{
    [_timer invalidate];
    _timer = nil;
    _interval = -1;
    _duration = -1;
    _paused = NO;
    _start = NO;
    _startTime = -1;
    _resumeTime = -1;
    _pauseTime = -1;
    _remainTime = -1;
    _spentTime = -1;
}

@end
