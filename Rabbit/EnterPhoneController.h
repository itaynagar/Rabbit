//
//  EnterPhoneController.h
//  Rabbit
//
//  Created by Moveo Software on 23/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleButtonWithBorder.h"
#import <CoreLocation/CoreLocation.h>

static NSString *const PHONE_PLACE_HOLDER = @"phone";

@interface EnterPhoneController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *countryCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIView *whyView;
@property (weak, nonatomic) IBOutlet UILabel *okLabel;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *whyBView;

- (IBAction)whyAction:(id)sender;
- (IBAction)dissmissWhyView:(id)sender;
- (IBAction)didPressDial:(CircleButtonWithBorder *)sender;

@end
