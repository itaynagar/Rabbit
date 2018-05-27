//
//  EnterDetailsController.h
//  Rabbit
//
//  Created by Moveo Software on 23/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPickerView.h"
#import "ANPopoverSlider.h"
#import "FacebookHelper.h"
#import <UIImageView+AFNetworking.h>
#import "RUser.h"
#import "RealmManager.h"
#import "MainController.h"
#import "ServerHandler.h"
#import "SZTextView.h"
#import "DAKeyboardControl.h"

static const int ENDLESS_SCROLLER_SIMULATION = 100;

@interface EnterDetailsController : UIViewController <AKPickerViewDataSource, AKPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UITextViewDelegate>

@property (nonatomic) BOOL hideBack;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//@property (weak, nonatomic) IBOutlet ANPopoverSlider *ageSlider;
@property (weak, nonatomic) IBOutlet UILabel *ageValue;
@property (weak, nonatomic) IBOutlet AKPickerView *marritalStatusPicker;
@property (weak, nonatomic) IBOutlet UISwitch *userGender;
@property (weak, nonatomic) IBOutlet UISwitch *lookingForGender;
@property (weak, nonatomic) IBOutlet UIImageView *cameraButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UISlider *ageSlider;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet SZTextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *weight;
@property (weak, nonatomic) IBOutlet UISlider *weightSlider;
@property (weak, nonatomic) IBOutlet UILabel *height;
@property (weak, nonatomic) IBOutlet UISlider *heightSlider;

- (IBAction)heightValueChange:(id)sender;
- (IBAction)weightValueChange:(id)sender;
- (IBAction)ageValueChanged:(id)sender;
- (IBAction)facebookAction:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)backAction:(id)sender;



@end
