//
//  emsRequestsHandler.m
//  ChatApplication
//
//  Created by Roman Bigun on 1/26/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import "emsRequestsHandler.h"
#import "ApiCall.h"
@implementation emsRequestsHandler

-(void)awakeFromNib
{
    self.alpha=0;
    [super awakeFromNib];
    [self checkForRequests];
}
-(void)checkForRequests
{
    [[ApiCall sharedInstance] friendsWithSearchString:nil/*Get all items*/ fromIndex:0 toIndex:100 friendsOrRequests:NO  ResultSuccess:^(NSArray *succeess) {
        if(succeess.count>0){
            self.alpha = 1;
            self.countLbl.text=[NSString stringWithFormat:@"%lu",(unsigned long)succeess.count];
        }else{
            self.alpha = 0;
            
        }
        
    } resultFailed:^(NSString *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}
-(void)hideRequestsHandlerNotificationView:(emsRequestsHandler *)hdr hide:(int)hide
{

    id<emsRequestsHandlerDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(hideRequestsHandlerNotificationView:)]) {
        self.alpha=hide;
    }
    
}
@end
