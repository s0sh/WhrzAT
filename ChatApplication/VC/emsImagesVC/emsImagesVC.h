//
//  emsImagesVC.h
//  ChatApplication
//
//  Created by developer on 19/01/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "emsImageVCCell.h"
#import "emsHotSpot.h"
@interface emsImagesVC : UIViewController<UITableViewDataSource,UITableViewDelegate,CellControllerDelegate>
- (id)initWithHotSpot:(emsHotSpot*)hotSpot;
@end
