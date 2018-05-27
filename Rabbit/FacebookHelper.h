//
//  FacebookHelper.h
//  PictureVeName
//
//  Created by Moveo Software on 13/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FacebookProtocol <NSObject>

-(void)didLogIn:(NSDictionary *)response;
-(void)didFailLogIn:(NSError *)error;

@end

@interface FacebookHelper : NSObject
{
    id <FacebookProtocol> _delegate;
}

@property (nonatomic,strong)id _delegate;

- (id)initWithDelegate:(id)delegate;
- (void)logInAction:(UIViewController *)viewController;

@end
