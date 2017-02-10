//
//  EditProfileVC.h
//  ChatApplication
//
//  Created by developer on 02/07/14.
//  Copyright (c) 2014 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface EditProfileVC : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UIAlertViewDelegate>

-(id)initWhithUser:(User *)user;

@end
