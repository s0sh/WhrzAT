//
//  emsDetailHotSpot.h
//  ChatApplication
//
//  Created by developer on 16/12/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class emsHotSpot;

@interface emsDetailHotSpot : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

- (id)initWithHotSpot:(emsHotSpot*)hotSpot;

@end
