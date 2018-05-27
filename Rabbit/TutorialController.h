//
//  TutorialController.h
//  Rabbit
//
//  Created by Moveo Software on 26/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pagecontrol;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)pageChange:(id)sender;
- (IBAction)skipAction:(id)sender;

@end
