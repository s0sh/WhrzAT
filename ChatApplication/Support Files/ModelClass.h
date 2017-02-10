//
//  ModelClass.h
//  ChatApplication
//
//  Created by developer on 26/06/14.
//  Copyright (c) 2014 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelClass : NSObject

+ (ModelClass *) sharedModel;

- (void)saveData:(id)data toArchive:(NSString *)arshive;

- (id)getDataFromArchive:(NSString *)arshive;

- (void) alertText:(NSString *)txt;

- (BOOL) validateEmail: (NSString *) candidate;

- (UIImage *) getMainImageView:(UIView *)view;

- (BOOL) isRetina;

- (BOOL)connected;

-(void)hideMBProgressHUD;


-(void)showMBProgressHUD;

-(void)informText:(NSString *)txt;

- (BOOL)connectedCheck;

@end
