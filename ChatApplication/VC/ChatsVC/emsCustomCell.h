//
//  emsCustomCellViewController.h
//  ChatApplication
//
//  Created by admin on 26.01.16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface emsCustomCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photo;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *messageLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (weak, nonatomic) IBOutlet UIImageView *arrowView;
@property (weak, nonatomic) IBOutlet UIImageView *online;
@property (weak, nonatomic) IBOutlet UIImageView *unreadMessagesBgrdView;
@property (weak, nonatomic) IBOutlet UILabel *unreadMessagesCounter;



@end
