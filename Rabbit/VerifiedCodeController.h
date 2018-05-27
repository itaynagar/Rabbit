//
//  VerifiedCodeController.h
//  Rabbit
//
//  Created by Moveo Software on 23/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleButtonWithBorder.h"

@interface VerifiedCodeController : UIViewController

@property (strong, nonatomic) NSArray *verificationDigits;
@property (strong, nonatomic) NSString *phoneNumber;

@property (weak, nonatomic) IBOutlet UITextField *digit1;
@property (weak, nonatomic) IBOutlet UITextField *digit2;
@property (weak, nonatomic) IBOutlet UITextField *digit3;
@property (weak, nonatomic) IBOutlet UITextField *digit4;

- (IBAction)backAction:(id)sender;
- (IBAction)dialPadPressed:(CircleButtonWithBorder *)sender;

@end
