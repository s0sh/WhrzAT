//
//  emsPersoneCell.m
//  ChatApplication
//
//  Created by Roman Bigun on 1/25/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import "emsPersoneCell.h"

@implementation emsPersoneCell
{}
@synthesize myFriend;

-(void)installCell
{

    
    if(myFriend.personeImage.image){
    
        _userImage.image = myFriend.personeImage.image;
    }
    else{
    
        [self avatar];
    
    }
    
    [_userImage roundImage];
    _userName = myFriend.personeName;
    _personeNameLabel.text = _userName;
    
    
}
-(void)avatar
{
    __block UIImage *image = [UIImage new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:myFriend.personeImageUrl]];
        image  = [UIImage imageWithData:imageData];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if (image == nil) {
                
            }else{
                _userImage.image = image;
                
            }
            
        });
    });

}

-(void)willTransitionToState:(UITableViewCellStateMask)state{
   
    [super willTransitionToState:state];
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask)
    {
       
            for (UIView *subview in self.subviews) {
                 //NSLog(@"%@",NSStringFromClass([subview class]));
                for (UIView *subview2 in subview.subviews) {
                    //NSLog(@"%@",NSStringFromClass([subview2 class]));
                    if ([NSStringFromClass([subview2 class]) rangeOfString:@"delete"].location != NSNotFound) {
                        UIImageView *deleteBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
                        [deleteBtn setImage:[UIImage imageNamed:@"delete"]];
                        [subview2 addSubview:deleteBtn];
                        
                    }
                }
            }
        }
    
}
-(void)recurseAndReplaceSubViewIfDeleteConfirmationControl:(NSArray*)subviews{
    NSString *delete_button_name = @"delete.png";
    for (UIView *subview in subviews)
    {
        //handles ios6 and earlier
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"])
        {
           
            UIView *backgroundCoverDefaultControl = [[UIView alloc] initWithFrame:CGRectMake(0,0, 64, 33)];
            [backgroundCoverDefaultControl setBackgroundColor:[UIColor whiteColor]];
            [[subview.subviews objectAtIndex:0] addSubview:backgroundCoverDefaultControl];
            UIImage *deleteImage = [UIImage imageNamed:delete_button_name];
            UIImageView *deleteBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,deleteImage.size.width, deleteImage.size.height)];
            [deleteBtn setImage:[UIImage imageNamed:delete_button_name]];
            [[subview.subviews objectAtIndex:0] addSubview:deleteBtn];
        }
        //the rest handles ios7
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationButton"])
        {
            UIButton *deleteButton = (UIButton *)subview;
            [deleteButton setImage:[UIImage imageNamed:delete_button_name] forState:UIControlStateNormal];
            [deleteButton setTitle:@"" forState:UIControlStateNormal];
            [deleteButton setBackgroundColor:[UIColor clearColor]];
            for(UIView* view in subview.subviews){
                if([view isKindOfClass:[UILabel class]]){
                    [view removeFromSuperview];
                }
            }
        }
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"])
        {
            for(UIView* innerSubView in subview.subviews){
                if(![innerSubView isKindOfClass:[UIButton class]]){
                    [innerSubView removeFromSuperview];
                }
            }
        }
        if([subview.subviews count]>0){
            [self recurseAndReplaceSubViewIfDeleteConfirmationControl:subview.subviews];
        }
        
    }
}

@end
