//
//  emsPersone.m
//  ChatApplication
//
//  Created by Roman Bigun on 1/25/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import "emsPersone.h"
#import "UIImageView+AFNetworking.h"

@implementation emsPersone

@synthesize personeId,personeImage,personeImageUrl,personeName,isOnline;

-(id)init
{

    self = [super init];
    if(self)
    {
    
        self.personeImage = [[UIImageView alloc] init];
        self.personeName = [NSString new];
        self.personeId = 0;
        self.isOnline = NO;
        
    }
    
    return self;

}

-(void)setupAvatar{
  
   [self.personeImage setImageWithURL:[NSURL URLWithString:personeImageUrl]];
    
}

@end
