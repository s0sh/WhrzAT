//
//  emsHotSpotEssence.h
//  ChatApplication
//
//  Created by developer on 18/12/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import MapKit;
typedef void (^FollowBlock)(id<MKAnnotation> bl);
typedef void (^CloseSelfOnMap)(id<MKAnnotation> bl);
typedef void (^DeleteBlock)(id<MKAnnotation> bl);
typedef void (^InfoBlock)();

typedef NS_ENUM(NSUInteger, MapEssenceType) {
    firstEssence= 0,
    secondEssence,
    thirdEssence,
    fourthEssence,
    fifthEssence
};
@interface emsHotSpotEssence : NSObject
@property (nonatomic, assign) MapEssenceType essenceType;
@property (nonatomic, strong) NSNumber *anID;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *essenceID;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) FollowBlock followBlock;
@property (nonatomic, copy) DeleteBlock deleteBlock;
@property (nonatomic, copy) CloseSelfOnMap closeSelfOnMap;
@property (nonatomic, copy) InfoBlock infoBlock;
@property (nonatomic, copy) NSString *annotationImageUrl;


@end
