//
//  AfterSwitchToOnMassageController.m
//  Rabbit
//
//  Created by Moveo Software on 21/06/2016.
//  Copyright © 2016 Team Red I. All rights reserved.
//

#import "AfterSwitchToOnMassageController.h"

@interface AfterSwitchToOnMassageController ()

@end

@implementation AfterSwitchToOnMassageController

@synthesize _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initViews];
}

- (void)initViews
{
    _okButton.layer.cornerRadius = 3.0;
    _okButton.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)okAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(okPress)]) {
        [_delegate okPress];
    }
}

@end
