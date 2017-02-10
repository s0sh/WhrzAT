//
//  emsChatsVC.m
//  ChatApplication
//
//  Created by developer on 25/01/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import "emsChatsVC.h"
#import "emsCustomCell.h"
#import "emsHotSptListCell.h"
#import "UIImageView+AFNetworking.h"
#include "ApiCall.h"
#import "DetailChatVC.h"
#import "Constants.h"

@interface emsChatsVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *chatsArray;

@end

@implementation emsChatsVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [self refreshChats];
    
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kNoteCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    emsCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    if (!cell) {
        
        NSArray* xibCell = [[NSBundle mainBundle] loadNibNamed:@"emsCustomCell" owner:self options:nil];
        
        cell = [xibCell objectAtIndex:0];
    }
    
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:kRightSwipeMenuWidth];
    cell.delegate = self;
    
    NSDictionary *dict = [self.chatsArray objectAtIndex:indexPath.row];
    
    cell.tag = [dict[@"cId"] integerValue];
    
    int unreadMessagesCounter = [dict[@"messageCount"] intValue];
    
    if (unreadMessagesCounter)
    {
        cell.arrowView.hidden = YES;
        cell.unreadMessagesBgrdView.hidden = NO;
        cell.unreadMessagesCounter.hidden = NO;
        cell.unreadMessagesCounter.text = [NSString stringWithFormat:@"%@", dict[@"messageCount"]];
    }
    else
    {
        cell.arrowView.hidden = NO;
        cell.unreadMessagesBgrdView.hidden = YES;
        cell.unreadMessagesCounter.hidden = YES;
    }
    
    cell.nameLbl.text    = dict[@"user"][@"name"];
    cell.messageLbl.text = dict[@"lastMessage"];
    NSString *iol = [NSString stringWithFormat:@"%@",dict[@"user"][@"isOnline"]];
    BOOL isOnline = [iol boolValue];
    if(!isOnline){
        cell.online.hidden=YES;
    }
    NSDate *lastMessageTime = [NSDate dateWithTimeIntervalSince1970:[dict[@"lastMessageTime"] intValue]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm a"];
    NSString *dateInStringFormated = [dateFormatter stringFromDate:lastMessageTime];
    
    cell.timeLbl.text    = dateInStringFormated;
    
    
    NSString *url =  dict[@"user"][@"img"][@"236_236"];
    
    [cell.photo setImageWithURL:[NSURL URLWithString:url]];
    
    [self cornerIm:cell.photo ];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.chatsArray objectAtIndex:indexPath.row];
    
    // NSString *chatId = dict[@"cId"];
    
    
    
    [self presentViewController:[[DetailChatVC alloc]initWithUser:[NSString stringWithFormat:@"%@",dict[@"user"][@"uId"]] andName:[NSString stringWithFormat:@"%@",dict[@"user"][@"name"]] andIDChat:[NSString stringWithFormat:@"%@",dict[@"cId"]]] animated:YES completion:^{
        
    }];
    
    
    
}

#pragma mark - Helpers
- (void) refreshChats
{
    __weak typeof (emsChatsVC *) weakSelf = self;
    
    [[ApiCall sharedInstance] getChatListResultSuccess:^(NSDictionary *result) {
        
        weakSelf.chatsArray = [result[@"chats"] mutableCopy];
        [weakSelf.tableView reloadData];
    }
                                          resultFailed:^(NSString *fail) {
                                              
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
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
                                           normalIcon:[UIImage imageNamed:@"delete_chat"]
                                         selectedIcon:[UIImage imageNamed:@"delete_chat_hov"]];
    
    return rightUtilityButtons;
}


- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell
didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    __weak typeof (emsChatsVC *) weakSelf = self;
    
    switch (index)
    {
        case 0:
        {
            NSNumber *chatIdNumber = [NSNumber numberWithInteger:cell.tag];
            
            [[ApiCall sharedInstance] removeChatWithChatId:[chatIdNumber stringValue]
                                             ResultSuccess:^(NSDictionary *result) {
                                                 
                                                 [cell hideUtilityButtonsAnimated:YES];
                                                 [weakSelf refreshChats];
                                             }
                                              resultFailed:^(NSString *fail) {
                                                  
                                                  
                                              }];
            break;
        }
        default:
            break;
    }
}

-(IBAction)leftDrawerButtonPress{
    [APP leftOpen];
}

@end
