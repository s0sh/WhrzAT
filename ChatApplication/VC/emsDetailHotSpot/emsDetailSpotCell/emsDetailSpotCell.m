//
//  emsDetailSpotCell.m
//  ChatApplication
//
//  Created by developer on 17/12/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "emsDetailSpotCell.h"

@implementation emsDetailSpotCell


- (void)awakeFromNib {
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"emsDetailSpotCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
    }
    return self;
}

@end
