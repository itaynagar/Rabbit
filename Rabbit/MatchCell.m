//
//  MatchCell.m
//  Rabbit
//
//  Created by Moveo Software on 28/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import "MatchCell.h"

@implementation MatchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithMatch:(RMatchUser *)matchUser
{
    _nameAndAgeLabel.text = [NSString stringWithFormat:@"%@, %d", matchUser.nickName, matchUser.age];
//    NSURL *url = [NSURL URLWithString:matchU];
//    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url
//                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
//                                              timeoutInterval:60];
//    
//    [_profilePicImageView setImageWithURLRequest:imageRequest
//                         placeholderImage:[UIImage imageNamed:@"camera_"]
//                                  success:nil
//                                  failure:nil];
}

@end
