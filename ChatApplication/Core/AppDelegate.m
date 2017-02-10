
//
//  AppDelegate.m
//  ChatApplication
//
//  Created by developer on 25/06/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "UserMapVC.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"

#import "LeftControl.h"
#import "LoginVC.h"
#import "SettingVC.h"
#import "DetailUserVC.h"
#import "DetailChatVC.h"
#import "EditProfileVC.h"
#import "emsDetailProfile.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "DetailChatVC.h"
#import "DetailUserVC.h"
#import "emsCreateHSVC.h"
#import "ModalClass.h"
#import "emsChatsVC.h"
#import "emsFriendsVC.h"
#import "emsGlobalLocationServer.h"

@interface AppDelegate ()
{

    UIViewController* mainVC;

}
@property (nonatomic,strong) MMDrawerController * drawerController;

@property (nonatomic,strong) UITabBarController *tabBarController;

@end

@implementation AppDelegate


#define kRegisteredKeyStringConst @"AppDelegatKeyRegistered"

- (UINavigationController*)getSession{
    
    return self.navigationController;
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    [MC alertText:@"didFailToRegisterForRemoteNotificationsWithError"];//косяк
    
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    NSLog(@"Registering device for push notifications..."); // iOS 8
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    //Test it carefully
    NSString *token = [[newDeviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", token);
    
    
    NSString* deviceToken1 = [[[[token description]
                                stringByReplacingOccurrencesOfString: @"<" withString: @""]
                               stringByReplacingOccurrencesOfString: @">" withString: @""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""] ;
    NSLog(@"Device_Token     -----> %@\n",deviceToken1);

    
    API.deviceToken = deviceToken1;
    
    
}
-(void)iphoneLogin{
    
    
    
    UIViewController *loginVC =[[LoginVC alloc] init];
    self.window.rootViewController = loginVC;
   [self iPhoneSetUpRootController];

}
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
 
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    application.applicationIconBadgeNumber = 0;
    
    
    [self activatePushNotifications:launchOptions];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    API;
    [ModalClass sharedInstance];
    [emsGlobalLocationServer sharedInstance];
    [[Twitter sharedInstance] startWithConsumerKey:@"52xgfZZfJTzMKZ6OXKM4Jq1uE" consumerSecret:@"SmWbo5Zy1mp9Ii7Kjr6DlNIwPfm4njQLoSgfwdtiFoMblyMyK3"];
    [Fabric with:@[[Twitter sharedInstance]]];

    
    if(![[self registeredKeyIsInstalled] isEqualToString:@"1"])
    {
       [self iphoneLogin];
    }
    else{
        
        [[ModalClass sharedInstance] restoreUserData];
        
        [self iPhoneSetUpRootController];
        
        self.window.rootViewController =self.drawerController;
        
    }
   
    [self.window makeKeyAndVisible];
    
    return YES;
    
}
#pragma iphone
-(void)logOut{
    
    [self installRegisteredKey:NO];
    UIViewController* loginVC = [[LoginVC alloc] init];
    self.window.rootViewController = loginVC;
    
}

-(void)setUpNavigator{
    
    self.window.rootViewController =self.drawerController;
}

-(void)installRegisteredKey:(BOOL)key
{
    NSLog(@"%@",[NSString stringWithFormat:@"%i",key]);
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i",key] forKey:kRegisteredKeyStringConst];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)registeredKeyIsInstalled
{

   return [[NSUserDefaults standardUserDefaults] objectForKey:kRegisteredKeyStringConst];

}
-(void)iPhoneSetUpRootController{
    
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[UserMapVC alloc] init]];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UIViewController * leftDrawer = [[LeftControl alloc] init];
    
    UIViewController * rightDrawer = Nil;
    
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:self.navigationController
                             leftDrawerViewController:leftDrawer
                             rightDrawerViewController:rightDrawer];
    
    
    [self.drawerController  leftDrawerViewController];
    
    
    [self.drawerController  setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController  setMaximumRightDrawerWidth:1.];
    [self.drawerController  setMaximumLeftDrawerWidth:102.0];
    [self.drawerController  setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
    [self.drawerController  setCloseDrawerGestureModeMask:  MMCloseDrawerGestureModeAll];
    
    //
    [self.drawerController
     setGestureShouldRecognizeTouchBlock:^BOOL(MMDrawerController *drawerController, UIGestureRecognizer *gesture, UITouch *touch) {
         BOOL shouldRecognizeTouch = NO;
         if(drawerController.openSide == MMDrawerSideNone &&
            [gesture isKindOfClass:[UIPanGestureRecognizer class]]){
             UIView * customView =nil;
             CGPoint location = [touch locationInView:customView];
             shouldRecognizeTouch = (CGRectContainsPoint(customView.bounds, location));
         }
         return shouldRecognizeTouch;
     }];
    
}
-(void)registrationEditProfile{
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[EditProfileVC alloc] initWithNibName:@"EditProfileVC" bundle:nil]];
    [self.navigationController setNavigationBarHidden:YES];
    self.window.rootViewController = self.navigationController ;
    
}
-(void)swizzle_registrationEditProfile{
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[EditProfileVC alloc] initWithNibName:@"EditProfileVC" bundle:nil]];
    [self.navigationController setNavigationBarHidden:YES];
    self.window.rootViewController = self.navigationController ;
    NSLog(@"Swizzled ;)");
}

-(void)myProfileFromLogin:(UIViewController*)controller{
    
    self.window.rootViewController =controller;
    
    controller = nil;
    
}

-(void)myProfile:(UIViewController*)controller{
    
    [self.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
        UIViewController *viewController = self.navigationController.topViewController;
        
//        if ([viewController isMemberOfClass:[ProfileVC class]]) {
//            
//            [self.navigationController popToViewController:viewController animated:YES];
//            
//            return;
//        }
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
        
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        
        for (UIViewController *viewController in  navigationArray) {
            
            if (![viewController isMemberOfClass:[UserMapVC class]]) {
                
                [tmpArr addObject:viewController];
            }
        }
        
        [navigationArray removeObjectsInArray:tmpArr];
        
        self.navigationController.viewControllers = navigationArray;
        
        tmpArr = nil;
        
        navigationArray= nil;
        
        [self.navigationController pushViewController:controller animated:YES];

    }];
}


-(void)myHotSpot:(UIViewController*)controller{
    
    [self.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
      
        UIViewController *viewController = self.drawerController.centerViewController.topViewController;
     
        if ([viewController isMemberOfClass:[emsCreateHSVC class]]) {
            [self.drawerController.centerViewController popToViewController:viewController animated:YES];
            return;
        }
       
        
       [self.drawerController.centerViewController pushViewController:controller animated:YES];
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.drawerController.centerViewController.viewControllers];
        
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        
        for (UIViewController *viewController in  navigationArray) {
            
            if (![viewController isMemberOfClass:[emsCreateHSVC class]]) {
                
                [tmpArr addObject:viewController];
            }
        }
        
        [navigationArray removeObjectsInArray:tmpArr];
        
        self.drawerController.centerViewController.viewControllers = navigationArray;
        
        tmpArr = nil;
        
        navigationArray= nil;
    }];

}

-(void)myDetailProfile:(UIViewController*)controller{
    
    
    [self.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
        UIViewController *viewController = self.drawerController.centerViewController.topViewController;
        if ([viewController isMemberOfClass:[emsDetailProfile class]]) {
            [self.drawerController.centerViewController popToViewController:viewController animated:YES];
            return;
        }
        
        
        [self.drawerController.centerViewController pushViewController:controller animated:YES];
        
//        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.drawerController.centerViewController.viewControllers];
//        
//        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
//        
//        for (UIViewController *viewController in  navigationArray) {
//            
//            if (![viewController isMemberOfClass:[emsDetailProfile class]]) {
//                
//                [tmpArr addObject:viewController];
//            }
//        }
//        
//        [navigationArray removeObjectsInArray:tmpArr];
//        
//        self.drawerController.centerViewController.viewControllers = navigationArray;
//        
//        tmpArr = nil;
//        
//        navigationArray= nil;
    }];
    
    
    
}


-(void)myFriends:(UIViewController*)controller{
    
    
    [self.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
        UIViewController *viewController = self.drawerController.centerViewController.topViewController;
        if ([viewController isMemberOfClass:[emsFriendsVC class]]) {
            [self.drawerController.centerViewController popToViewController:viewController animated:YES];
            return;
        }
        
        
        [self.drawerController.centerViewController pushViewController:controller animated:YES];
        
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.drawerController.centerViewController.viewControllers];
        
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        
        for (UIViewController *viewController in  navigationArray) {
            
            if (![viewController isMemberOfClass:[emsFriendsVC class]]) {
                
                [tmpArr addObject:viewController];
            }
        }
        
        [navigationArray removeObjectsInArray:tmpArr];
        
        self.drawerController.centerViewController.viewControllers = navigationArray;
        
        tmpArr = nil;
        
        navigationArray= nil;
    }];
    

    
}

-(void)myChats:(UIViewController*)controller{

    
    [self.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
        UIViewController *viewController = self.drawerController.centerViewController.topViewController;
        if ([viewController isMemberOfClass:[emsChatsVC class]]) {
            [self.drawerController.centerViewController popToViewController:viewController animated:YES];
            return;
        }
        
        
        [self.drawerController.centerViewController pushViewController:controller animated:YES];
        
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.drawerController.centerViewController.viewControllers];
        
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        
        for (UIViewController *viewController in  navigationArray) {
            
            if (![viewController isMemberOfClass:[emsChatsVC class]]) {
                
                [tmpArr addObject:viewController];
            }
        }
        
        [navigationArray removeObjectsInArray:tmpArr];
        
        self.drawerController.centerViewController.viewControllers = navigationArray;
        
        tmpArr = nil;
        
        navigationArray= nil;
    }];

    
   }

-(void)myMain:(UIViewController*)controller{
    
    
    [self.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
        UIViewController *viewController = self.drawerController.centerViewController.topViewController;
        
        if ([viewController isMemberOfClass:[UserMapVC class]]) {
            [self.drawerController.centerViewController popToViewController:viewController animated:YES];
            return;
        }
        
        [self.drawerController.centerViewController pushViewController:controller animated:YES];
        
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.drawerController.centerViewController.viewControllers];
        
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        
        for (UIViewController *viewController in  navigationArray) {
            
            if (![viewController isMemberOfClass:[UserMapVC class]]) {
                
                [tmpArr addObject:viewController];
            }
        }
        
        [navigationArray removeObjectsInArray:tmpArr];
        
        self.drawerController.centerViewController.viewControllers = navigationArray;
        
        tmpArr = nil;
        
        navigationArray= nil;
    }];
    
}



-(void)mySettings:(UIViewController*)controller{

    
    
    
    [self.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
        UIViewController *viewController = self.drawerController.centerViewController.topViewController;
        if ([viewController isMemberOfClass:[SettingVC class]]) {
            [self.drawerController.centerViewController popToViewController:viewController animated:YES];
            return;
        }
        
        
        [self.drawerController.centerViewController pushViewController:controller animated:YES];
        
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.drawerController.centerViewController.viewControllers];
        
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        
        for (UIViewController *viewController in  navigationArray) {
            
            if (![viewController isMemberOfClass:[SettingVC class]]) {
                
                [tmpArr addObject:viewController];
            }
        }
        
        [navigationArray removeObjectsInArray:tmpArr];
        
        self.drawerController.centerViewController.viewControllers = navigationArray;
        
        tmpArr = nil;
        
        navigationArray= nil;
    }];

  }


-(void)leftOpen{
    
    [self.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    [[ApiCall sharedInstance] setUserOnline:YES];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[ApiCall sharedInstance] setUserOnline:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[ApiCall sharedInstance] setUserOnline:YES];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    [[ApiCall sharedInstance] setUserOnline:NO];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                         openURL:url
                                               sourceApplication:sourceApplication
                                                      annotation:annotation];

}
-(void)pushNotifHandlers:(NSNotification *)notification
{
    
    NSLog(@"Notif name: %@",notification.name);
    if([notification.name isEqualToString:@"UserProfileFromNotifications"])
    {
        
        
        
//        emsProfileVC *reg = [[emsProfileVC alloc] initWithNibName:@"emsProfileVC" bundle:nil];
//        reg.profileUserId = notification.userInfo[@"userId"];
//        self.window.rootViewController = reg;
//        [self.window makeKeyAndVisible];
        
    }
    
    
    
}
- (void)addMessageFromRemoteNotification:(NSDictionary*)userInfo updateUI:(BOOL)updateUI
{
    NSLog(@"%@",[[userInfo valueForKey:@"aps"] valueForKey:@"alert"]);
    
}
-(void)activatePushNotifications:(NSDictionary *)launchOptions
{

    //Notifications handler
    if (launchOptions != nil){
        NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil)
        {
           
                if([[[dictionary valueForKey:@"aps"] valueForKey:@"type"] isEqualToString:@"chat"]){
                    
                    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:@"pushData"];
                    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"fromPush"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }
            
        }
        else{
        
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"pushData"];
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"fromPush"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        
        }
    }

}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
   
   
    NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"WhrzAt"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    [alertView show];
    
    
    
}

@end
