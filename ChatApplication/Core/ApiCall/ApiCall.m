//
//  ApiCall.m
//  ChatApplication
//
//  Created by developer on 04/09/14.
//  Copyright (c) 2014 developer. All rights reserved.
//

#import "ApiCall.h"
#import "ModalClass.h"
#import "AFNetworking.h"
#import "emsGlobalLocationServer.h"
@implementation ApiCall

@synthesize userId ,userAvatar ,deviceToken;

+ (ApiCall *)sharedInstance
{
    
    static ApiCall * _sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        _sharedInstance = [[ApiCall alloc] init];
        
    });
    
    return _sharedInstance;
}
-(void)profileDeleteWithResultSuccess:(void (^)(BOOL))succeess resultFailed:(void (^)(NSString *))failed
{
    [MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                             URLString:[NSString stringWithFormat:kSeerverPath postfixDeleteProfile]
                                                                            parameters:dc error:nil];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            
            [MC hideMBProgressHUD];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                succeess([responseObject[@"success"] isEqualToString:@"1"]?YES:NO);
                
            }
        } else {
            [MC hideMBProgressHUD];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    

}

-(void)friendAccept:(NSString*)friendId beMyFriend:(BOOL)be_friend ResultSuccess:(void (^)(BOOL))succeess resultFailed:(void (^)(NSString *))failed
{
    [MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        friendId , @"friendId",
                        be_friend?@"1":@"0", @"friend",
                        nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                             URLString:[NSString stringWithFormat:kSeerverPath postfixBeMyFriend]
                                                                            parameters:dc error:nil];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Be my friend: %@", responseObject);
            [MC hideMBProgressHUD];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                succeess([responseObject[@"success"] isEqualToString:@"1"]?YES:NO);
                
            }
        } else {
            [MC hideMBProgressHUD];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
    
}
-(void)friendSendRequest:(NSString*)friendId beMyFriend:(BOOL)be_friend ResultSuccess:(void (^)(BOOL))succeess resultFailed:(void (^)(NSString *))failed
{
    [MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        friendId , @"friendId",
                        be_friend?@"1":@"0", @"request",
                        nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                             URLString:[NSString stringWithFormat:kSeerverPath postfixSendReq]
                                                                            parameters:dc error:nil];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Be my friend: %@", responseObject);
            [MC hideMBProgressHUD];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                succeess([responseObject[@"success"] isEqualToString:@"1"]?YES:NO);
                
            }
        } else {
            [MC hideMBProgressHUD];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
    
}


    

-(void)friendsWithSearchString:(NSString*)searchString fromIndex:(int)from toIndex:(int)to friendsOrRequests:(BOOL)friends ResultSuccess:(void (^)(NSArray *))succeess resultFailed:(void (^)(NSString *))failed
{
    if(friends)
       [MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        [NSString stringWithFormat:@"%i",from] , @"limitFrom",
                        [NSString stringWithFormat:@"%i",to] , @"limitCount",
                        nil];
    
   AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSString *postfix = friends?[NSString stringWithFormat:@"%@%@",kSeerverPath,postfixFriendsList]:[NSString stringWithFormat:@"%@%@",kSeerverPath,postfixFriendsReq];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET"
                                                                             URLString:postfix
                               parameters:dc error:nil];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Friends responce: %@", responseObject);
            [MC hideMBProgressHUD];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                succeess(responseObject[@"users"]);
                
            }
        } else {
            [MC hideMBProgressHUD];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
   
}
-(void)loginFB:(NSString *)faceBookToken andFaceBookID:(NSString*)faceBookID ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
    
    [MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        faceBookToken, @"facebookToken",
                        faceBookID, @"facebookId",
                        [[API deviceToken] length]>0?[API deviceToken]:@"dwdwetbwebwrt",@"deviceToken",
                        nil];



    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dc options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:kSeerverPath postfixLogin] parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"USER DATA: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
                succeess(responseObject);
                
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    

    
}

-(void)loginTwitter:(NSString *)twitterToken andtwitterId:(NSString*)twitterId  andTwitterSecret:(NSString*)twitterSecret ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
    
    [MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        twitterToken, @"twitterToken",
                        twitterId, @"twitterId",
                         twitterSecret, @"twitterSecret",
                        [[API deviceToken] length]>0?[API deviceToken]:@"dwdwetbwebwrt",@"deviceToken",
                        nil];

    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dc options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:kSeerverPath postfixLoginTwitter] parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject ;
                
                [ModalClass sharedInstance].userID = [NSString stringWithFormat:@"%@",dic[@"user"][@"uId"]];
                [ModalClass sharedInstance].userFullName = dic[@"user"][@"name"];
                [ModalClass sharedInstance].userAvatarImageUrl = dic[@"user"][@"img"];
                [ModalClass sharedInstance].restToken = dic[@"restToken"];
                succeess(dic);

                
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
    
    
}
-(void)udateProfile:(NSString *)name andDescription:(NSString*)description andImage:(UIImage *)image ResultSuccess:(void (^)(NSString *))succeess resultFailed:(void (^)(NSString *))failed{
    
    [MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        name, @"name",
                        description, @"description",
                        nil];

    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:kSeerverPath postfixUpdateUser parameters:dc constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        
        [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file"] fileName:[NSString stringWithFormat:@"file.jpg" ] mimeType:@"image/jpeg"];
        
    } error:nil];

    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject ;
                
                
                [ModalClass sharedInstance].userFullName = dic[@"user"][@"name"];
                [ModalClass sharedInstance].userAvatarImageUrl = dic[@"user"][@"img"];
                
                succeess(@"succeess");
                
                
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
    
    //========================================
    
}




-(void)createHotSpot:(NSString *)nameHotSpot
          andAddress:(NSString*)address
            andtime:(NSString*)time
            andDescription:(NSString*)description
            andLat:(NSString*)lat
            andLng:(NSString*)lng
            andPhone:(NSString*)phone
            andlink:(NSString*)link
            andTags:(NSArray*)Tags
            andImage:(UIImage *)image
            ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
    
    NSString * result = [[Tags valueForKey:@"description"] componentsJoinedByString:@","];
    
    NSString *stringWithoutSpaces = [result
                                     stringByReplacingOccurrencesOfString:@" х   " withString:@""];
    
    [MC showMBProgressHUD];
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                         nameHotSpot, @"name",
                         address, @"address",
                         [ModalClass sharedInstance].latitude, @"lat",
                         [ModalClass sharedInstance].longitude, @"lng",
                        result, @"tags",
                        nil];

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:kSeerverPath postfixNewHotSpot parameters:dc constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        
        [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file"] fileName:[NSString stringWithFormat:@"file.jpg" ] mimeType:@"image/jpeg"];
        
    } error:nil];

    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [MC hideMBProgressHUD];
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject ;
                

                
                succeess(dic);
                
                
            }
        } else {
             [MC hideMBProgressHUD];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
    
}



-(void)getProfileResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
    
    [MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                      [ModalClass sharedInstance].restToken, @"restToken",
                      [ModalClass sharedInstance].userID , @"uId",
                        nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:kSeerverPath postfixDetaiUser] parameters:dc error:nil];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
             [MC hideMBProgressHUD];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject ;
            
                succeess(dic);
            }
        } else {
             [MC hideMBProgressHUD];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
    
    
}


-(void)getHotSpotLisResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
    
    [MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        [ModalClass sharedInstance].userID , @"uId",
                        [emsGlobalLocationServer sharedInstance].latitude, @"lat",
                        [emsGlobalLocationServer sharedInstance].longitude, @"lng",
                        @"0", @"limitFrom",
                        @"100", @"limitCount",
                        nil];

    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:kSeerverPath postfixHotSpoList] parameters:dc error:nil];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            [MC hideMBProgressHUD];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject ;
                
                succeess(dic);
                
                
            }
        } else {
            [MC hideMBProgressHUD];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
    
    
}
-(void)getDetaiChat:(NSString *)opponentID ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
    
    //[MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                       [ModalClass sharedInstance].restToken, @"restToken",
                        opponentID, @"uId",
                        nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:kSeerverPath postfixGetChatHotSpot] parameters:dc error:nil];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [MC hideMBProgressHUD];
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject ;
                
                succeess(dic);
                
                
            }
        } else {
            [MC hideMBProgressHUD];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
}
-(void)sendMessage:(NSString *)message andChatID:(NSString *)chatID ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
    
    [MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        message, @"msg",
                        chatID, @"cId",
                        nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:kSeerverPath postfixSendMessage] parameters:dc error:nil];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        
        [MC hideMBProgressHUD];
        

        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject ;
                
                succeess(dic);
                
                
            }
        } else {
            [MC hideMBProgressHUD];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
}






-(void)addImageToHotSpot:(NSString *)hotSpotID andImage:(UIImage *)image ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
        
        [MC showMBProgressHUD];
        
        NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                            [ModalClass sharedInstance].restToken, @"restToken",
                            hotSpotID, @"sId",
                            nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:kSeerverPath postfixAddImege parameters:dc constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        
        [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file"] fileName:[NSString stringWithFormat:@"file.jpg" ] mimeType:@"image/jpeg"];
        
    } error:nil];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
           [MC hideMBProgressHUD];
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject ;
                
                succeess(dic);
                
            }
        } else {
            [MC hideMBProgressHUD];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
}




-(void)getHotSpotLisеSearch:(NSString *)searchStr andResult:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
    
    [MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        [ModalClass sharedInstance].userID , @"uId",
                        [ModalClass sharedInstance].latitude, @"lat",
                        [ModalClass sharedInstance].longitude, @"lng",
                        searchStr, @"search",
                        @"0", @"limitFrom",
                        @"100", @"limitCount",
                        nil];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:kSeerverPath postfixHotSpoList] parameters:dc error:nil];
    
    
    
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            [MC hideMBProgressHUD];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject ;
                
                succeess(dic);
                
                
            }
        } else {
            [MC hideMBProgressHUD];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
}
-(void)checkDistance:(NSDictionary *)data andResult:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
    
    [MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        [[emsGlobalLocationServer sharedInstance] latitude],@"lat",
                        [[emsGlobalLocationServer sharedInstance] longitude],@"lng",
                        data[@"spot_id"],@"spot_id",
                        nil];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer]
                                requestWithMethod:@"GET"
                                URLString:[NSString stringWithFormat:kSeerverPath postfixCheckDistance]
                                parameters:dc error:nil];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
    
            [MC hideMBProgressHUD];
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
                NSDictionary *dic = responseObject ;
                
                succeess(dic);
                
                
            }
        } else {
            [MC hideMBProgressHUD];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
}
-(void)getDetailSpot:(NSString *)userID andResult:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
    
    [MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        [[emsGlobalLocationServer sharedInstance] latitude],@"lat",
                        [[emsGlobalLocationServer sharedInstance] longitude],@"lng",
                        userID, @"sId",
                        nil];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:kSeerverPath postfixHotSpotDetail] parameters:dc error:nil];
    
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [MC hideMBProgressHUD];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject ;
                
                succeess(dic);
            
                
            }
                 }];
        } else {
            [MC hideMBProgressHUD];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
    
    
}

-(void)getDetailUser:(NSString *)userID andResult:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
    
    [MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        userID, @"uId",
                        nil];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:kSeerverPath postfixDetailUser] parameters:dc error:nil];
    
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            [MC hideMBProgressHUD];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject ;
                
                succeess(dic);
                
                
            }
        } else {
            [MC hideMBProgressHUD];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
    
    
}
-(void)setUserOnline:(BOOL)isOnline
{
    
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        [NSString stringWithFormat:@"%i",isOnline], @"isOnline",
                        nil];
    
   AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer]
                                requestWithMethod:@"POST"
                                URLString:[NSString stringWithFormat:kSeerverPath postfixSetUserOnline]
                                parameters:dc error:nil];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            
            NSLog(@"Online: %i",isOnline);
            
        } else {
           
          NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }]
     
    resume];
    
    
    
}

-(void)getChatListResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:kSeerverPath postfixGetChatList] parameters:dc error:nil];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            [MC hideMBProgressHUD];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject ;
                
                succeess(dic);
            }
        } else {
            [MC hideMBProgressHUD];
            NSLog(@"Error33: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
}

-(void)removeChatWithChatId:(NSString *)cId ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        cId, @"cId",
                        nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:kSeerverPath postfixRemoveChat] parameters:dc error:nil];
    
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject ;
                
                succeess(dic);
            }
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
}

-(void)setRadius:(NSString *)radius ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
    
    //[MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        radius, @"radius",
                        nil];
    
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:kSeerverPath postfixUpdateScanningRadius] parameters:dc error:nil];
    
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject ;
                
                succeess(dic);
                
                
            }
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
}


-(void)getRadiusResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:kSeerverPath postfixGetScanningRadius] parameters:dc error:nil];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            [MC hideMBProgressHUD];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject ;
                
                succeess(dic);
            }
        } else {
            [MC hideMBProgressHUD];
            NSLog(@"Error33: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
}


-(void)checkInInHotSpot:(NSString *)cId checkIn:(BOOL)yes ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        cId, @"sId",
                        [NSString stringWithFormat:@"%i",yes], @"checkIn",
                        nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:kSeerverPath postfixCheckIn] parameters:dc error:nil];
    
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject ;
                
                succeess(dic);
            }
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
}



-(void)getChatHistory:(NSString *)opponentID ResultSuccess:(void (^)(NSDictionary *))succeess resultFailed:(void (^)(NSString *))failed{
    
    //[MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        opponentID, @"cId",
                        nil];
    
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:kSeerverPath postfixChatHistory] parameters:dc error:nil];
    
    NSLog(@"%@",kSeerverPath postfixChatHistory);
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        
        [MC hideMBProgressHUD];
        
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject ;
                
                succeess(dic);
                
                
            }
        } else {
            [MC hideMBProgressHUD];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
}


-(void)likePicture:(NSString*)picId ResultSuccess:(void (^) (NSDictionary *) )succeess resultFailed:(void (^)(NSString *))failed
{
    [MC showMBProgressHUD];
    
    NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:
                        [ModalClass sharedInstance].restToken, @"restToken",
                        picId , @"file_id",
                        nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                             URLString:[NSString stringWithFormat:kSeerverPath postfixLoveMe]
                                                                            parameters:dc error:nil];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Love?: %@", responseObject);
            [MC hideMBProgressHUD];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *res = (NSDictionary *)responseObject;
                succeess(res);
                
            }
        } else {
            [MC hideMBProgressHUD];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
    
}


@end
