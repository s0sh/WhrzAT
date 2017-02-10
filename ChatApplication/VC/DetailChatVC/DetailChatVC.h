//
//  DetailChatVC.h
//  ChatApplication
//
//  Created by developer on 25/06/14.
//  Copyright (c) 2014 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Chat;
@interface DetailChatVC : UIViewController< UITextFieldDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
- (id)initWithUser:(NSString *)opponentID;
- (id)initWithUser:(NSString *)opponentID andName:(NSString *)name;
- (id)initWithUser:(NSString *)opponentID andName:(NSString *)name andIDChat:(NSString *)chatID;
@end
