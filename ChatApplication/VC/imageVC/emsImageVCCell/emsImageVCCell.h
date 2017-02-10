//
//  emsImageVCCell.h
//  ChatApplication
//
//  Created by developer on 20/01/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "emsLoveView.h"
@protocol CellControllerDelegate;
@interface emsImageVCCell : UITableViewCell
@property (nonatomic, weak) id<CellControllerDelegate> delegate;
@property(weak)IBOutlet UIImageView *mainImage;
@property int loveCount;
@property(weak)IBOutlet emsLoveView *heart;
@property(weak)IBOutlet UIImageView *userAvarat;
@property(weak)IBOutlet UILabel *nameLabel;
@property(weak)IBOutlet UIButton *chatBtn;
@property(weak)IBOutlet UIButton *requestBtn;
@property(weak)IBOutlet UIView *detailView;
@property(weak)IBOutlet UIButton *userBtn;
@property (weak, nonatomic) IBOutlet UILabel *loveCountLbl;
@property(nonatomic,retain)NSString *uId;
@property(nonatomic,retain)NSString *fileID;
- (IBAction)loveThis:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;
@property BOOL isMyFriend;
@end


@protocol CellControllerDelegate <NSObject>

- (void)cellController:(UITableViewCell*)cellController
        userId:(NSString*)userId;

@end
