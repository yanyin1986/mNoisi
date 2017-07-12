//
//  MNTimerViewController.h
//  mNoisi
//
//  Created by yan on 2017/07/12.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNTimerViewController;
@protocol MNTimerViewControllerDelegate <NSObject>

- (void)timerViewController:(MNTimerViewController *)viewController didChooseTime:(NSInteger)time;

@end

@interface MNTimerViewController : UIViewController

@property (nonatomic, weak) id<MNTimerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *times;
@property (nonatomic, strong) NSNumber *currentTime;

@end
