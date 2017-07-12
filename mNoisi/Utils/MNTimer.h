//
//  MNTimar.h
//  mNoisi
//
//  Created by yan on 2017/07/12.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MNTimer;

@protocol MNTimerDelegate <NSObject>

- (void)timerDidTip:(MNTimer *)timer;

@optional
- (void)timerDidFinish:(MNTimer *)timer;

@end

@interface MNTimer : NSObject

@property (nonatomic, assign, readonly) BOOL isPaused;
@property (nonatomic, assign, readonly) BOOL isStarted;
@property (nonatomic, assign, readonly) NSTimeInterval spentTime;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, weak) id<MNTimerDelegate> delegate;

- (void)start;
- (void)pause;
- (void)resume;
- (void)stop;

@end
