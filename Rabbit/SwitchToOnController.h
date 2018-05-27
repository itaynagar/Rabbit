//
//  SwitchToOnController.h
//  Rabbit
//
//  Created by Moveo Software on 26/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPickerView.h"
#import "MBSliderView.h"
#import <CoreLocation/CoreLocation.h>

@interface SwitchToOnController : UIViewController <AKPickerViewDataSource, AKPickerViewDelegate, MBSliderViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet AKPickerView *datesPicker;
@property (weak, nonatomic) IBOutlet MBSliderView *slideToOn;
@property (weak, nonatomic) IBOutlet UIImageView *slideBgImage;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
