//
//  ApiCall.h
//  ChatApplication
//
//  Created by developer on 04/09/14.
//  Copyright (c) 2014 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"

#define Server [ApiCall sharedInstance]
@class User;

@interface ApiCall : NSObject

@property(nonatomic,retain)User *cerrentUser;
@property(nonatomic,retain)UIImage *userAvatar;
@property(nonatomic,readonly)NSString *userId;
@property(nonatomic,retain)NSString *deviceToken;
@property(nonatomic,retain)NSString *unReadChats;
@property(nonatomic,retain)NSString *requestCount;
@property(nonatomic,retain)NSString *fbName;
@property(nonatomic,retain)NSString *password;
+(ApiCall*)sharedInstance;//singeltone

-(void)loginFB:(NSString *)faceBookToken andFaceBookID:(NSString*)faceBookID ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed;
-(void)loginTwitter:(NSString *)twitterToken andtwitterId:(NSString*)twitterId  andTwitterSecret:(NSString*)twitterSecret ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed;
-(void)udateProfile:(NSString *)name andDescription:(NSString*)description andImage:(UIImage *)image ResultSuccess:(void (^)(NSString *))succeess resultFailed:(void (^)(NSString *))failed;
-(void)createHotSpot:(NSString *)nameHotSpot andAddress:(NSString*)address andtime:(NSString*)time andDescription:(NSString*)description andLat:(NSString*)lat andLng:(NSString*)lng andPhone:(NSString*)phone andlink:(NSString*)link  andTags:(NSArray*)Tags andImage:(UIImage *)image ResultSuccess:(void (^)(NSDictionary  *))succeess resultFailed:(void (^)(NSString *))failed;
-(void)getProfileResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed;
-(void)getHotSpotLisResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed;

-(void)getDetaiChat:(NSString *)opponentID ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed;

-(void)sendMessage:(NSString *)message andChatID:(NSString *)chatID ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))faile;
-(void)addImageToHotSpot:(NSString *)hotSpotID andImage:(UIImage *)image ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed;
-(void)friendsWithSearchString:(NSString*)searchString fromIndex:(int)from toIndex:(int)to friendsOrRequests:(BOOL)friends ResultSuccess:(void (^)(NSArray *))succeess resultFailed:(void (^)(NSString *))failed;
-(void)friendAccept:(NSString*)friendId beMyFriend:(BOOL)be_friend ResultSuccess:(void (^)(BOOL))succeess resultFailed:(void (^)(NSString *))failed;
-(void)friendSendRequest:(NSString*)friendId beMyFriend:(BOOL)be_friend ResultSuccess:(void (^)(BOOL))succeess resultFailed:(void (^)(NSString *))failed;
-(void)profileDeleteWithResultSuccess:(void (^)(BOOL))succeess resultFailed:(void (^)(NSString *))failed;
-(void)getHotSpotLisеSearch:(NSString *)searchStr andResult:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed;
-(void)getDetailUser:(NSString *)userID andResult:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed;
-(void)getChatListResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed;
-(void)removeChatWithChatId:(NSString *)cId ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed;
-(void)setRadius:(NSString *)radius ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed;
-(void)getRadiusResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed;
-(void)checkInInHotSpot:(NSString *)cId checkIn:(BOOL)yes ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed;
-(void)getChatHistory:(NSString *)opponentID ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed;
-(void)setUserOnline:(BOOL)isOnline;
-(void)checkDistance:(NSDictionary *)data andResult:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed;
-(void)likePicture:(NSString*)picId ResultSuccess:(void (^) (NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed;
-(void)getDetailSpot:(NSString *)userID andResult:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed;
@end
