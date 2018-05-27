//
//  SwitchToOnController.m
//  Rabbit
//
//  Created by Moveo Software on 26/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import "SwitchToOnController.h"
#import "DateType.h"
#import "RUser.h"
#import <UIImageView+AFNetworking.h>
#import "RealmManager.h"
#import "AfterSwitchToOnMassageController.h"
#import "MainController.h"
#import "ServerHandler.h"
#import "SignalRManager.h"

@interface SwitchToOnController ()
@property NSArray *dateTypes;
@end

@implementation SwitchToOnController
{
    AfterSwitchToOnMassageController *afterController;
    CLLocationManager* locationManager;
    CLLocation* currentLocation;
    BOOL updated;
    BOOL gotServerOk;
    int mainMeetingId;
    int mainMeetingType;
    SignalRManager *signalMan;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    
    if ([[RealmManager getRealmManager]getMyUser]){
        [_titleLabel setText:[[RealmManager getRealmManager]getMyUserTitleWithAge]];
    }
    
    [self setDateStatusPickerView];
    [_slideToOn setText:@"Switch To ON"]; // set the label text
    [_slideToOn setLabelColor:[UIColor blackColor]]; // set custom label color
    [_slideToOn setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setProfilePics];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)setUpLocationUpdate
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}

- (void)setProfilePics
{
    _profilePic.layer.cornerRadius = _profilePic.frame.size.width/2;
    _profilePic.clipsToBounds = YES;
    RUser *user = [[RealmManager getRealmManager]getMyUser];
    NSURL *url = [NSURL URLWithString:user.userImageUrl];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    [_bgImage setImageWithURLRequest:imageRequest
                  placeholderImage:[UIImage imageNamed:@"image_placeholder.png"]
                           success:nil
                           failure:nil];
    
    [_profilePic setImageWithURLRequest:imageRequest
                    placeholderImage:[UIImage imageNamed:@"image_placeholder.png"]
                             success:nil
                             failure:nil];
}

- (void)setDateStatusPickerView
{
    NSMutableArray *dateTypesArray = [[NSMutableArray alloc]init];
    [dateTypesArray addObject:@"Date"];
    [dateTypesArray addObject:@"Fun"];
    [dateTypesArray addObject:@"Hangout"];
    [dateTypesArray addObject:@"Affair"];
    [dateTypesArray addObject:@"Quickie"];
    _dateTypes = [NSMutableArray arrayWithArray:dateTypesArray];
    
    _datesPicker.delegate = self;
    _datesPicker.dataSource = self;
    _datesPicker.highlightedTextColor = [UIColor whiteColor];
    _datesPicker.textColor = [UIColor whiteColor];
    _datesPicker.font = [UIFont systemFontOfSize:22.0];
    _datesPicker.highlightedFont = [UIFont systemFontOfSize:26.0];
    _datesPicker.interitemSpacing = 28.0f;
    _datesPicker.fisheyeFactor = 0.002f;
    [_datesPicker reloadData];
}

- (void)switchToOnInServer
{
    signalMan = [SignalRManager getSignalRManager];
    signalMan._delegate = self;
//    ServerHandler *server = [[ServerHandler alloc]initWithDelegate:self];
//    [server switchToOn:[[RealmManager getRealmManager]getMyUser] andMeetType:newMeetType andLat:currentLocation.coordinate.latitude andLong:currentLocation.coordinate.longitude];
}

- (void)goToMainController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    MainController *mainController = [storyboard instantiateViewControllerWithIdentifier:@"MainController"];
    mainController.currentLocation = currentLocation;
    mainController.meetingId = mainMeetingId;
    mainController.meetingType = mainMeetingType;
    signalMan._delegate = mainController;
    [signalMan findMeetingsRequest];
    [self.navigationController pushViewController:mainController animated:YES];
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)location
          fromLocation:(CLLocation *)oldLocation
{
    if (location == nil)
        return;
    
    if (!updated) {
        updated = YES;
        currentLocation = location;
        [self switchToOnInServer];
        [locationManager stopUpdatingLocation];
    }
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - Server

- (void)didConnect
{
    int newMeetType = (int)(_datesPicker.selectedItem%[_dateTypes count])+1;
    mainMeetingType = newMeetType;
    NSLog(@"%d",newMeetType);
    [signalMan sendJoinRequest:[[RealmManager getRealmManager]getMyUser] andMeetType:newMeetType andLat:currentLocation.coordinate.latitude andLong:currentLocation.coordinate.longitude];
    gotServerOk = YES;
    if (afterController == nil) {
        [signalMan findMeetingsRequest];
        [self goToMainController];
    }
}

- (void)didSwitchToOnWithMeetingId:(int)meetingId
{
    mainMeetingId = meetingId;
    gotServerOk = YES;
    if (afterController == nil) {
        [self goToMainController];
    }
}

- (void)didFailSwitchToOn
{
    
}

#pragma mark - HorizontalPickerView Delegate Methods

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    return [self getScrollElementAtIndex:item];
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{}

- (NSString *)getScrollElementAtIndex:(NSInteger)index {
    NSInteger ind = index% [self.dateTypes count];
    return (self.dateTypes)[ind];
}

#pragma mark - HorizontalPickerView DataSource Methods
- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)picker {
    return [self.dateTypes count]* 100;
}

- (void) sliderDidSlide:(MBSliderView *)slideView
{
    
    
    [self setUpLocationUpdate];
    afterController = [[AfterSwitchToOnMassageController alloc]init];
    afterController._delegate = self;
    afterController.view.frame = self.view.frame;
    afterController.view.alpha = 0.0;
    [self addChildViewController:afterController];
    [self.view addSubview:afterController.view];
    [UIView animateWithDuration:0.3 animations:^{
        afterController.view.alpha = 1.0;
    }];
}

- (void)okPress
{
    [UIView animateWithDuration:0.3 animations:^{
    } completion:^(BOOL finished) {
        if (finished) {
            if (gotServerOk) {
                
                [self goToMainController];
                [self performSelector:@selector(dissmissAfterPush) withObject:nil afterDelay:2.0];
            } else {
                [self dissmissAfterPush];
            }
        }
    }];
}

- (void)dissmissAfterPush
{
    [afterController.view removeFromSuperview];
    [afterController removeFromParentViewController];
    afterController = nil;
}


@end
