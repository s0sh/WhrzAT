//
//  userCell.h
//  ChatApplication
//
//  Created by developer on 25/09/14.
//  Copyright (c) 2014 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userCell : UITableViewCell

@property (weak, nonatomic)IBOutlet UIImageView* avatarImage;

@property (weak, nonatomic)IBOutlet UIImageView* onlineUser;

@property (weak, nonatomic)IBOutlet UIImageView* isMyFriend;

@property (weak, nonatomic)IBOutlet UILabel *nameLable;

@property (weak, nonatomic)IBOutlet UILabel *lastDateLBL;

@end
