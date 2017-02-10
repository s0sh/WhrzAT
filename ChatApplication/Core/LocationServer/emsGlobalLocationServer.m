 //
//  emsGlobalLocationServer.m
//  Scadaddle
//
//  Created by Roman Bigun on 6/12/15.
//  Copyright (c) 2015 Roman Bigun. All rights reserved.
//

#import "emsGlobalLocationServer.h"
#import <UIKit/UIKit.h>



@import AddressBookUI;

@implementation emsGlobalLocationServer

+ (emsGlobalLocationServer *)sharedInstance
{
    
    static emsGlobalLocationServer * _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[emsGlobalLocationServer alloc] init];
        
    });
    
    return _sharedInstance;
}

-(id)init
{
    
    
    self = [super init];
    if(self)
    {
        
        curLocation = [[CLLocation alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate=self;
        locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
        locationManager.distanceFilter=kCLDistanceFilterNone;
        [locationManager requestWhenInUseAuthorization];
        curLocation = [locationManager location];
        
        [locationManager startMonitoringSignificantLocationChanges];
        
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 &&
                [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways)
            {
                [locationManager requestWhenInUseAuthorization];
               
            } else
            {
                [locationManager startUpdatingLocation]; //Will update location immediately
            }
      
       
    }
    
    return self;
    
}
#pragma mark - CLLocationManagerDelegate
/*!
 * @discussion  Authorize user to have access to location service
 */
- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking..");
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User hates you");
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            [locationManager startUpdatingLocation]; //Will update location immediately
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            [locationManager startUpdatingLocation]; //Will update location immediately
        }
        break;
        default:
            break;
    }
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

    NSLog(@"Error getting location \n%@",error.description);
    
}
- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
    
     NSLog(@"Update location error\n%@",error.description);
}

/*!
 * @discussion  updates current user location and send the data to the server
*/
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    curLocation = [locations lastObject];
    [locationManager stopUpdatingLocation];
    NSLog(@"curLocation = %@",curLocation);
    
    
}
/*!
 * @discussion  to get current latitide
 */
-(NSString*)latitude
{
    NSLog(@"Lat:%@",[NSString stringWithFormat:@"%f",curLocation.coordinate.latitude]);
    return [[NSString stringWithFormat:@"%f",curLocation.coordinate.latitude] copy];

}
/*!
 * @discussion  to get current longitude
 */
-(NSString*)longitude
{
    NSLog(@"Long:%@",[NSString stringWithFormat:@"%f",curLocation.coordinate.longitude]);
    return [[NSString stringWithFormat:@"%f",curLocation.coordinate.longitude] copy];
    
}

@end
