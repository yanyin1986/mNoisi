//
//  MNTimerViewController.m
//  mNoisi
//
//  Created by yan on 2017/07/12.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

#import "MNTimerViewController.h"
#import "MNTimer.h"

@interface MNTimerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UIPickerView *timePicker;

@end

@implementation MNTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_times) {
        _times = @[ @5, @10, @15, @20, @30, @45, @60 ];
    }

    if (_currentTime) {
        NSInteger index = [_times indexOfObject:_currentTime];
        [_timePicker selectRow:index inComponent:0 animated:NO];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)comfirm:(id)sender
{
    NSInteger row = [_timePicker selectedRowInComponent:0];
    NSInteger time = [_times[row] integerValue];
    if ([_delegate respondsToSelector:@selector(timerViewController:didChooseTime:)]) {
        [_delegate timerViewController:self didChooseTime:time];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -  UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _times.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 60;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    int value = (int) [_times[row] integerValue];
    NSString *title = [NSString stringWithFormat:@"%d M", value];
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : UIColor.whiteColor};
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
    
}


@end
