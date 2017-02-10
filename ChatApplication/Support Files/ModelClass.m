//
//  ModelClass.m
//  ChatApplication
//
//  Created by developer on 26/06/14.
//  Copyright (c) 2014 developer. All rights reserved.
//

#import "ModelClass.h"
#import "Reachability.h"



static ModelClass *modelClass = nil;

@implementation ModelClass



+ (ModelClass *) sharedModel {
    
    
    if(modelClass == nil) {
        
        modelClass = [[ModelClass alloc] init];
    }
    
    return modelClass;
}



- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}


- (void) alertText:(NSString *)txt {
    UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:nil message:txt delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alrt show];
    
}


- (BOOL) isRetina{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        return YES;
    } else {
        return NO;
    }
    return NO;
}


- (UIImage *) getMainImageView:(UIView *)view{
    UIGraphicsBeginImageContext([[UIScreen mainScreen] bounds].size);
    
    UIGraphicsBeginImageContextWithOptions([[UIScreen mainScreen] bounds].size, NO, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

-(void)saveData:(id)data toArchive:(NSString *)arshive {
           
    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:data];
    
    [[NSUserDefaults standardUserDefaults] setObject:data1 forKey:arshive];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"Data saved");
}

- (id)getDataFromArchive:(NSString *)arshive {
    NSData *data2 = [[NSUserDefaults standardUserDefaults] objectForKey:arshive];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data2];
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if (!networkStatus!= NotReachable) {
        [self alertText:NSLocalizedString(@"THE_INTERNET_IS_DOWN", nil)];
    }
    return networkStatus != NotReachable;
}


- (BOOL)connectedCheck
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    return networkStatus != NotReachable;
}

#pragma HUD
-(void)showMBProgressHUD{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:(UIView*)APP.window  animated:YES];
    hud.labelText = @"Loading...";
    hud.dimBackground = YES;
    
}

-(void)hideMBProgressHUD{
    [MBProgressHUD hideHUDForView:(UIView*)APP.window  animated:YES];
}



@end
