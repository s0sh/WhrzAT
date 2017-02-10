//
//  emsHotSpot.h
//  ChatApplication
//
//  Created by developer on 21/12/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, HotSpotType) {
    zeroType = 0,
    firstTipe,
    secondTipe,
    thirdTipe,
    fourthTipe,
    fifthTipe
};

@interface emsHotSpot : NSObject
@property (nonatomic, assign) HotSpotType hotSpotType;
@property (nonatomic) NSString *hotSpotImageURL;
@property (nonatomic) NSString *rectangularHotSpotImageURL;
@property (nonatomic) NSString *hotSpotTitle;
@property (nonatomic) NSString *raitingString;
@property (nonatomic) NSString *hotSpotAdress;
@property (nonatomic) NSString *hotSpotSiteAdress;
@property (nonatomic) NSString *hotSpotPhoneNumber;
@property (nonatomic) NSString *hotSpotWorkingTime;
@property (nonatomic) NSString *hotSpotDescription;
@property (nonatomic ,strong) NSMutableArray *hotSpotTags;
@property (nonatomic,retain) __block NSMutableArray *hotSpotImages;
@property (nonatomic) UIImageView *hotSpotMainImage;
@property (nonatomic) NSString *lontitude;
@property (nonatomic) NSString *langitude;
@property (nonatomic) NSString *imageNameHP;
@property (nonatomic) NSString *followersCount;
@property (nonatomic) NSString *hotSpotID;
@property (nonatomic) NSString *hotSpotDistance;
@property (nonatomic,readwrite) __block NSString *isMember;
@property (nonatomic) NSString *isSelected;
@property BOOL isPromotion;
@end
