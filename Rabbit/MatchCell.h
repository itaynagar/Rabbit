//
//  MatchCell.h
//  Rabbit
//
//  Created by Moveo Software on 28/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMatchUser.h"
#import "UIImageView+AFNetworking.h"

@interface MatchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameAndAgeLabel;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;

- (void)initWithMatch:(RMatchUser *)matchUser;

@end
