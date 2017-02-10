//
//  ModalClass.h
//  ChatApplication
//
//  Created by developer on 05/01/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModalClass : NSObject
@property (nonatomic, strong)NSString *userFullName;
@property (nonatomic, strong)NSString *userAvatarImageUrl;
@property (nonatomic, strong)NSString *restToken;
@property (nonatomic, strong)NSString *userID;
@property (nonatomic)BOOL profileCropp;
@property (nonatomic)BOOL newHotSpot;
@property (nonatomic)BOOL hotSpotCropp;
//-------------------------------------------
@property (nonatomic, strong)NSString *serverToken;
@property (nonatomic, strong)NSString *lonfitude;
@property (nonatomic, strong)NSString *lantitude;
@property (nonatomic, strong)NSString *placeName;
@property (nonatomic, strong)NSString *localPrice;
@property (nonatomic, strong)NSString *carBrand;
@property (nonatomic, strong)NSString *carModel;
@property (nonatomic)int selectedModelIndex;
@property (nonatomic)int selectedCarIndex;
@property (nonatomic, strong)NSString *carYear;
@property (nonatomic, strong)NSString * carDescription;
@property (nonatomic, strong)UIImageView *carImage;
@property (nonatomic, strong)UIImageView *carColorImage;
@property (nonatomic, strong)NSString *carColorName;
@property (nonatomic, strong)NSString *licenseNumber;
@property (nonatomic, strong)NSString *phoneNumber;
@property (nonatomic, strong)NSString *carModelNiceName;
@property (nonatomic, strong)NSString *carMarkNiceName;
@property (nonatomic, strong)NSString *carMarkURL;

@property (nonatomic, strong)NSString *carDeliiveryTime;
@property (nonatomic, strong)NSString *carSpeshiallInstracton;

@property (nonatomic, strong)NSString *prise;
@property (nonatomic, strong)NSString *currentOrderID;
@property (nonatomic, strong)NSString *currentOrderStatus;
@property (nonatomic, strong)NSString *paymentPaid;
@property (nonatomic, strong)NSString *finalCost;

@property (nonatomic, strong)NSString *street;
@property (nonatomic, strong)NSString *latitude;
@property (nonatomic, strong)NSString *longitude;

+ (ModalClass *)sharedInstance;
-(void)storeUserData:(NSDictionary *)dic;
-(void)restoreUserData;
@end
