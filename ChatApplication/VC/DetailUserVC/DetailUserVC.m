//
//  DetailUserVC.m
//  ChatApplication
//
//  Created by developer on 25/06/14.
//  Copyright (c) 2014 developer. All rights reserved.
//

#import "DetailUserVC.h"
#import "imageVC.h"
#import "UIImageView+AFNetworking.h"
#import "ApiCall.h"
#import "ModalClass.h"
#import "DetailChatVC.h"
@interface DetailUserVC (){
    NSString *userIdl;
}
@property (retain, nonatomic)__block IBOutlet UIImageView *userAvatar;
@property (retain, nonatomic)__block IBOutlet UILabel *userName;
@property (retain, nonatomic)__block IBOutlet UITextView *descriptionView;
@property (retain, nonatomic)__block IBOutlet UIButton *saveBtn;

@property (strong)NSString *opponentID;



@end

@implementation DetailUserVC



- (id)initWithUser:(NSString *)userId{

    self = [super init];
    
    if (self) {
        userIdl = userId;
  
    }
    return self;
}

-(void)cornerIm:(UIView*)imageView{
    imageView .layer.cornerRadius = imageView.frame.size.height / 2 ;
    imageView.layer.masksToBounds = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    __weak __typeof(self)weakSelf = self;
    [[ApiCall sharedInstance] getDetailUser:userIdl andResult:^(NSDictionary *succeess) {
    [weakSelf.userAvatar setImageWithURL:[NSURL URLWithString:succeess[@"user"][@"img"]]];
    weakSelf.descriptionView.text = succeess[@"user"][@"description"];
    weakSelf.userName.text = succeess[@"user"][@"name"];
    NSLog(@"%@",succeess);
    weakSelf.opponentID = [NSString stringWithFormat:@"%@",succeess[@"user"][@"uId"]];
 
         } resultFailed:^(NSString *error) {
        
    }];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideButton"] isEqualToString:@"1"])
    {
    
        self.saveBtn.alpha=0;
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"hideButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}
-(IBAction)startChat
{
    
    [self presentViewController:[[DetailChatVC alloc] initWithUser:self.opponentID andName:@"" andIDChat:@""] animated:YES completion:^{
        
    }];

    
}
- (void)viewDidLoad
{
    
    [self cornerIm:self.userAvatar];
    [super viewDidLoad];
    
}
-(IBAction)backAction
{
    
    [self dismissViewControllerAnimated:YES completion:^{
       
    }];

}
-(void)addToFriend
{
    [[[UIAlertView alloc] initWithTitle:@"Add Friend" message:@"Are you sure you want to add this person to friend's list?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] show];

}
-(IBAction)addTofrieend
{

    [self addToFriend];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
        [self addFriend];
    }
    
}
-(void)addFriend
{

     [[ApiCall sharedInstance] friendAccept:self.opponentID beMyFriend:YES  ResultSuccess:^(BOOL success)
     {
           _saveBtn.hidden=YES;
//         [self.saveBtn removeTarget:self action:@selector(startChat) forControlEvents:UIControlEventTouchUpInside];
//         self.saveBtn.titleLabel.text = @"START CHAT";
//         [self.saveBtn addTarget:self action:@selector(startChat) forControlEvents:UIControlEventTouchUpInside];
         
     } resultFailed:^(NSString *error) {
         
         NSLog(@"%@",error);
         
     }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
