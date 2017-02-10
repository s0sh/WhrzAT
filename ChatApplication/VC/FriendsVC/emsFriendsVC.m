//
//  emsFriendsVC.m
//  ChatApplication
//
//  Created by admin on 02.02.16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import "emsFriendsVC.h"
#import "emsCustomCell.h"
#import "UIImageView+AFNetworking.h"
#include "ApiCall.h"
#import "Constants.h"
#import "Friend.h"
#import "emsFriendCell.h"
#import "DetailChatVC.h"
#import "DetailUserVC.h"

static BOOL isFriends = YES;

@interface emsFriendsVC ()

@property (strong, nonatomic) NSMutableArray *chatsArray;

@end

@implementation emsFriendsVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.rHandler.delegate = self;
    self.personeTable.delegate = self;
    self.personeTable.dataSource = self;
    self.chatsArray = [[NSMutableArray alloc] init];
    
    [self initHeaderForFriends:YES];
    [self checkForRequest:self.rHandler];
    [self initDataSource:YES];
}

-(Friend *)wrapFriendObject:(NSDictionary *)fO
{
    NSLog(@"%@",fO);
    Friend *f = [[Friend alloc] init];
    f.personeId = fO[@"id"];
    f.personeName = fO[@"name"];
    f.personeImageUrl = fO[@"img"][@"path"][@"236_236"];
    NSString *iol = [NSString stringWithFormat:@"%@",fO[@"isOnline"]];
    f.isOnline = [iol boolValue];
    [f setupAvatar];
    
    return f;
}

-(void)acceptFriend:(BOOL)accept withFriendId:(NSString *)fId
{
    
    [[ApiCall sharedInstance] friendAccept:fId beMyFriend:accept  ResultSuccess:^(BOOL success)
     {
         [self initDataSource:isFriends?YES:NO];
         
     } resultFailed:^(NSString *error) {
         
         NSLog(@"%@",error);
         
     }];
    
}



- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kNoteCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"called numberOfRowsInSection");
    
    return self.chatsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    emsFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emsFriendCell"];
    
    if (!cell) {
        
        NSArray* xibCell = [[NSBundle mainBundle] loadNibNamed:@"emsFriendCell" owner:self options:nil];
        
        cell = [xibCell objectAtIndex:0];
    }
    
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:kRightSwipeMenuWidth];
    cell.delegate = self;
    
    Friend *friend = self.chatsArray[indexPath.row];
    
    cell.tag = [friend.personeId integerValue];
    
    cell.nameLbl.text = friend.personeName;
    if(!friend.isOnline)
    {
        cell.online.hidden=YES;
    }
    [cell.photo setImageWithURL:[NSURL URLWithString:friend.personeImageUrl]];
    [self cornerIm:cell.photo ];
    return cell;

   
}
-(void)goToChat:(NSString *)friendId
{
    [self presentViewController:[[DetailChatVC alloc] initWithUser:friendId andName:@"" andIDChat:@""] animated:YES completion:^{
        
    }];

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    Friend *f = self.chatsArray[indexPath.row];
    [self presentViewController:[[DetailUserVC alloc] initWithUser:[NSString stringWithFormat:@"%@",f.personeId]] animated:YES completion:^{
    
    
    }];
}

#pragma mark - Helpers
-(void)initDataSource:(BOOL)friends
{
    if( self.chatsArray.count>0)
        [self.chatsArray removeAllObjects];
    
    [[ApiCall sharedInstance] friendsWithSearchString:nil/*Get all items*/ fromIndex:0 toIndex:100 friendsOrRequests:friends  ResultSuccess:^(NSArray *succeess) {
        
        for(int i=0;i<succeess.count;i++){
            [self.chatsArray addObject:[self wrapFriendObject:succeess[i]]];
            
        }
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            [self.personeTable reloadData];
            
        });
        
        
    } resultFailed:^(NSString *error) {
        
        NSLog(@"%@",error);
        
    }];
}

-(void)cornerIm:(UIView*)imageView{
    imageView.layer.cornerRadius = imageView.frame.size.height / 2 ;
    imageView.layer.masksToBounds = YES;
}


#pragma mark - SWTableViewCell
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    if (isFriends)
    {
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
                                               normalIcon:[UIImage imageNamed:@"friends_chat"]
                                             selectedIcon:[UIImage imageNamed:@"friends_chat_hover"]];
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
                                               normalIcon:[UIImage imageNamed:@"delete"]
                                             selectedIcon:[UIImage imageNamed:@"delete_hover"]];
    }
    else
    {
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
                                               normalIcon:[UIImage imageNamed:@"accept"]
                                             selectedIcon:[UIImage imageNamed:@"accept_hover"]];
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
                                               normalIcon:[UIImage imageNamed:@"decline"]
                                             selectedIcon:[UIImage imageNamed:@"decline_hover"]];
    }
    
    return rightUtilityButtons;
}


- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell
didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    __weak typeof (emsFriendsVC *) weakSelf = self;
    
    NSIndexPath *indexPath = [self.personeTable indexPathForCell:cell];
    
    Friend *f = self.chatsArray[indexPath.row];
    
    
    
    switch (index)
    {
        case 0:
        {
            isFriends?[self goToChat:[NSString stringWithFormat:@"%@",f.personeId]]:[self acceptFriend:YES withFriendId:[NSString stringWithFormat:@"%@",f.personeId]];
            
            if(!isFriends)
            {
                [self initDataSource:NO];
            }
            break;
        }
        case 1:
        {
            [self acceptFriend:NO withFriendId:[NSString stringWithFormat:@"%@",f.personeId]];
            [self initDataSource:isFriends?YES:NO];
            isFriends?[self checkForRequest:self.rHandler]:nil;
            
            break;
        }
            
        default:
            break;
    }
    
}


-(IBAction)initDataSourceForRequests
{
    [self changeSwipeMenuIconsOnVisibleCells];
    [self initHeaderForFriends:NO];
    [self initDataSource:NO];
    
}

-(void)initHeaderForFriends:(BOOL)friendsWillShow
{
    
    if(friendsWillShow){
        isFriends = YES;
        self.titleLbl.text = @"Friends";
        [self.menuBtn addTarget:self action:@selector(leftDrawerButtonPress) forControlEvents:UIControlEventTouchUpInside];
        [self.menuBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        self.requestsBtn.alpha=1;
    }else{
        isFriends = NO;
        self.titleLbl.text = @"Requests";
        self.requestsBtn.alpha=0;
        [self.menuBtn removeTarget:self action:@selector(leftDrawerButtonPress) forControlEvents:UIControlEventTouchUpInside];
        [self.menuBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.menuBtn setImage:[UIImage imageNamed:@"back_small"] forState:UIControlStateNormal];
        [self hideRequestsHandlerNotificationView:self.rHandler hide:0];
    }
    
    
}

-(void)hideRequestsHandlerNotificationView:(emsRequestsHandler *)hdlr  hide:(int)hide
{
    hdlr.alpha = hide;
}
-(void)checkForRequest:(emsRequestsHandler *)hdlr
{
    [hdlr checkForRequests];
}
-(IBAction)back
{
    [self hideRequestsHandlerNotificationView:self.rHandler hide:1];
    [self initHeaderForFriends:YES];
    [self initDataSource:YES];
    [self checkForRequest:self.rHandler];
    
}


- (void) changeSwipeMenuIconsOnVisibleCells
{
    for (emsFriendCell *cell in [self.personeTable visibleCells])
    {
        [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:70.f];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(IBAction)leftDrawerButtonPress{
    [APP leftOpen];
}

@end
