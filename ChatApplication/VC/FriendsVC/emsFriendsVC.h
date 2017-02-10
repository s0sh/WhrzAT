//
//  emsFriendsVC.h
//  ChatApplication
//
//  Created by admin on 02.02.16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "emsRequestsHandler.h"

@interface emsFriendsVC : UIViewController <UITableViewDataSource, UITableViewDelegate, emsRequestsHandlerDelegate,
SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet emsRequestsHandler *rHandler;
@property (weak, nonatomic) IBOutlet UITableView *personeTable;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIButton *requestsBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end
