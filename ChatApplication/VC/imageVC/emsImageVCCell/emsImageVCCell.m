//
//  emsImageVCCell.m
//  ChatApplication
//
//  Created by developer on 20/01/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import "emsImageVCCell.h"
#import "ApiCall.h"


@implementation emsImageVCCell

- (void)awakeFromNib {

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(IBAction)sendRequestToBeAFriend
{
    [[ApiCall sharedInstance] friendSendRequest:self.uId beMyFriend:YES  ResultSuccess:^(BOOL success) {
        self.requestBtn.alpha=0;
        
    } resultFailed:^(NSString *error) {
        
        NSLog(@"%@",error);
        
    }];
}
-(IBAction)goChatting
{
    id<CellControllerDelegate> strongDelegate = self.delegate;
    
    if ([strongDelegate respondsToSelector:@selector(cellController:userId:)]) {
        [strongDelegate cellController:self userId:[NSString stringWithFormat:@"%@",self.uId]];
    }
}
- (IBAction)loveThis:(id)sender {
    
    __weak __typeof(self)weakSelf = self;
    
        [[ApiCall sharedInstance] likePicture:self.fileID ResultSuccess:^(NSDictionary *success) {
            
            if(success){
                int lc = [success[@"love_count"] intValue];
                if(lc>0)
                {
                    weakSelf.loveCount = lc;
                    [weakSelf.heart setImageForLoveCount:lc];
                    weakSelf.loveCountLbl.text = [NSString stringWithFormat:@"%d",lc];
                }
            }
            
            
        } resultFailed:^(NSString *error) {
            
            NSLog(@"%@",error);
            
        }];
    
    
}
@end
