//
//  emsHotSptListCell.h
//  ChatApplication
//
//  Created by developer on 16/12/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface emsHotSptListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UIImageView *hotSpotReitingImage;
@property (weak, nonatomic) IBOutlet UIImageView *hotSpotPromoted;
@property (weak, nonatomic) IBOutlet UILabel *cellHotSpotTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellPhotoCount;
@property (weak, nonatomic) IBOutlet UILabel *cellUsersCount;
@property (weak, nonatomic) IBOutlet UIButton *cellSelectBtn;

@end
