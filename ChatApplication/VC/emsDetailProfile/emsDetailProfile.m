//
//  ems DetailProfile.m
//  ChatApplication
//
//  Created by developer on 14/01/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import "emsDetailProfile.h"
#import "ApiCall.h"
#import "emsUserProfile.h"
#import "emsHotSpot.h"
#import <MapKit/MapKit.h>
#import "emsHotSpot.h"
#import "UIImageView+AFNetworking.h"
#import "emsHotSpotEssence.h"
#import "emsHotSpotAnnotation.h"
@interface emsDetailProfile (){
    CLLocationManager *locationManager;
    CLLocation *curLocation;
    emsUserProfile *userProfile;
    NSString *isCheckin;
   __block NSString *checkedInSpotId;
    __block BOOL isCheckedIn;
}
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *spotNameLbl;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UITextView *dicriptionTV;
@property (weak, nonatomic) IBOutlet UIImageView *checkInImage;
@end

@implementation emsDetailProfile



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [ [ApiCall sharedInstance] getProfileResultSuccess:^(NSDictionary *success) {
        
        if (success!=nil) {
           userProfile = [[emsUserProfile alloc ] init];
           userProfile.userName = success[@"user"][@"name"];
           userProfile.userDdescription = success[@"user"][@"description"];
            [[NSUserDefaults standardUserDefaults] setValue:userProfile.userDdescription forKey:@"profileUserDescription"];
            [[NSUserDefaults standardUserDefaults] synchronize];
           userProfile.userImageUrl = success[@"user"][@"img"];
            isCheckin = [NSString stringWithFormat:@"%@",success[@"user"][@"isCheckin"]];
            [self.avatarImage setImageWithURL:[NSURL URLWithString:userProfile.userImageUrl] ];
            self.dicriptionTV.text = userProfile.userDdescription;
            self.nameLabel.text =  userProfile.userName ;

        }
        
        if([isCheckin isEqualToString:@"1"]){
            isCheckedIn = YES;
            emsHotSpot * hotSpot = [[emsHotSpot alloc] init];
            NSDictionary *dic =  success[@"user"][@"spot"];
            hotSpot.hotSpotID =dic[@"sId"];
            checkedInSpotId = hotSpot.hotSpotID;
            NSArray *items345 = dic[@"tags"];
            hotSpot.hotSpotTitle = dic[@"name"];
            _spotNameLbl.text = dic[@"name"];
            hotSpot.hotSpotAdress = dic[@"address"];
            hotSpot.hotSpotSiteAdress = dic[@"link"];
            hotSpot.hotSpotPhoneNumber = dic[@"phone"];
            hotSpot.isMember = [NSString stringWithFormat:@"%@",dic[@"is_member"]];
            hotSpot.hotSpotWorkingTime =  dic[@"time"];
            hotSpot.hotSpotImageURL = dic[@"img"][@"path"][@"236_236"];
            hotSpot.rectangularHotSpotImageURL = dic[@"img"][@"path"][@"640_360"];
            hotSpot.hotSpotTags =[[NSMutableArray alloc] initWithArray: items345];
            hotSpot.lontitude = dic[@"lng"];
            hotSpot.langitude = dic[@"lat"];
            [hotSpot.hotSpotMainImage setImageWithURL:[NSURL URLWithString:hotSpot.hotSpotImageURL ]];
            hotSpot.hotSpotType =[dic[@"brightness"] integerValue];
            hotSpot.followersCount = [NSString stringWithFormat:@"%@",dic[@"check_ins"]];
            [self addHotSpots:hotSpot];
            self.checkInImage.image = [UIImage imageNamed:@"checked"];
        }else{
            isCheckedIn = NO;
         self.checkInImage.image = [UIImage imageNamed:@"unchecked"];
        _mapView.showsUserLocation = YES;
        }

    } resultFailed:^(NSString *error) {
        
    }];

}

-(void)viewDidLoad {
    [super viewDidLoad];
    //-----------------------------
    _mapView.delegate = (id)self;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = (id)self;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    //_mapView.showsUserLocation = YES;
    //-----------------------------
    [self cornerIm: self.avatarImage];
}
-(void)cornerIm:(UIView*)imageView{
    imageView .layer.cornerRadius = imageView.frame.size.height / 2 ;
    imageView.layer.masksToBounds = YES;
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            
        } break;
        case kCLAuthorizationStatusDenied: {
            
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    curLocation  = location;
    [manager stopUpdatingLocation];
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation
{
    
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 2.405;
        span.longitudeDelta = 2.405;
        CLLocationCoordinate2D location;
        location.latitude = aUserLocation.coordinate.latitude;
        location.longitude = aUserLocation.coordinate.longitude;
        region.span = span;
        region.center = location;
        [aMapView setRegion:region animated:YES];
        [locationManager stopUpdatingLocation];

}

-(void)initLicator
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = (id)self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
        
        ) {
        [locationManager requestWhenInUseAuthorization];
        
    } else {
        [locationManager startUpdatingLocation]; //Will update location immediately
    }
    
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([[annotation class] isEqual:[MKUserLocation class]]) {
        MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"customAnnotation"];
        view.image = [UIImage imageNamed:@"map_point"];
    
        return view;
    }
    
    if ([annotation conformsToProtocol:@protocol(HotSpotAnnotationProtocol)]) {
        
        return [((NSObject<HotSpotAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}
-(IBAction)leftDrawerButtonPress{
    [APP leftOpen];
}
-(IBAction)LogOut{
    [APP logOut];
    [APP iphoneLogin];
}

-(IBAction)editProfile{
    
    [APP registrationEditProfile];
}

-(void)addHotSpots:(emsHotSpot *)hotSpot{
    
        emsHotSpotEssence *mapAnnotation = [[emsHotSpotEssence alloc] init];
        mapAnnotation.essenceType = (int)hotSpot.hotSpotType;
        
        if (hotSpot.hotSpotMainImage!= nil) {
            mapAnnotation.image = hotSpot.hotSpotMainImage.image;
        }else{
            mapAnnotation.annotationImageUrl = hotSpot.hotSpotImageURL;
        }
        double latitude = [hotSpot.langitude doubleValue];
        double longitude =[hotSpot.lontitude doubleValue];

        mapAnnotation.coordinate =  CLLocationCoordinate2DMake(latitude,
                                                               longitude);
        CLLocationCoordinate2D newCoordinate = [mapAnnotation coordinate];
        CLLocationCoordinate2D oldCoordinate = [self.locationManager.location coordinate];
        CLLocation *newLocation = [[CLLocation alloc] initWithCoordinate: newCoordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:1 timestamp:nil];
        CLLocation *oldLocation = [[CLLocation alloc] initWithCoordinate: oldCoordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:1 timestamp:nil];
        CLLocationDistance kilometers = [newLocation distanceFromLocation:oldLocation] / 914.4;
        int k = kilometers;
        mapAnnotation.distance = [NSString stringWithFormat:@"%d",k];
        oldLocation = nil;
        newLocation = nil;
    
        [self.mapView addAnnotation:[emsHotSpotAnnotation annotationWithThumbnail:mapAnnotation]];

    
    MKMapRect r = [self.mapView visibleMapRect];
    MKMapPoint pt = MKMapPointForCoordinate([mapAnnotation coordinate]);
    r.origin.x = pt.x - r.size.width * 0.7;
    r.origin.y = pt.y - r.size.height * 0.7;
    [self.mapView setVisibleMapRect:r animated:YES];


}
- (void)removeAllPinsButUserLocation
{
    id userLocation = [self.mapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
    if ( userLocation != nil ) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    
    [self.mapView removeAnnotations:pins];
    
    pins = nil;
}
-(void)checkInVoid
{
   
    if(isCheckedIn){
       isCheckedIn = NO;
        
    [[ApiCall sharedInstance] checkInInHotSpot:checkedInSpotId checkIn:NO ResultSuccess:^(NSDictionary *success){
        
        self.checkInImage.image = [UIImage imageNamed:@"unchecked"];
        [self removeAllPinsButUserLocation];
        self.spotNameLbl.text=@"";
        
    } resultFailed:^(NSString *erorr) {
        
    }];
    }
}
-(IBAction)checkIn
{
    
    [self checkInVoid];
    
}



@end
