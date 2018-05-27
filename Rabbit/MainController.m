//
//  MainController.m
//  Rabbit
//
//  Created by Moveo Software on 26/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import "MainController.h"
#import "RUser.h"
#import "SettingsController.h"
#import "RealmManager.h"
#import "ServerHandler.h"
#import <UIImageView+AFNetworking.h>
#import "MatchCell.h"
#import "SignalRManager.h"

@interface MainController ()

@end

@implementation MainController
{
    BOOL endOpen;
    RUser *myUser;
    NSMutableArray *matchesArray;
}

# pragma mark - View Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    [self initMovie];
    _endView.layer.cornerRadius = 10;
    _endButton.layer.cornerRadius = 10;
    _headerProfilePic.layer.cornerRadius = _headerProfilePic.frame.size.width/2;
    _headerProfilePic.clipsToBounds = YES;
    UITapGestureRecognizer *profileTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleAction:)];
    [_headerProfilePic addGestureRecognizer:profileTap];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmissEndPopup)];
    [_bgBlurView addGestureRecognizer:tap];
    [self initUser];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    _matchesTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     [_movie.player play];
    [self findAMeet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Init

- (void)initUser
{
    if ([[RealmManager getRealmManager]getMyUser]){
        [_titleLabel setTitle:[[RealmManager getRealmManager]getMyUserTitleWithAge] forState:UIControlStateNormal];
    }
    if ([[[RealmManager getRealmManager]getMyUser] userImageUrl]) {
        NSURL *url = [NSURL URLWithString:[[[RealmManager getRealmManager]getMyUser] userImageUrl]];
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:60];
        
        [_headerProfilePic setImageWithURLRequest:imageRequest
                             placeholderImage:[UIImage imageNamed:@"image_placeholder"]
                                      success:nil
                                      failure:nil];
    }
}

- (void)initMovie
{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    self.movie = [[AVPlayerViewController alloc] init];
    _movie.view.frame = _videoHolder.frame;
    [_movie setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoHolder addSubview:self.movie.view];
    AVURLAsset *asset = [AVURLAsset assetWithURL:fileURL];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
    AVPlayer * player = [[AVPlayer alloc] initWithPlayerItem: item];
    _movie.showsPlaybackControls = NO;
    [_movie setPlayer:player];
    
    __weak typeof(self) weakSelf = self; // prevent memory cycle
    NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
    [noteCenter addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                            object:nil // any object can send
                             queue:nil // the queue of the sending
                        usingBlock:^(NSNotification *note) {
                            // holding a pointer to avPlayer to reuse it
                            [weakSelf.movie.player seekToTime:kCMTimeZero];
                            [weakSelf.movie.player play];
                        }];
}

# pragma mark - Server

- (void)didGotMatches
{
    matchesArray = [[RealmManager getRealmManager] getMatches];
    if (matchesArray.count > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            _matchesTable.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            _matchesTable.alpha = 0.0;
        }];
    }
    [_matchesTable reloadData];
}

- (void)findAMeet
{
//    ServerHandler *server = [[ServerHandler alloc]initWithDelegate:self];
//    [server findMeetingsWithMeetingId:_meetingType andUserToken:[[[RealmManager getRealmManager]getMyUser] userToken] andLat:_currentLocation.coordinate.latitude andLong:_currentLocation.coordinate.longitude];
}

# pragma mark - Actions

- (IBAction)endAction:(id)sender
{
    if (!endOpen) {
        endOpen = YES;
        _bgBlurView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _bgBlurView.alpha = 1.0;
        }];
    }
}

- (IBAction)dissmissEndPopupAction:(id)sender
{
    [[SignalRManager getSignalRManager]sendLogOffMeeting];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)titleAction:(id)sender
{
    [self.movie.player pause];
    [self goSettingsContorller];
}

- (void)dissmissEndPopup
{
    if (endOpen) {
        endOpen = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _bgBlurView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                _bgBlurView.hidden = YES;
            }
        }];
    }
}

- (void)goSettingsContorller
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    SettingsController *settingsController = [storyboard instantiateViewControllerWithIdentifier:@"SettingsController"];
    [self.navigationController pushViewController:settingsController animated:YES];
}

# pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return matchesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchCell"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MatchCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    RMatchUser *matchUser = [matchesArray objectAtIndex:indexPath.row];
    [cell initWithMatch:matchUser];
    return cell;
}

@end
