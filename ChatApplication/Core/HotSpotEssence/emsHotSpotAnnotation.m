//
//  emsHotSpotAnnotation.m
//  ChatApplication
//
//  Created by developer on 18/12/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "emsHotSpotAnnotation.h"
#import "emsHotSpotEssence.h"
#import "emsHotSpotEssenceView.h"

@implementation emsHotSpotAnnotation



+ (instancetype)annotationWithThumbnail:(emsHotSpotEssence *)thumbnail {
    return [[self alloc] initWithThumbnail:thumbnail];
}

- (id)initWithThumbnail:(emsHotSpotEssence *)thumbnail {
    self = [super init];
    if (self) {
        _coordinate = thumbnail.coordinate;
        _thumbnail = thumbnail;
    }
    return self;
}



- (MKAnnotationView *)annotationViewInMap:(MKMapView *)mapView {
    if (!self.view) {
        self.view = (emsHotSpotEssenceView *)[mapView dequeueReusableAnnotationViewWithIdentifier:0];
        if (!self.view) self.view = [[emsHotSpotEssenceView alloc] initWithAnnotation:self];
    } else {
        self.view.annotation = self;
    }
    [self updateThumbnail:self.thumbnail animated:NO];
    return self.view;
}

- (void)updateThumbnail:(emsHotSpotEssence *)thumbnail animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.33f animations:^{
            _coordinate = thumbnail.coordinate; // use ivar to avoid triggering setter
        }];
    } else {
        _coordinate = thumbnail.coordinate; // use ivar to avoid triggering setter
    }
    
    [self.view updateWithThumbnail:thumbnail];
}



@end
