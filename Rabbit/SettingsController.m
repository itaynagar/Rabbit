//
//  SettingsController.m
//  Rabbit
//
//  Created by Moveo Software on 27/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import "SettingsController.h"
#import "RealmManager.h"
#import "TutorialController.h"
#import "EnterDetailsController.h"

@interface SettingsController ()

@end

@implementation SettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[RealmManager getRealmManager]getMyUser]){
        [_titleLabel setText:[[RealmManager getRealmManager]getMyUserTitleWithAge]];
    }
    _settingsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"rabbits";
            break;
        case 1:
            cell.textLabel.text = @"profile";
            break;
        case 2:
            cell.textLabel.text = @"filters";
            break;
        case 3:
            cell.textLabel.text = @"tutorial";
            break;
        case 4:
            cell.textLabel.text = @"calls";
            cell.textLabel.textColor = [UIColor blueColor];
            break;
        case 5:
            cell.textLabel.text = @"share on Facebook";
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            EnterDetailsController *enterDetailsController = [storyboard instantiateViewControllerWithIdentifier:@"EnterDetailsController"];
            [self.navigationController pushViewController:enterDetailsController animated:YES];
        }
            break;
        case 2:
            
            break;
        case 3:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            TutorialController *tutorialController = [storyboard instantiateViewControllerWithIdentifier:@"TutorialController"];
            [self presentViewController:tutorialController animated:YES completion:nil];
        }
            break;
        case 4:
            
            break;
        case 5:
            
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
