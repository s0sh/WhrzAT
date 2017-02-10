//
//  LoginVC.m
//  ChatApplication
//
//  Created by developer on 26/06/14.
//  Copyright (c) 2014 developer. All rights reserved.
//

#import "LoginVC.h"
#import "UserMapVC.h"
#import "EditProfileVC.h"
#import <TwitterKit/TwitterKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ApiCall.h"
#import "ModalClass.h"
#import <objc/runtime.h>
@interface LoginVC (){
    
    IBOutlet UIView *viewWithPicker;
    
}


@property (nonatomic)  BOOL ScrollUp;


@end

@implementation LoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    [MC saveData:nil toArchive:@"firstTags"];
 
    
    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            
            if (session.authToken != nil) {
         
            
            [[ApiCall sharedInstance] loginTwitter:session.authToken andtwitterId:session.userID andTwitterSecret:session.authTokenSecret ResultSuccess:^(NSDictionary *succeess) {
                
                [[ModalClass sharedInstance] storeUserData:[succeess copy]];
                if ([[NSString stringWithFormat:@"%@",succeess[@"user"][@"isRegister"] ]isEqualToString:@"1"] ) {
                    [APP setUpNavigator];
                    [self storeTWToken:session.authToken secret:session.authTokenSecret andUID:session.userID];
                    [APP installRegisteredKey:YES];
                }
                
                if ([[NSString stringWithFormat:@"%@",succeess[@"user"][@"isRegister"] ]isEqualToString:@"0"] ) {
                    [APP installRegisteredKey:NO];
                    [APP registrationEditProfile];
                }

                
            } resultFailed:^(NSString *error) {
                
            }];
                
            }

        } else {
            NSLog(@"Login error: %@", [error localizedDescription]);
        }
    }];
    
    logInButton.frame = CGRectMake(40, 380, 240,  45);
    [self.view addSubview:logInButton];
    
    [MC connected];
    
    [self picData];
    
}

- (void) myKeyboardWillHideHandler:(NSNotification *)notification {
    [self scrollMainToUp:NO];
}



#pragma TextField


- (void)scrollMainToUp:(BOOL)up{
    
    int yUP = 0;
    
    if (up) {
        yUP = 170;
    }
    
    [UIView animateWithDuration:.4 animations:^{
        [self.view setFrame:CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.origin.x- yUP,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height)];
    }];
}
-(void)storeFBToken:(NSString *)token andUID:(NSString *)uid
{

    [[NSUserDefaults standardUserDefaults] setObject:token forKey:facebookTokenKey];
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:whrzatFacebookID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

}
-(void)storeTWToken:(NSString *)token secret:(NSString*)secret andUID:(NSString *)uid
{
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:twitterTokenKey];
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:twitterUserIdKey];
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:twitterTokenSecretKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(IBAction)reg:(id)sender{
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logInWithReadPermissions:@[@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
       if (result.token != nil) {
            
       [[ApiCall sharedInstance] loginFB:result.token.tokenString andFaceBookID:result.token.userID ResultSuccess:^(NSDictionary *succeess) {
           
           
           [[ModalClass sharedInstance] storeUserData:[succeess copy]];
           
           if ([[NSString stringWithFormat:@"%@",succeess[@"user"][@"isRegister"] ]isEqualToString:@"1"] ) {
               [APP setUpNavigator];
               [APP installRegisteredKey:YES];
               [self storeFBToken:result.token.tokenString andUID:result.token.userID];
           }
           
           if ([[NSString stringWithFormat:@"%@",succeess[@"user"][@"isRegister"] ]isEqualToString:@"0"] ) {
               [APP installRegisteredKey:NO];
               [APP registrationEditProfile];
           }

       } resultFailed:^(NSString *error) {
           
       }];
            
        }

        
    }];
}


-(void)picData{
    
    viewWithPicker.frame = CGRectMake(0, kMainScreenBounds , 320, 255);
    
    [self.view addSubview:viewWithPicker];
    
}

-(IBAction)hidePicker{
    
     [UIView animateWithDuration:kAnimationDuration animations:^{
        viewWithPicker.frame = CGRectMake(0, kMainScreenBounds, 320, 255);
       
    }];
   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
