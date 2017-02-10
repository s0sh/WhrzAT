//
//  emsHotSpotEssenceView.h
//  ChatApplication
//
//  Created by developer on 18/12/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

static CGFloat const  MapEssenceViewStandardWidth     = 155.0f;
static CGFloat const  MapEssenceViewStandardHeight    = 44.0f;
static CGFloat const  MapEssenceViewExpandOffset      = 170.0f;
static CGFloat const  MapEssenceViewVerticalOffset    = 34.0f;
static CGFloat const  MapEssenceViewAnimationDuration = 0.25f;


typedef NS_ENUM(NSInteger, MapEssenceViewState) {
    MapEssenceViewStateCollapsed,
    MapEssenceViewStateExpanded,
    MapEssenceViewStateAnimating,
};
@protocol MapEssenceViewProtocol <NSObject>

- (void)didSelectAnnotationViewInMap:(MKMapView *)mapView ;
- (void)didDeselectAnnotationViewInMap:(MKMapView *)mapView;

@end

@interface emsHotSpotEssenceView : MKAnnotationView<MapEssenceViewProtocol>
- (id)initWithAnnotation:(id<MKAnnotation>)annotation;
- (void)updateWithThumbnail:(id)mapEssence ;
@end
