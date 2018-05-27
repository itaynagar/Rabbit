//
//  AfterSwitchToOnMassageController.h
//  Rabbit
//
//  Created by Moveo Software on 21/06/2016.
//  Copyright © 2016 Team Red I. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AfterProtocol <NSObject>

- (void)okPress;

@end

@interface AfterSwitchToOnMassageController : UIViewController
{
    id <AfterProtocol> _delegate;
}

@property (nonatomic, strong) id _delegate;

@property (weak, nonatomic) IBOutlet UILabel *nowYourLabel;
@property (weak, nonatomic) IBOutlet UILabel *turnOffLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

- (IBAction)okAction:(id)sender;

@end
