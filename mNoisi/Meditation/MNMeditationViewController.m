//
//  MNMeditationViewController.m
//  mNoisi
//
//  Created by yanyin on 2017/07/15.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

#import "MNMeditationViewController.h"
#import "MNTimerViewController.h"
#import "mNoisi-Swift.h"

@interface MNMeditationViewController () <MNTimerViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *tip1Label;
@property (nonatomic, weak) IBOutlet UILabel *tip2Label;
@property (nonatomic, assign) NSInteger time;

@end

@implementation MNMeditationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTime:5];
}

- (void)setTime:(NSInteger)time
{
    _time = time;
    _tip2Label.text = [NSString stringWithFormat:@"%d M", (int)_time];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)timerButtonPressed:(id)sender
{
    MNTimerViewController *timerViewController = [[MNTimerViewController alloc] initWithNibName:@"MNTimerViewController" bundle:nil];
    timerViewController.times = @[@5, @10, @15, @20, @25, @30];
    timerViewController.currentTime = @(_time);
    timerViewController.delegate = self;
    [self.navigationController pushViewController:timerViewController animated:YES];
}

- (IBAction)startMeditation:(id)sender
{
    MNMeditationStartViewController *vc = [[MNMeditationStartViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -  MNTimerViewControllerDelegate
- (void)timerViewController:(MNTimerViewController *)viewController didChooseTime:(NSInteger)time
{
    [self setTime:time];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
