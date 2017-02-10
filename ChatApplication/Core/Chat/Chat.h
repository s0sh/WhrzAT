//
//  Chat.h
//  ChatApplication
//
//  Created by developer on 08/10/14.
//  Copyright (c) 2014 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class User;

@interface Chat : NSObject

@property (nonatomic, retain) NSString* chatID;

@property (retain, nonatomic) NSString *lastMessage;

@property (retain, nonatomic) NSString *time;

@property (retain, nonatomic) NSString *opponentId;

@property (retain, nonatomic) NSString *chatAvatar;

@property (retain, nonatomic) NSString *oponentName;

@property (retain, nonatomic) NSString *lastMessageFromMe;

@property (retain, nonatomic) UIImage *oponentAvatar;

@property (nonatomic, retain) NSString* unReadMessageCount;

@property (nonatomic, retain) NSString *isOnline;

@end
