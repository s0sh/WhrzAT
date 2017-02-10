//
//  emsPersone.h
//  ChatApplication
//
//  Created by Roman Bigun on 1/25/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface emsPersone : NSObject
@property(retain)UIImageView *personeImage;
@property(retain)NSString *personeName;
@property(retain)NSString *personeImageUrl;
@property(atomic)BOOL isOnline;
@property(retain)NSNumber *personeId;
-(void)setupAvatar;
@end
