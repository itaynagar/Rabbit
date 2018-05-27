//
//  EnterDetailsController.m
//  Rabbit
//
//  Created by Moveo Software on 23/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import "EnterDetailsController.h"
#import "SwitchToOnController.h"

@interface EnterDetailsController ()
@property NSArray *marriageStatuses;
@end

@implementation EnterDetailsController
{
    BOOL keyboardOpen;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        _marriageStatuses = @[@"Don't ask", @"Single", @"Married" ,@"Divorced"];
    }
    return self;
}

#pragma mark - View Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 1.25)];
    [self initViews];
    typeof(self) __weak weakSelf = self;
    [self.view addKeyboardPanningWithFrameBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        if (opening) {
            [weakSelf.scrollView setContentOffset:CGPointMake(0, keyboardFrameInView.origin.y + 40)];
            keyboardOpen = YES;
        }
        if (closing) {
            keyboardOpen = NO;
            [weakSelf.scrollView setContentOffset:CGPointMake(0, 0)];
        }
        
        
    } constraintBasedActionHandler:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_hideBack) {
        _backButton.hidden = YES;
    } else {
        [self setPageDetails:[[RealmManager getRealmManager]getMyUser]];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_marritalStatusPicker selectItem:[self translateToLimitlessScrollerValue:1] animated:NO];
}

- (void)initViews
{
    [self setMaritalTypePicker];
    _cameraButton.layer.cornerRadius = _cameraButton.frame.size.width/2;
    _cameraButton.clipsToBounds = YES;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cameraAction)];
    [_cameraButton addGestureRecognizer:imageTap];
    _facebookButton.layer.cornerRadius = 10;
    _userNameTF.layer.cornerRadius = 10;
    _descriptionTextView.layer.borderColor =  [[UIColor colorWithRed:1 green:213.f/255 blue:189.f/255 alpha:1.0f] CGColor];
    _descriptionTextView.layer.borderWidth =2.0f;
    _descriptionTextView.placeholder = @"Say something...";
    _descriptionTextView.textContainerInset = UIEdgeInsetsMake(5, 10, 5, 10);
    _descriptionTextView.layer.cornerRadius = 10.0f;
}

- (NSUInteger)translateToLimitlessScrollerValue:(int)realValue
{
    return realValue+[_marriageStatuses count]*(ENDLESS_SCROLLER_SIMULATION/2);
}

- (void)setMaritalTypePicker
{
    UIColor *textColor = [UIColor colorWithRed:1 green:(CGFloat) (171 / 255.0) blue:(CGFloat) (124 / 255.0) alpha:1];
    _marritalStatusPicker.delegate = self;
    _marritalStatusPicker.dataSource = self;
    _marritalStatusPicker.highlightedTextColor = textColor;
    _marritalStatusPicker.textColor   = textColor;
    _marritalStatusPicker.font = [UIFont systemFontOfSize:19.0];
    _marritalStatusPicker.highlightedFont = [UIFont systemFontOfSize:19.0];
    _marritalStatusPicker.interitemSpacing = 11.0f;
    _marritalStatusPicker.fisheyeFactor = 0.002f;
    [_marritalStatusPicker reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AKPickerView
- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)picker {
    return [self.marriageStatuses count]* ENDLESS_SCROLLER_SIMULATION;
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item {
    
    return [self getScrollElementAtIndex:item];
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    
}

- (NSString *)getScrollElementAtIndex:(NSInteger)index
{
    NSInteger ind = index% [self.marriageStatuses count];
    return (self.marriageStatuses)[ind];
}

#pragma mark - Actions

- (IBAction)facebookAction:(id)sender
{
    FacebookHelper *fbHelper = [[FacebookHelper alloc]initWithDelegate:self];
    [fbHelper logInAction:self];
}

- (IBAction)saveAction:(id)sender
{
    [self setUserAccordingToFields];
    ServerHandler *server = [[ServerHandler alloc]initWithDelegate:self];
    [server registerNewUser:[[RealmManager getRealmManager]getMyUser] andRegOrUp:YES];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didLogIn:(NSDictionary *)response
{
    RUser *me = [[RealmManager getRealmManager]getMyUser];
    [self setPageDetails:me];
}

- (void)setPageDetails:(RUser *)meUser
{
    _userNameTF.text = meUser.userFullName;
    [_userGender setOn:meUser.isMale];
    if (meUser.userAge) {
        [_ageSlider setValue:[meUser.userAge floatValue]];
        _ageValue.text = meUser.userAge;
    }
    NSURL *url = [NSURL URLWithString:meUser.userImageUrl];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [_cameraButton setImageWithURLRequest:imageRequest
                         placeholderImage:[UIImage imageNamed:@"camera_"]
                                  success:nil
                                  failure:nil];
}

- (IBAction)heightValueChange:(id)sender
{
    _height.text = [NSString stringWithFormat:@"%1.0fcm", _heightSlider.value];
}

- (IBAction)weightValueChange:(id)sender
{
    _weight.text = [NSString stringWithFormat:@"%1.0fkg", _weightSlider.value];
}

- (IBAction)ageValueChanged:(id)sender
{
    _ageValue.text = [NSString stringWithFormat:@"%1.0f", _ageSlider.value];
}

- (void)cameraAction
{
    [self takePicture];
}

- (void)takePicture
{
    //    NSString *title = @"\nTake photo";
    UIAlertController *view =   [UIAlertController alertControllerWithTitle:nil
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    
    //    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    //    [attrTitle addAttribute:NSFontAttributeName
    //                  value:[UIFont fontWithName:@"HelveticaNeue" size:24.0]  //[UIFont systemFontOfSize:20.0]
    //                  range:NSMakeRange(0, [title length])];
    //    [attrTitle addAttribute:NSForegroundColorAttributeName
    //                      value:[UIColor grayColor]
    //                      range:NSMakeRange(0, [title length])];
    //    [view setValue:attrTitle forKey:@"attributedTitle"];
    
    UIAlertAction *captureImage = [UIAlertAction
                                   actionWithTitle:@"Capture image"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //                        [view dismissViewControllerAnimated:YES completion:nil];
                                       [self capturePicture];
                                   }];
    UIAlertAction* selectImage = [UIAlertAction
                                  actionWithTitle:@"Select from gallery"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      //                        [view dismissViewControllerAnimated:YES completion:^(void){}];
                                      [self selectPicture];
                                  }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 //                        [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [view addAction:captureImage];
    [view addAction:selectImage];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}


- (void)capturePicture {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertController * uiAlertView=   [UIAlertController
                                      alertControllerWithTitle:@"uiAlertView"
                                      message:@"Camera device cannot be accessed"
                                      preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* cancelButton = [UIAlertAction
                                       actionWithTitle:[NSString stringWithFormat:@"Ok"]
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction * action)
                                       {
                                           //Handel your yes please button action here
                                           [uiAlertView dismissViewControllerAnimated:YES completion:nil];
                                           
                                       }];
        [uiAlertView addAction:cancelButton];
        [self presentViewController:uiAlertView animated:YES completion:nil];
        return;
    }
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing=YES;
    [self presentViewController:picker animated:YES completion:NULL];
}


-(void)selectPicture{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.delegate = self;
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing=YES;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)goToMainContorller
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    SwitchToOnController *switchToOnController = [storyboard instantiateViewControllerWithIdentifier:@"SwitchToOnController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:switchToOnController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)setUserAccordingToFields
{
    RUser *myUser = [[RUser alloc]init];
    if (myUser == nil) {
        myUser = [[RUser alloc]init];
    }
    if (_descriptionTextView.text.length > 0) {
        myUser.userDescription = _descriptionTextView.text;
    }
    if (_userNameTF.text.length > 0) {
        myUser.userFullName = _userNameTF.text;
    }
    myUser.userAge = [NSString stringWithFormat:@"%1.0f", _ageSlider.value];
    myUser.isMale = _userGender.isOn;
    myUser.lookingForABoy = _lookingForGender.isOn;
    myUser.relationshipStatus = (int)(_marritalStatusPicker.selectedItem%[self.marriageStatuses count])+1;
    myUser.userWeight = [NSString stringWithFormat:@"%1.0f", _weightSlider.value];
    myUser.userHeight = [NSString stringWithFormat:@"%1.0f", _heightSlider.value];
    NSLog(@"%@",myUser);
    [[RealmManager getRealmManager]updateMyUserWithName:myUser.userFullName andDescription:myUser.userDescription andAge:myUser.userAge andIsMale:myUser.isMale andLookingFor:myUser.lookingForABoy andRelationshipStatus:myUser.relationshipStatus andWeight:myUser.userWeight andHeight:myUser.userHeight];
}

# pragma mark - Server Delegates

- (void)didRegisterUser
{
     [self goToMainContorller];
}

- (void)didFailRegisterUser
{
    
}

#pragma mark UIImagePicker

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self setProfileImage:image];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setProfileImage:(UIImage *)image
{
//    _isImageUpdated = YES;
    //_originalImage = [self resizeImage:image];
    
//    _originalImage = [self centerCropImage:image];
//    [self setButtonImage];
//    [_cameraButton setBackgroundImage:image forState:UIControlStateNormal];
}

# pragma mark - Delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (keyboardOpen) {
        keyboardOpen = NO;
       [_descriptionTextView resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [_descriptionTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
