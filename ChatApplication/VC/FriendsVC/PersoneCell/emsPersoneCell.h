//
//  emsPersoneCell.h
//  ChatApplication
//
//  Created by Roman Bigun on 1/25/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"
#import "UIImageView+RoundedImage.h"
#import "SWTableViewCell.h"

@interface emsPersoneCell : SWTableViewCell//UITableViewCell
@property(nonatomic,retain)Friend *myFriend;
@property(nonatomic,retain)IBOutlet UIImageView *userImage;
@property(nonatomic,retain)IBOutlet UILabel *personeNameLabel;
@property(nonatomic,retain)NSString *userName;
-(void)installCell;
-(void)avatar;
@end
