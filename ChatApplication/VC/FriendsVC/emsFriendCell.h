//
//  emsFriendCell.h
//  ChatApplication
//
//  Created by admin on 02.02.16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"


@interface emsFriendCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIImageView *online;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;


@end
