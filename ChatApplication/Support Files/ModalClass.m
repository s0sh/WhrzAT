//
//  ModalClass.m
//  ChatApplication
//
//  Created by developer on 05/01/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import "ModalClass.h"

@implementation ModalClass


+ (ModalClass *)sharedInstance
{
    
    static ModalClass * _sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        _sharedInstance = [[ModalClass alloc] init];
        
    });
    
    return _sharedInstance;
}
-(void)storeUserData:(NSDictionary *)dic
{
    self.userID = [NSString new];
    self.userFullName = [NSString new];
    self.userAvatarImageUrl = [NSString new];
    self.restToken = [NSString new];
    
    self.userID = [NSString stringWithFormat:@"%@",dic[@"user"][@"uId"]];
    self.userFullName = dic[@"user"][@"name"];
    self.userAvatarImageUrl =  dic[@"user"][@"img"];
    self.restToken = dic[@"restToken"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.userID forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:self.userFullName forKey:@"userFullName"];
    [[NSUserDefaults standardUserDefaults] setObject:self.userAvatarImageUrl forKey:@"userAvatarImageUrl"];
    [[NSUserDefaults standardUserDefaults] setObject:self.restToken forKey:@"restToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)restoreUserData
{

    self.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    self.userFullName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userFullName"];
    self.userAvatarImageUrl =  [[NSUserDefaults standardUserDefaults] objectForKey:@"userAvatarImageUrl"];
    self.restToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"restToken"];
    
}
@end
