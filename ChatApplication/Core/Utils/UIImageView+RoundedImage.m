//
//  UIImageView+RoundedImage.m
//  ChatApplication
//
//  Created by Roman Bigun on 1/25/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import "UIImageView+RoundedImage.h"

@implementation UIImageView (RoundedImage)

-(void)roundImage
{

    self.layer.cornerRadius = self.frame.size.height / 2 ;
    self.layer.masksToBounds = YES;

}
@end
