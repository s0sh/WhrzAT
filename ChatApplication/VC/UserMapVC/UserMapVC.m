//
//  UserMapVC.m
//  ChatApplication
//
//  Created by developer on 25/06/14.
//  Copyright (c) 2014 developer. All rights reserved.
//

#import "UserMapVC.h"
#import <CoreLocation/CoreLocation.h>
#import "DetailUserVC.h"
#import "AFNetworking.h"
#import "userCell.h"
#import "imageVC.h"
#import "ApiCall.h"
//-----------------------------
#import "emsHotSpotEssence.h"
#import "emsHotSpotEssenceView.h"
#import "emsHotSpotAnnotation.h"
#import "emsHotSpot.h"
#import "emsHotSptListCell.h"
#import "emsImagesVC.h"
#import "emsDetailHotSpot.h"
#import "ModalClass.h"
#import "UIImageView+AFNetworking.h"
#import "hotSpotImage.h"
#import "DetailChatVC.h"

@interface UserMapVC ()<MKMapViewDelegate>{
    
    bool needLoad;
    int ofsetToScroll;
    BOOL firstShow;
    BOOL dounloadLeft;
    BOOL dounloadRight;
    int devider;
    int sizes;
    int ipadChecker;
    //----------------------------------
    CLLocationManager *locationManager;
    CLLocation *curLocation;
    MKAnnotationView *pinView;
    BOOL didParse;
    int deviderTable;
    BOOL didOnce;
    NSString *checkedHotspotId;
    
    
    
    
    int curFavoriteIndex;
    emsHotSpot *selctedHotSpot;
    
    
    
}

@property(nonatomic, retain) CLLocationManager *locationManager;
@property(weak,nonatomic) IBOutlet UITableView* favoritesTableView;
@property (retain, nonatomic )NSIndexPath *previousDisplayedIndexPath;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak,nonatomic)IBOutlet UIScrollView *tagsScrol;
@property (weak, nonatomic) IBOutlet UITextField *searchTags;
@property (retain, nonatomic) NSMutableArray *usersWithTags;
@property (retain, nonatomic) NSMutableArray * tagsForSearch;
@property (weak, nonatomic) IBOutlet UIButton *arrowLeftBTN;
@property (weak, nonatomic) IBOutlet UIButton *arrowRightBTN;
@property (retain, nonatomic)NSString *currentRequest;
@property (nonatomic, assign) int loadStep;
@property (nonatomic, assign) int startStap;
@property (nonatomic) BOOL isLoadingForUp;
@property (nonatomic, assign) float topInset;
@property(weak,nonatomic) IBOutlet UITableView* tableViewThisNearestHS;

// -----------------
@property (nonatomic, retain)NSMutableArray *buttonsArray;
@property (nonatomic, weak) IBOutlet UIButton *firstBtn;
@property (nonatomic, weak) IBOutlet UIButton *secondBtn;
@property (nonatomic, weak) IBOutlet UIView *baseView;
@property (nonatomic, weak) IBOutlet UIView *firstView;
@property (nonatomic, weak) IBOutlet UIView *secondView;
//------------------------
@property (nonatomic, weak) IBOutlet UITableView *listTableView;
@property (nonatomic, retain)NSMutableArray *parseArray;
@property (nonatomic, retain)NSMutableArray *parseArrayHotSpotDictionary;
@property (nonatomic, retain)NSMutableArray *annotationsArray;
@property (nonatomic, retain)NSMutableArray *hotSpotsArray;
//-----------------------
@property (nonatomic, weak) IBOutlet UIView *thankYouView;
@property (nonatomic, weak) IBOutlet UIView *bgViewThankYou;
//------------------------
@property (retain, nonatomic) NSMutableArray *nearHotSpotArr;


@end

@implementation UserMapVC

double (^expression) (double, double, double);

-(void)setRadius
{

    double miles = 5.0;
    double scalingFactor = ABS( (cos(2 * M_PI * curLocation.coordinate.latitude / 360.0) ));
    MKCoordinateSpan span;
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/(scalingFactor * 69.0);
    MKCoordinateRegion region;
    region.span = span;
    region.center = curLocation.coordinate;
    [_mapView setRegion:region animated:YES];

    
    
}
-(void)reloadMap
{
    [self removeAnnotationsFromMap];
    didOnce = NO;
    [self.view addSubview:self.thankYouView];
    self.thankYouView.hidden = YES;
    
    [self setUpButtons];
    [self setUpSubviews];
     _mapView.delegate = self;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLLocationAccuracyKilometer;
    // showing user location with the blue dot
    [self.mapView setShowsUserLocation:YES];
    
    self.mapView.delegate = self;
    
    CLLocation *location = [_locationManager location];
    CLLocationCoordinate2D  coordinate = [location coordinate];
    
    // showing them in the mapView
    _mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 250, 250);
    [locationManager startUpdatingLocation];
    
    //-----------------------------
    self.favoritesTableView.transform =  CGAffineTransformMakeRotation(-(M_PI/2));
    self.usersWithTags = [[NSMutableArray alloc] init];
    //---------------------------------------
    self.searchTags.layer.cornerRadius= 4.0f;
    self.searchTags.layer.masksToBounds=YES;
    self.searchTags.layer.borderWidth= 0.5f;
    //---------------------------------------
    [[self.searchTags layer] setBorderColor:[[UIColor colorWithRed:136.0/255.0
                                                             green:198.0/255.0
                                                              blue:200.0/255.0
                                                             alpha:1.0] CGColor]];
    
    UIColor *color = [UIColor colorWithRed:136.0/255.0
                                     green:198.0/255.0
                                      blue:200.0/255.0
                                     alpha:1.0] ;
    self.searchTags.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.searchTags.placeholder attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:13.0]}];
    
    [self tryToGoToChatAfterPush];


}
- (void)viewDidLoad
{
    [super viewDidLoad];//-------------------
    self.nearHotSpotArr = [[NSMutableArray alloc] init];
    self.hotSpotsArray = [[NSMutableArray alloc] init];
    self.annotationsArray = [[NSMutableArray alloc] init];
    self.parseArray = [[NSMutableArray alloc] init];
    self.parseArrayHotSpotDictionary = [[NSMutableArray alloc] init];
    [self reloadMap];
    
}
-(void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:YES];
    

}
-(void)setUpSelfThankYouView{
    
    
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
    if ([self.nearHotSpotArr count]) {
        
        self.thankYouView.frame = CGRectMake( 0 , self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        self.thankYouView.hidden = NO;
        
        [UIView animateWithDuration:0.4 animations:^{
            self.thankYouView.frame  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                self.bgViewThankYou.alpha = 1;
            }];
        }];
        
    }
        
          });
}




-(IBAction)hideLeftHardThankYouView{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.bgViewThankYou.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.thankYouView.frame =CGRectMake( self.bgViewThankYou.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}
-(void)tryToGoToChatAfterPush
{
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"fromPush"] isEqualToString:@"1"])
    {
        NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] valueForKey:@"pushData"];
        UIViewController *chat = [[DetailChatVC alloc] initWithUser:[NSString stringWithFormat:@"%@",[[dictionary valueForKey:@"aps"] valueForKey:@"userId"]] andName:[[dictionary valueForKey:@"aps"] valueForKey:@"userName"] andIDChat:[NSString stringWithFormat:@"%@",[[dictionary valueForKey:@"aps"] valueForKey:@"chatId"]]];
        [self presentViewController:chat animated:YES completion:^{
            
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"pushData"];
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"fromPush"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }];
    }

}
-(IBAction)checkInInNearSpot{
     if (selctedHotSpot !=nil) {
    [MC showMBProgressHUD];
    [UIView animateWithDuration:0.4 animations:^{
        self.bgViewThankYou.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.thankYouView.frame =CGRectMake( self.bgViewThankYou.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            NSLog(@">call completion check");
           
                NSLog(@">call completion check2");
                [[ApiCall sharedInstance] checkInInHotSpot:selctedHotSpot.hotSpotID checkIn:YES ResultSuccess:^(NSDictionary *succeess) {
                    
                    emsHotSpot * hotSpot = [[emsHotSpot alloc] init];
                    hotSpot.hotSpotImages = [[NSMutableArray alloc] init];
                
                    
                    for (NSDictionary *dictionary in succeess[@"spot"][@"files"]) {
                        
                        hotSpotImage *spotImage = [[hotSpotImage alloc] init];
                        spotImage.ownerID = dictionary[@"uId"];
                        spotImage.fileID = dictionary[@"fId"];
                        spotImage.loveCounter = dictionary[@"love_count"];
                        spotImage.imageUrl =dictionary[@"spotPath"][@"640_360"];
                        spotImage.kubImageUrl =dictionary[@"spotPath"][@"236_236"];
                        spotImage.ownerName =dictionary[@"name"];
                        spotImage.ownerAvaUrl =dictionary[@"userPath"][@"236_236"];
                        spotImage.isMyFriend =[NSString stringWithFormat:@"%@",dictionary[@"isMyFriend"]] ;
                        [hotSpot.hotSpotImages addObject:spotImage];
                    }
                    
                    hotSpot.hotSpotID =succeess[@"spot"][@"sId"];
                    NSArray *items345 = succeess[@"spot"][@"tags"];
                    hotSpot.hotSpotDistance = succeess[@"spot"][@"distance"];
                    hotSpot.hotSpotDescription = succeess[@"spot"][@"description"];
                    hotSpot.hotSpotTitle = succeess[@"spot"][@"name"];
                    hotSpot.hotSpotAdress = succeess[@"spot"][@"address"];
                    hotSpot.hotSpotSiteAdress = succeess[@"spot"][@"link"];
                    hotSpot.hotSpotPhoneNumber = succeess[@"spot"][@"phone"];
                    hotSpot.isMember = [NSString stringWithFormat:@"%@",succeess[@"spot"][@"is_member"]];
                    hotSpot.hotSpotWorkingTime =  succeess[@"spot"][@"time"];
                    hotSpot.hotSpotImageURL = succeess[@"spot"][@"img"][@"path"][@"236_236"];
                    hotSpot.rectangularHotSpotImageURL = succeess[@"spot"][@"img"][@"path"][@"640_360"];
                    hotSpot.hotSpotTags =[[NSMutableArray alloc] initWithArray: items345];
                    hotSpot.lontitude = succeess[@"spot"][@"lng"];
                    hotSpot.langitude = succeess[@"spot"][@"lat"];
                    [hotSpot.hotSpotMainImage setImageWithURL:[NSURL URLWithString:hotSpot.hotSpotImageURL ]];
                    hotSpot.hotSpotType =[succeess[@"spot"][@"brightness"] integerValue];
                    hotSpot.followersCount = [NSString stringWithFormat:@"%@",succeess[@"spot"][@"check_ins"]];
                    hotSpot.isPromotion = [succeess[@"spot"][@"isPromotion"] boolValue];
 hotSpot.isSelected = @"1";
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                         [self presentViewController:[[emsDetailHotSpot alloc] initWithHotSpot:hotSpot] animated:YES completion:^{
                             [MC hideMBProgressHUD];
                             
                         }];
                         
//                         [self presentViewController:[[emsImagesVC alloc] initWithHotSpot:hotSpot] animated:YES completion:^{
//                             [MC hideMBProgressHUD];
//                         }];
                        
                    
                    [MC hideMBProgressHUD];
                     }];
                    
                } resultFailed:^(NSString *error) {
                    
                }];
                
           
            
        }];
    }];
}
}





-(IBAction)getChat:(id)sender{
    
    [self presentViewController:[[DetailChatVC alloc]init] animated:YES completion:^{
        
    }];
    
}

-(void)getHotSpots{
    
    
    
    [[ApiCall sharedInstance] getHotSpotLisResultSuccess:^(NSDictionary *seccess) {
        
        
        for (int i = 0; i !=[seccess[@"nearestSpots"] count]; i++){
            emsHotSpot * nearHotSpot = [[emsHotSpot alloc] init];
            NSDictionary *dictionaryNear = [seccess[@"nearestSpots"] objectAtIndex:i];
            
            for (NSDictionary *dictidictionaryNearFiles  in dictionaryNear[@"files"]) {
                
                hotSpotImage *spotImage = [[hotSpotImage alloc] init];
                spotImage.ownerID = dictidictionaryNearFiles[@"uId"];
                spotImage.fileID = dictidictionaryNearFiles[@"fId"];
                spotImage.loveCounter = dictidictionaryNearFiles[@"love_count"];
                spotImage.imageUrl = dictidictionaryNearFiles[@"spotPath"][@"640_360"];
                spotImage.kubImageUrl = dictidictionaryNearFiles[@"spotPath"][@"236_236"];
                spotImage.ownerName = dictidictionaryNearFiles[@"name"];
                spotImage.ownerAvaUrl = dictidictionaryNearFiles[@"userPath"][@"236_236"];
                spotImage.isMyFriend =[NSString stringWithFormat:@"%@",dictidictionaryNearFiles[@"isMyFriend"]] ;
                [nearHotSpot.hotSpotImages addObject:spotImage];
            }
            
            nearHotSpot.hotSpotID =dictionaryNear[@"sId"];
            NSArray *items345 = dictionaryNear[@"tags"];
            nearHotSpot.hotSpotDescription = dictionaryNear[@"description"];
            nearHotSpot.hotSpotTitle = dictionaryNear[@"name"];
            nearHotSpot.hotSpotAdress = dictionaryNear[@"address"];
            nearHotSpot.hotSpotSiteAdress = dictionaryNear[@"link"];
            nearHotSpot.hotSpotPhoneNumber = dictionaryNear[@"phone"];
            nearHotSpot.isMember = [NSString stringWithFormat:@"%@",dictionaryNear[@"is_member"]];
            nearHotSpot.hotSpotWorkingTime =  dictionaryNear[@"time"];
            nearHotSpot.hotSpotImageURL = dictionaryNear[@"img"][@"path"][@"236_236"];
            nearHotSpot.rectangularHotSpotImageURL = dictionaryNear[@"img"][@"path"][@"640_360"];
            nearHotSpot.hotSpotTags =[[NSMutableArray alloc] initWithArray: items345];
            nearHotSpot.lontitude = dictionaryNear[@"lng"];
            nearHotSpot.langitude = dictionaryNear[@"lat"];
            [nearHotSpot.hotSpotMainImage setImageWithURL:[NSURL URLWithString:nearHotSpot.hotSpotImageURL ]];
            nearHotSpot.hotSpotType =[dictionaryNear[@"brightness"] integerValue];
            nearHotSpot.followersCount = [NSString stringWithFormat:@"%@",dictionaryNear[@"check_ins"]];
            nearHotSpot.isSelected = @"0";
            nearHotSpot.hotSpotDistance = dictionaryNear[@"distance"];
            nearHotSpot.isPromotion = [dictionaryNear[@"isPromotion"] boolValue];
            [self.nearHotSpotArr addObject:nearHotSpot];
            
            
            
        }
        
        for (NSDictionary *dic in seccess[@"spots"]) {
            
            emsHotSpot * hotSpot = [[emsHotSpot alloc] init];
            hotSpot.hotSpotImages = [[NSMutableArray alloc] init];
            
            
            for (NSDictionary *dictionary in dic[@"files"]) {
                
                hotSpotImage *spotImage = [[hotSpotImage alloc] init];
                spotImage.ownerID = dictionary[@"uId"];
                spotImage.fileID = dictionary[@"fId"];
                spotImage.loveCounter = dictionary[@"love_count"];
                spotImage.imageUrl =dictionary[@"spotPath"][@"640_360"];
                spotImage.kubImageUrl =dictionary[@"spotPath"][@"236_236"];
                spotImage.ownerName =dictionary[@"name"];
                spotImage.ownerAvaUrl =dictionary[@"userPath"][@"236_236"];
                spotImage.isMyFriend =[NSString stringWithFormat:@"%@",dictionary[@"isMyFriend"]] ;
                [hotSpot.hotSpotImages addObject:spotImage];
            }
            
            hotSpot.hotSpotID =dic[@"sId"];
            NSArray *items345 = dic[@"tags"];
            hotSpot.hotSpotDescription = dic[@"description"];
            hotSpot.hotSpotTitle = dic[@"name"];
            hotSpot.hotSpotAdress = dic[@"address"];
            hotSpot.hotSpotSiteAdress = dic[@"link"];
            hotSpot.hotSpotPhoneNumber = dic[@"phone"];
            hotSpot.isMember = [NSString stringWithFormat:@"%@",dic[@"is_member"]];
            hotSpot.hotSpotWorkingTime =  dic[@"time"];
            hotSpot.hotSpotImageURL = [(NSArray*)dic[@"img"] count]>0?dic[@"img"][@"path"][@"236_236"]:@"";
            hotSpot.rectangularHotSpotImageURL = [(NSArray*)dic[@"img"] count]>0?dic[@"img"][@"path"][@"640_360"]:@"";
            hotSpot.hotSpotTags =[[NSMutableArray alloc] initWithArray: items345];
            hotSpot.lontitude = dic[@"lng"];
            hotSpot.langitude = dic[@"lat"];
            [hotSpot.hotSpotMainImage setImageWithURL:[NSURL URLWithString:hotSpot.hotSpotImageURL ]];
            hotSpot.hotSpotType =[dic[@"brightness"] integerValue];
            hotSpot.followersCount = [NSString stringWithFormat:@"%@",dic[@"check_ins"]];
            hotSpot.hotSpotDistance = dic[@"distance"];
            [self.hotSpotsArray addObject:hotSpot];
            
            hotSpot.isPromotion = [dic[@"isPromotion"] boolValue];
        }
        
        [self addHotSpots];
        [self.listTableView reloadData];
        [self.tableViewThisNearestHS reloadData];
        
        [self performSelector:@selector(setUpSelfThankYouView) withObject:nil afterDelay:3];
    } resultFailed:^(NSString *error) {
        
    }];
}




-(void)addHotSpots{
    
    for (int i = 0 ; i != [self.hotSpotsArray count]; i++) {
        
        emsHotSpot *hotSpot = [self.hotSpotsArray objectAtIndex:i];
        
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
        
        __weak typeof(emsHotSpotEssence) *weakMapAnnotation = mapAnnotation;
        
        mapAnnotation.deleteBlock = ^(id<MKAnnotation> obj){
            
            [self.mapView removeAnnotation: obj];
            
        };
        
        mapAnnotation.followBlock = ^(id<MKAnnotation> obj){
            
            [self.mapView removeAnnotation: obj];
            
        };
        
        mapAnnotation.closeSelfOnMap  = ^(id<MKAnnotation> obj){
            
            [self.mapView deselectAnnotation:obj animated:YES ];
            
        };
        
        mapAnnotation.infoBlock = ^{
            
            [self test:i];
        };
        
        
        [self.mapView addAnnotation:[emsHotSpotAnnotation annotationWithThumbnail:mapAnnotation]];
        [self.annotationsArray  addObject:mapAnnotation];
    }
    
    
    [self.favoritesTableView reloadData];
    
}

- (void)scrollToUser:(int)roundedValue {
    
    
    emsHotSpotAnnotation *annotation  = [self.annotationsArray objectAtIndex:roundedValue];
    
    MKMapRect r = [self.mapView visibleMapRect];
    MKMapPoint pt = MKMapPointForCoordinate([annotation coordinate]);
    r.origin.x = pt.x - r.size.width * 0.7;
    r.origin.y = pt.y - r.size.height * 0.7;
    [self.mapView setVisibleMapRect:r animated:YES];
    
}

-(void)test:(int)idUser{
    
    [self.favoritesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idUser  inSection:0]
                                   atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(MapEssenceViewProtocol)]) {
        [((NSObject<MapEssenceViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(MapEssenceViewProtocol)]) {
        [((NSObject<MapEssenceViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}
-(void)createHotSpots{
    
    [self.favoritesTableView reloadData];
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
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    curLocation  = location;
    [self setRadius];
    [manager stopUpdatingLocation];
}
- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation
{
    if (didParse != YES) {
        
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
        
        didParse = YES;
        // [self parseData];
    }
    
}

-(IBAction)secondBynAction{
    
    [UIView animateWithDuration:.4 animations:^{
        self.secondView.frame = CGRectMake(0, 0 , self.baseView.frame.size.width,  self.baseView.frame.size.height);
        self.firstView.frame = CGRectMake(320, 0 , self.baseView.frame.size.width,  self.baseView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}
-(IBAction)firstBynAction{
    
    [UIView animateWithDuration:.4 animations:^{
        self.secondView.frame = CGRectMake(320 , 0 , self.baseView.frame.size.width,  self.baseView.frame.size.height);
        self.firstView.frame = CGRectMake(0, 0 , self.baseView.frame.size.width,  self.baseView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)setUpSubviews{
    
    self.secondView.frame = CGRectMake((self.baseView.frame.origin.x + 320), 0 , self.baseView.frame.size.width,  self.baseView.frame.size.height);
    self.firstView.frame = CGRectMake(self.baseView.frame.origin.x, 0 , self.baseView.frame.size.width,  self.baseView.frame.size.height);
    [self.baseView addSubview:self.secondView];
    [self.baseView addSubview:self.firstView];
}



-(IBAction)selectBTN:(UIButton*)sender{
    
    for (UIButton *btn in self.buttonsArray) {
        [btn setSelected:NO];
    }
    UIButton *btn =(UIButton *)[self.buttonsArray objectAtIndex:sender.tag];
    [btn setSelected:YES];
}

-(void)setUpButtons{
    self.buttonsArray = [[NSMutableArray alloc] init];
    [self.buttonsArray addObject:self.firstBtn];
    [self.buttonsArray addObject:self.secondBtn];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    
}
-(void)setUpUI{
    self.favoritesTableView.transform =  CGAffineTransformMakeRotation(-(M_PI/2));
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
        [locationManager startUpdatingLocation];
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([[annotation class] isEqual:[MKUserLocation class]]) {
        MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"customAnnotation"];
        view.image = [UIImage imageNamed:@"map_point"];
        
        
        CLLocation *location = [[CLLocation alloc]initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
        [[[CLGeocoder alloc]init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark = placemarks[0];
            NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
            NSString *addressString = [lines componentsJoinedByString:@"\n"];
            NSLog(@"Address: %@", addressString);
            
            addressString= [NSString stringWithFormat:@"%@ %@",placemark.thoroughfare ,placemark.subThoroughfare ];
            
            [ModalClass sharedInstance].latitude = [NSString stringWithFormat:@"%f",annotation.coordinate.latitude];
            [ModalClass sharedInstance].longitude = [NSString stringWithFormat:@"%f",annotation.coordinate.longitude];
            [ModalClass sharedInstance].street = addressString;
            if(didOnce==NO){
               [self getHotSpots];
            }
        }];
        return view;
    }
    
    if ([annotation conformsToProtocol:@protocol(HotSpotAnnotationProtocol)]) {
        
        return [((NSObject<HotSpotAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.favoritesTableView) {
        return 320;
    }else{
        return 80;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tableViewThisNearestHS) {
        return  [self.nearHotSpotArr count];
    }else{
        return [self.self.hotSpotsArray count];
    }
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    emsHotSptListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    
    if (!cell) {
        
        NSArray* xibCell = [[NSBundle mainBundle] loadNibNamed:@"emsHotSptListCell" owner:self options:nil];
        
        if (tableView == self.favoritesTableView)cell = [xibCell objectAtIndex:1];
        if (tableView == self.tableViewThisNearestHS)cell = [xibCell objectAtIndex:2];
        if (tableView == self.listTableView)cell = [xibCell objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    
    emsHotSpot *hotSpot;
    if (tableView == self.favoritesTableView || tableView == self.listTableView) {
        hotSpot = [self.hotSpotsArray objectAtIndex:indexPath.row];
    }else{
        hotSpot = [self.nearHotSpotArr objectAtIndex:indexPath.row];
    }
    
    if(hotSpot.isPromotion){
        cell.hotSpotPromoted.alpha=1;
    }
    else{
        cell.hotSpotPromoted.alpha=0;
    }
    cell.cellUsersCount.text = hotSpot.followersCount;
    
    switch (hotSpot.hotSpotType) {
            
        case firstTipe:
            cell.hotSpotReitingImage.image = [UIImage imageNamed:@"flame_grey_1"];
            break;
        case secondTipe:
            cell.hotSpotReitingImage.image = [UIImage imageNamed:@"flame_grey_2"];
            break;
        case thirdTipe:
            cell.hotSpotReitingImage.image = [UIImage imageNamed:@"flame_grey_3"];
            break;
        case fourthTipe:
            cell.hotSpotReitingImage.image = [UIImage imageNamed:@"flame_grey_4"];
            break;
        case fifthTipe:
            cell.hotSpotReitingImage.image = [UIImage imageNamed:@"flame_grey_5"];
            break;
            
            
    }
    
    cell.tag = indexPath.row;
    
    if (tableView == self.tableViewThisNearestHS){
        cell.cellSelectBtn.tag = indexPath.row;
        
        [cell.cellSelectBtn  setImage:[UIImage imageNamed:@"unchecked_hp"] forState:UIControlStateNormal];
        
        if ([hotSpot.hotSpotID isEqualToString:selctedHotSpot.hotSpotID]) {
            [cell.cellSelectBtn  setImage:[UIImage imageNamed:@"checked_hp"] forState:UIControlStateNormal];
        }
        [cell.cellSelectBtn addTarget:self action:@selector(selectHotSpot:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    
    cell.tag = indexPath.row;
    hotSpotImage *hsi = [hotSpot.hotSpotImages lastObject];
    if(hsi){
         [cell.cellImage setImageWithURL:[NSURL URLWithString:hsi.imageUrl]];
    }
    else{
    
        [cell.cellImage setImageWithURL:[NSURL URLWithString:hotSpot.hotSpotImageURL]];
    }
    
    cell.cellHotSpotTitle.text = hotSpot.hotSpotTitle;
    cell.cellPhotoCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)[hotSpot.hotSpotImages count]==0?1:(unsigned long)[hotSpot.hotSpotImages count]];
    if (tableView == self.favoritesTableView)cell.transform = CGAffineTransformMakeRotation(1.57);
    
    [self cornerIm: cell.cellImage];
    
    return cell;
}


-(IBAction)selectHotSpot:(UIButton *)button{
      
    //[self.tableViewThisNearestHS reloadData];
    
}

-(IBAction)leftDrawerButtonPress{
    [APP leftOpen];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSArray *selectedRows = [tableView indexPathsForSelectedRows];
    for(NSIndexPath *i in selectedRows)
    {
        if(![i isEqual:indexPath])
        {
            [tableView deselectRowAtIndexPath:i animated:NO];
        }
    }
    
    
    [MC showMBProgressHUD];
    if(self.tableViewThisNearestHS!=tableView)
    {
        emsHotSpot *hs = [self.hotSpotsArray objectAtIndex:indexPath.row];
        
        [self presentViewController:[[emsDetailHotSpot alloc] initWithHotSpot:hs] animated:YES completion:^{
            [MC hideMBProgressHUD];
        }];
        
        
         /*
         [self presentViewController:[[emsImagesVC alloc] initWithHotSpot:hs] animated:YES completion:^{
         [MC hideMBProgressHUD];
         }];
        */
         
         
        
    }
    else{
    
        
        selctedHotSpot = [self.nearHotSpotArr objectAtIndex:indexPath.row];
        NSLog(@"%@",selctedHotSpot.hotSpotID);
    
    }
    [[self tableView:tableView cellForRowAtIndexPath:indexPath] setSelected:YES animated:YES];
    [MC hideMBProgressHUD];
    
}
-(void)cornerIm:(UIView*)imageView{
    imageView .layer.cornerRadius = imageView.frame.size.height / 2 ;
    imageView.layer.masksToBounds = YES;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)takeMeLeft{
    if(self.hotSpotsArray.count>0){
        if(curFavoriteIndex>0){
            curFavoriteIndex--;
            if(curFavoriteIndex>=0){
                [self.favoritesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:curFavoriteIndex inSection:0]
                                               atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
            }
        }
    }
}
-(IBAction)takeMeRight{
    
    if(self.hotSpotsArray.count>0){
        if(curFavoriteIndex<self.hotSpotsArray.count-1){
            curFavoriteIndex++;
            [self.favoritesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:curFavoriteIndex inSection:0]
                                           atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        }}
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.hotSpotsArray count]) {
        deviderTable =scrollView.contentOffset.y /320;
        [self scrollToUser:deviderTable ];
        
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    UITableViewCell *cell = [[_favoritesTableView visibleCells] lastObject];
    NSLog(@"Visible Cell :%ld",cell.tag);
    curFavoriteIndex = cell.tag;
}

-(void)removeAnnotationsFromMap
{

    NSMutableArray *locs = [[NSMutableArray alloc] init];
    
    for (id <MKAnnotation> annot in [self.mapView annotations])
    {
        if ( [annot isKindOfClass:[ MKUserLocation class]] ) {
        }
        else {
            [locs addObject:annot];
        }
    }
    [self.mapView removeAnnotations:locs];
    locs = nil;

    

}
-(IBAction)searchAction:(id)sender{
    
    [self.searchTags resignFirstResponder];
    if([self.searchTags.text isEqualToString:@""]){
        [self removeAnnotationsFromMap];
        [self.hotSpotsArray removeAllObjects];
        [self getHotSpots];
        return;
    
    }
    
    //
    [[ApiCall sharedInstance]getHotSpotLisеSearch:self.searchTags.text andResult:^(NSDictionary *seccess) {
        
        NSArray *spots = seccess[@"spots"];
        if(spots.count==0){
        
            [[[UIAlertView alloc] initWithTitle:@"Search" message:@"Nothing matched your search" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            return;
        
        }
        else
        {
            [self removeAnnotationsFromMap];
            [self.hotSpotsArray removeAllObjects];
        
        }
        for (NSDictionary *dic in seccess[@"spots"]) {
            
            emsHotSpot * hotSpot = [[emsHotSpot alloc] init];
            hotSpot.hotSpotImages = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dictionary in dic[@"files"]) {
                
                hotSpotImage *spotImage = [[hotSpotImage alloc] init];
                spotImage.ownerID = dictionary[@"uId"];
                spotImage.imageUrl =dictionary[@"spotPath"][@"640_360"];
                spotImage.kubImageUrl =dictionary[@"spotPath"][@"236_236"];
                spotImage.ownerName =dictionary[@"name"];
                spotImage.ownerAvaUrl =dictionary[@"userPath"][@"236_236"];
                [hotSpot.hotSpotImages addObject:spotImage];
            }
            
            hotSpot.hotSpotID =dic[@"sId"];
            NSArray *items345 = dic[@"tags"];
            
            hotSpot.hotSpotTitle = dic[@"name"];
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
            hotSpot.hotSpotDistance = dic[@"distance"];
            [self.hotSpotsArray addObject:hotSpot];
        }
        
        [self addHotSpots];
        [self.listTableView reloadData];
        [self.tableViewThisNearestHS reloadData];
    } resultFailed:^(NSString *error) {
        
    }];
    
    
    
}



@end
