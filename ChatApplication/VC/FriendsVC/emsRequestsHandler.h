//
//  emsRequestsHandler.h
//  ChatApplication
//
//  Created by Roman Bigun on 1/26/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol emsRequestsHandlerDelegate;

@interface emsRequestsHandler : UIView
@property (nonatomic, weak) id<emsRequestsHandlerDelegate> delegate;
@property(nonatomic,weak)IBOutlet UIImageView *counterBG;
@property(nonatomic,weak)IBOutlet UILabel *countLbl;
-(void)checkForRequests;
@end

@protocol emsRequestsHandlerDelegate <NSObject>

-(void)hideRequestsHandlerNotificationView:(emsRequestsHandler *)hdr  hide:(int)hide;

@end