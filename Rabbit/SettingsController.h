//
//  SettingsController.h
//  Rabbit
//
//  Created by Moveo Software on 27/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

- (IBAction)backAction:(id)sender;

@end
