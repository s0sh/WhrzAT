//
//  emsHotSpotAnnotation.h
//  ChatApplication
//
//  Created by developer on 18/12/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@import Foundation;
@import MapKit;

@class emsHotSpotEssenceView;
@class emsHotSpotEssence;

@protocol HotSpotAnnotationProtocol <NSObject>

- (MKAnnotationView *)annotationViewInMap:(MKMapView *)mapView;

@end




@interface emsHotSpotAnnotation : NSObject  <MKAnnotation, HotSpotAnnotationProtocol>

@property (nonatomic, readwrite) emsHotSpotEssenceView *view;
@property (nonatomic, readonly) emsHotSpotEssence *thumbnail;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


+ (instancetype)annotationWithThumbnail:(id)thumbnail;
- (id)initWithThumbnail:(id)thumbnail;
- (void)updateThumbnail:(id)thumbnail animated:(BOOL)animated;

@end
