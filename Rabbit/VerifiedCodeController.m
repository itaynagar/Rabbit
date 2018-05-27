//
//  VerifiedCodeController.m
//  Rabbit
//
//  Created by Moveo Software on 23/06/2016.
//  Copyright © 2016 Moveo Software. All rights reserved.
//

#import "VerifiedCodeController.h"
#import "EnterDetailsController.h"
#import "ServerHandler.h"

@interface VerifiedCodeController ()
@property NSUInteger currentCell;
@end

@implementation VerifiedCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViews];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self arangeButtonsArray];
}

- (void)arangeButtonsArray {
    
    NSMutableArray *buttonsArray =[[NSMutableArray alloc]init];
    
    [buttonsArray addObject:_digit1];
    
    [buttonsArray addObject:_digit2];
    
    [buttonsArray addObject:_digit3];
    
    [buttonsArray addObject:_digit4];
    
    _verificationDigits = [NSArray arrayWithArray:buttonsArray];
    
}

- (void)initViews
{
    _digit1.layer.cornerRadius = 7.0f;
    _digit2.layer.cornerRadius = 7.0f;
    _digit3.layer.cornerRadius = 7.0f;
    _digit4.layer.cornerRadius = 7.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)goToDetailsContorller
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    EnterDetailsController *enterDetailsController = [storyboard instantiateViewControllerWithIdentifier:@"EnterDetailsController"];
    enterDetailsController.hideBack = YES;
    [self.navigationController pushViewController:enterDetailsController animated:YES];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dialPadPressed:(CircleButtonWithBorder *)sender {
    
    NSString* text = sender.titleLabel.text;
    
    if([text isEqualToString:@"ok"] ){
        NSString *codeString = [NSString stringWithFormat:@"%@%@%@%@",_digit1.text,_digit2.text,_digit3.text,_digit4.text];
        ServerHandler *server = [[ServerHandler alloc]initWithDelegate:self];
        [server activateUserNumber:_phoneNumber andCode:codeString];
        return;
    }
    
    if(text==nil){
        if(_currentCell==0){
            return;
        }
        _currentCell--;
        UITextField *currentDigit = self.verificationDigits[_currentCell];
        currentDigit.text=@"";
        return ;
    }
    
    if(_currentCell>=_verificationDigits.count){
        return;
    }
    UITextField *currentDigit = self.verificationDigits[_currentCell];
    currentDigit.text = text;
    _currentCell++;
    
    return ;
}

# pragma mark - Server

- (void)didActivateUser
{
    [self goToDetailsContorller];
}

- (void)didFailActivateUser
{
    
}

@end
