//
//  FacebookHelper.m
//  PictureVeName
//
//  Created by Moveo Software on 13/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import "FacebookHelper.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "RealmManager.h"
#import "ServerHandler.h"
#import "RUser.h"

@implementation FacebookHelper

@synthesize _delegate;

- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)logInAction:(UIViewController *)viewController
{
    NSLog(@"Loging Into Facebook");
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile", @"user_birthday",@"user_relationships",@"email"] fromViewController:viewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
//            [self makeAlertWithStringTitle:@"Facebook Error" andSub:@"Please try agian later"];
        } else if (result.isCancelled) {
            NSLog(@"Cancelled");
        } else {
            NSLog(@"Logged into Facebook");
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setValue:@"id,name,email,gender,first_name,last_name,relationship_status,birthday" forKey:@"fields"];
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSLog(@"fetched user:%@  and Email : %@", result,result[@"email"]);
                     NSDictionary *resultDict = (NSDictionary *)result;
                     
                     RUser *myUser = [[RUser alloc]init];
                     myUser.userFbId = [resultDict objectForKey:@"id"];
                     myUser.userEmail = [resultDict objectForKey:@"email"];
                     myUser.userFirstName = [resultDict objectForKey:@"first_name"];
                     myUser.userLastName = [resultDict objectForKey:@"last_name"];
                     myUser.userFullName = [resultDict objectForKey:@"name"];
                     myUser.isMale = [[resultDict objectForKey:@"gender"] isEqualToString:@"male"];
                     myUser.userImageUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=5000&return_ssl_resources=1", [resultDict objectForKey:@"id"]];
                     NSDateFormatter *formator = [[NSDateFormatter alloc]init];
                     [formator setDateFormat:@"MM/dd/yyyy"];
                     NSDate *birthdayDate = [formator dateFromString:[result objectForKey:@"birthday"]];
                     NSDate *currentDate = [NSDate date];
                     NSCalendar* calendar = [NSCalendar currentCalendar];
                     NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
                     long currentYear = [components year];
                     components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:birthdayDate];
                     long birthdayYear = [components year];
                     myUser.userAge = [NSString stringWithFormat:@"%ld",(currentYear - birthdayYear)];
                     [[RealmManager getRealmManager]saveUser:myUser];
                     if ([_delegate respondsToSelector:@selector(didLogIn:)]) {
                         [_delegate didLogIn:resultDict];
                     }
                 }
             }];
        }
    }];
}



//- (void)didLoginServer
//{
//    if ([_delegate respondsToSelector:@selector(didLogIn)]) {
//        [_delegate didLogIn];
//    }
//}

//-(void)makeRequestForUserData
//{
//    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id<FBGraphUser> result, NSError *error) {
//        if (!error) {
//            NSLog(@"user info: %@", result);
//            [self setProfileImageFromFB:result];
//            [self setUserAge:result];
//            _userGender.value = ![result[@"gender"] isEqualToString:@"female"]?1.0f:0.0f;
//            _lookingForGender.value = !_userGender.value;
//            _nickName.text = [result.first_name stringByReplacingOccurrencesOfString:@" " withString:@""];
//            NSString * relationShipStatus = result[@"relationship_status"];
//            if(relationShipStatus==nil || [relationShipStatus isEqualToString:@""]){
//                [_marritalStatusPicker selectItem:[self translateToLimitlessScrollerValue:0] animated:YES];
//            }
//            if([relationShipStatus isEqualToString:@"Married"]){
//                [_marritalStatusPicker selectItem:[self translateToLimitlessScrollerValue:2] animated:YES];
//            }
//            if([relationShipStatus isEqualToString:@"Single"]){
//                [_marritalStatusPicker selectItem:[self translateToLimitlessScrollerValue:1] animated:YES];
//            }     if([relationShipStatus isEqualToString:@"Divorced"]){
//                [_marritalStatusPicker selectItem:[self translateToLimitlessScrollerValue:3] animated:YES];
//            }
//            
//            
//        } else {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"facebook error" message:@"could not get user data" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//            [alertView show];
//        }
//    }];
//}

//- (void)initDetailsFromFacebook:(UIViewController *)delegate
//{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setValue:@"id,first_name,last_name,name,email, picture, gender, relationship_status, birthday, education, interested_in, work" forKey:@"fields"];
//    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
//     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//         if (!error) {
//             NSString *userID = [result valueForKey:@"id"];
//             NSString *fullName = [result valueForKey:@"name"];
//             NSString *firstName = [result valueForKey:@"first_name"];
//             NSString *lastName =  [result valueForKey:@"last_name"];
//             NSString *email =  [result valueForKey:@"email"];
//             NSDictionary *profilePicDic = [result valueForKey:@"picture"];
//             NSString *gender = [result valueForKey:@"gender"];
//             NSDictionary *profilePicDataDic = [profilePicDic valueForKey:@"data"];
//             NSString *profilePicUrl =  [profilePicDataDic valueForKey:@"url"];
//             NSMutableArray *educationsArray = [result valueForKey:@"education"];
//             NSString *collegeName = @"Unknown College";
//             if (educationsArray.count > 0) {
//                 for (NSDictionary *typeEdu in educationsArray) {
//                     NSString *type = [typeEdu objectForKey:@"type"];
//                     if ([type isEqualToString:@"College"]) {
//                         NSDictionary *school = [typeEdu objectForKey:@"school"];
//                         collegeName = [school objectForKey:@"name"];
//                     }
//                 }
//             }
//             NSMutableArray *workArray = [result valueForKey:@"work"];
//             NSString *workName = @"Unknown Work";
//             if (workArray.count > 0) {
//                 NSDictionary *typeWork = workArray[0];
//                 NSDictionary *employer = [typeWork objectForKey:@"employer"];
//                 NSString *employerName = [employer objectForKey:@"name"];
//                 NSDictionary *position = [typeWork objectForKey:@"position"];
//                 NSString *positionName = [position objectForKey:@"name"];
//                 if (positionName != nil) {
//                     workName = [NSString stringWithFormat:@"%@ at %@", positionName, employerName];
//                 } else {
//                     workName = [NSString stringWithFormat:@"%@", employerName];
//                 }
//             }
////             NSString *interestedIn;
////             if ([gender isEqualToString:@"male"]) {
////                 interestedIn = @"female";
////                 _interestedIn = 2;
////             } else {
////                 interestedIn = @"male";
////                 _interestedIn = 1;
////             }
//             
////             NSMutableArray *interestedArray = [result objectForKey:@"interested_in"];
////             if (interestedArray != nil) {
////                 for (NSString *string in interestedArray) {
////                     if ([string isEqualToString:@"female"]) {
////                         interestedIn = @"female";
////                         _interestedIn = 2;
////                     }
////                 }
////             }
//             
////             NSString *birthday =  [result valueForKey:@"birthday"];
////             _userFbId = userID;
////             _firstName = firstName;
////             _fullName = fullName;
////             _userEmail = email;
////             _lastName = lastName;
////             _profilePicUrl = profilePicUrl;
////             _gender = gender;
////             _collegeName = collegeName;
////             _workName = workName;
////             _relationStatus = [self getRelationEnum:[result valueForKey:@"relationship_status"]];
////             _userBirthday = birthday;
////             [self saveUserInRealm:delegate];
//         } else {
//             NSLog(@"%@",error.localizedDescription);
//         }
//     }];
//}


@end
