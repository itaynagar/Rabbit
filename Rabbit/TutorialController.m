//
//  TutorialController.m
//  Rabbit
//
//  Created by Moveo Software on 26/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import "TutorialController.h"
#import "TutorialCell.h"
#import "RealmManager.h"

@interface TutorialController ()

@end

@implementation TutorialController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[RealmManager getRealmManager]getMyUser]){
        [_titleLabel setText:[[RealmManager getRealmManager]getMyUserTitleWithAge]];
    }
    [_collectionView registerNib:[UINib nibWithNibName:@"TutorialCell" bundle:[NSBundle mainBundle]]
           forCellWithReuseIdentifier:@"TutorialCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TutorialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TutorialCell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.tutImageView.image = [UIImage imageNamed:@"Tutorial_Man1"];
            break;
        case 1:
            cell.tutImageView.image = [UIImage imageNamed:@"Tutorial_Man2"];
            break;
        case 2:
            cell.tutImageView.image = [UIImage imageNamed:@"Tutorial_Man3"];
            break;
        case 3:
            cell.tutImageView.image = [UIImage imageNamed:@"Tutorial_Man4"];
            break;
        case 4:
            cell.tutImageView.image = [UIImage imageNamed:@"Tutorial_Man5"];
            break;
            
        default:
            break;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([UIScreen mainScreen].bounds.size.width < 321) {
        return CGSizeMake(320, 407);
    } else if ([UIScreen mainScreen].bounds.size.width > 321 && [UIScreen mainScreen].bounds.size.width < 376){
        return CGSizeMake(375, 437);
    } else {
        return CGSizeMake(414, 457);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayou minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect visibleRect = (CGRect){.origin = _collectionView.contentOffset, .size = _collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [_collectionView indexPathForItemAtPoint:visiblePoint];
    [_pagecontrol setCurrentPage:(int)visibleIndexPath.row];
}

- (IBAction)pageChange:(id)sender
{
    int page = (int)_pagecontrol.currentPage;
    CGRect frame = _collectionView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_collectionView scrollRectToVisible:frame animated:YES];
}

- (IBAction)skipAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
