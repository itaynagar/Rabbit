//
//  ViewController.m
//  Rabbit
//
//  Created by Moveo Software on 23/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import "FirstController.h"
#import "RealmManager.h"
#import "EnterPhoneController.h"
#import "SwitchToOnController.h"
#import "TutorialController.h"

@interface FirstController ()

@end

@implementation FirstController

#pragma mark - View Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([[RealmManager getRealmManager]getMyUser]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        SwitchToOnController *switchToOnController = [storyboard instantiateViewControllerWithIdentifier:@"SwitchToOnController"];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:switchToOnController];
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        [self goToEnterPhoneContorller];
    }
}

#pragma mark - Actions

- (void)goToEnterPhoneContorller
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    EnterPhoneController *enterPhoneController = [storyboard instantiateViewControllerWithIdentifier:@"EnterPhoneController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:enterPhoneController];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Others

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
