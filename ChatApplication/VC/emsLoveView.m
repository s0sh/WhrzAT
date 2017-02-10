//
//  emsLoveView.m
//  ChatApplication
//
//  Created by Roman Bigun on 4/20/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import "emsLoveView.h"
//Love feature
#define LOVE_IMAGES_ARRAY [NSArray arrayWithObjects:@"0.png",@"1.png",@"2.png",@"3.png",@"4.png",@"5.png",@"6.png",@"7.png",@"8.png",@"9.png",@"10.png",nil]

@implementation emsLoveView

-(void)awakeFromNib{

    [super awakeFromNib];
    [self setImageForLoveCount:0];

}
-(void)setImageForLoveCount:(int)count{
    
    [self setImage:[UIImage imageNamed:LOVE_IMAGES_ARRAY[count]]];

}
@end
