//
//  User.h
//  ChatApplication
//
//  Created by developer on 27/06/14.
//  Copyright (c) 2014 developer. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum { // нолайн/офлайн
    UserOffline,
    UserOnline
    
} currentUserState;

@interface User : NSObject


//@property (nonatomic, readonly) AdLocation* nearestLocation;

//

@property (nonatomic, retain) NSString* userID;

@property (nonatomic, retain) NSNumber* userAge;

@property (retain, nonatomic) NSString *imageURLString;

@property (nonatomic, retain) NSString *firstName;

@property (nonatomic, retain) NSString *listName;

@property (nonatomic, retain) NSString *currentStatus;

@property (nonatomic, retain) NSString *eMail;

@property (nonatomic, retain) NSMutableArray *tagsArray;

@property (nonatomic, retain) NSString* latitude;

@property (nonatomic, retain) NSString* longitude;

@property (nonatomic, retain) NSString *DoB;

@property (nonatomic, retain) NSString *about;

@property (nonatomic, retain) NSString *imageURL;

@property (nonatomic, retain) UIImage *dounloadImage;

@property (nonatomic, retain) NSString *userLogin;

@property (nonatomic, retain) NSString *isMeFriend;

@property (nonatomic, retain) NSString *isOnline;

@property (nonatomic, retain) NSString *last_modif;

@property (nonatomic, retain) NSString *isInFaforite;

//@property (nonatomic, retain) CLLocation* currentUserLocation;



@end
