//
//  AppDelegate.h
//  ChatApplication
//
//  Created by developer on 25/06/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import <FacebookSDK/FacebookSDK.h>

#define facebookTokenKey @"whrzatFacebookToken"
#define whrzatFacebookID @"whrzatFacebookID"
#define twitterTokenKey @"whrzatTwitterToken"
#define twitterTokenSecretKey @"whrzatTwitterTokenSecret"
#define twitterUserIdKey @"whrzatTwitterUserId"

@class User;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;



@property (strong, nonatomic) UINavigationController *navigationControllerDetailView;

@property (strong, nonatomic) UINavigationController *navigationControllerMenuView;

@property (strong, nonatomic) UINavigationController *navigationControllerListView;

-(void)isLogin:(UIViewController*)controller;

-(void)leftOpen;

-(void)myProfile:(UIViewController*)controller;

-(void)myHotSpot:(UIViewController*)controller;

-(void)myFriends:(UIViewController*)controller;

-(void)myChats:(UIViewController*)controller;

-(void)myMain:(UIViewController*)controller;

-(void)mySettings:(UIViewController*)controller;

-(void)setUpNavigator;

-(void)myProfileFromLogin:(UIViewController*)controller;

-(void)logOut;

-(UINavigationController*)getSession;

-(void)iPhoneSetUpRootController;

-(void)iphoneLogin;

-(void)myDetailProfile:(UIViewController*)controller;

-(void)detailUser:(User *)user;

-(void)setUpTabbar;



-(void)installRegisteredKey:(BOOL)key;
-(NSString *)registeredKeyIsInstalled;
-(void)registrationEditProfile;
-(void)swizzle_registrationEditProfile;




@end
