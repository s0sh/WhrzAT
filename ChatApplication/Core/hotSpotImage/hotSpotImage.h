//
//  hotSpotImage.h
//  ChatApplication
//
//  Created by developer on 20/01/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hotSpotImage : NSObject
@property (nonatomic, strong) NSString* ownerID;
@property (nonatomic, strong) NSString* fileID;
@property (nonatomic, strong) NSString* ownerName;
@property (nonatomic, strong) NSString* ownerAvaUrl;
@property (nonatomic, strong) NSString* imageUrl;
@property (nonatomic, strong) NSString* kubImageUrl;
@property (nonatomic, strong) NSString* isMyFriend;
@property (nonatomic, strong) NSNumber* loveCounter;

@end
