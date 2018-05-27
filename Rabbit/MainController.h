//
//  MainController.h
//  Rabbit
//
//  Created by Moveo Software on 26/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MainController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) AVPlayerViewController *movie;

@property (nonatomic, retain) AVPlayer *avPlayer;

@property (nonatomic) BOOL alreadyPlaying;
@property (nonatomic) int meetingId;
@property (nonatomic) int meetingType;
@property (nonatomic) CLLocation* currentLocation;

@property (weak, nonatomic) IBOutlet UIView *videoHolder;
@property (weak, nonatomic) IBOutlet UIView *endView;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (weak, nonatomic) IBOutlet UIButton *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerProfilePic;
@property (weak, nonatomic) IBOutlet UITableView *matchesTable;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *bgBlurView;
- (IBAction)endAction:(id)sender;
- (IBAction)dissmissEndPopupAction:(id)sender;
- (IBAction)titleAction:(id)sender;
@end
