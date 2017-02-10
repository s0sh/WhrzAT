//
//  DetailChatVC.m
//  ChatApplication
//
//  Created by developer on 25/06/14.
//  Copyright (c) 2014 developer. All rights reserved.
//

#import "DetailChatVC.h"
#import "emsChatCell.h"
#import "ApiCall.h"
#import "ModalClass.h"
#import "UIImageView+AFNetworking.h"
#import "Chat.h"
#import "DetailUserVC.h"

@interface DetailChatVC (){
   __block NSString *opponentUrl;
    NSString *opponentId;
    NSTimer *tm;
    NSString *opponentName;
        NSString *myMhatID;
}
@property(retain)IBOutlet UITextField *commentsTF;
@property(weak) IBOutlet UIView *contentView;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImageView *opponentImage;
@property (nonatomic, weak) IBOutlet UILabel *opponntLabel;
@property (nonatomic, strong)Chat *currentChat;
@end

const CGFloat rWidthOffset = 30.0f;
const CGFloat rImageSize = 50.0f;

@implementation DetailChatVC

-(void)loadMessages
{

    [[ApiCall sharedInstance] getDetaiChat:opponentId  ResultSuccess:^(NSDictionary *secceess) {
        
        for (NSDictionary* dicionary in secceess[@"chat"][@"messages"]) {
            
            
            if ( [[NSString stringWithFormat:@"%@",dicionary[@"user"][@"uId"]]isEqualToString:[ModalClass sharedInstance].userID ] ) {
                 [self.messages addObject:[Message messageWithString:[dicionary objectForKey:@"message"]
                                                               image:nil date:[dicionary objectForKey:@"created"]
                                                               status:nil owner:ownerSelf
                                                               andAttacmentImage:nil
                                                               attachUrl:nil]];
            }else{
                
                opponentUrl = dicionary [@"user"][@"img"][@"236_236"];
                [self.messages addObject:[Message messageWithString:[dicionary objectForKey:@"message"] image:nil date:[dicionary objectForKey:@"created"] status:nil owner:ownerOther andAttacmentImage:nil attachUrl:nil]];
            }
            
            
            
        }
       
            
            [self.tableView reloadData];
            [self scrollToBottomTable];
       
        
        
    } resultFailed:^(NSString *error) {
        
    }];

}
- (id)initWithUser:(NSString *)opponentID andName:(NSString *)name andIDChat:(NSString *)chatID{

    self = [super init];
    
    if (self) {
        
        self.messages = [[NSMutableArray alloc] init];
        if(chatID.length>0){
            myMhatID = chatID;
            opponentId = opponentID;
            opponentName = name;
            [self loadMessages];
            self.opponntLabel.text = opponentName;
            
        }
        else{
        
            [[ApiCall sharedInstance] getDetaiChat:opponentID  ResultSuccess:^(NSDictionary *secceess) {
                
                for (NSDictionary* dicionary in secceess[@"chat"][@"messages"]) {
                    
                    
                    if ( [[NSString stringWithFormat:@"%@",dicionary[@"user"][@"uId"]]isEqualToString:[ModalClass sharedInstance].userID ] ) {
                        [self.messages addObject:[Message messageWithString:[dicionary objectForKey:@"message"] image:nil date:[dicionary objectForKey:@"created"] status:nil owner:ownerSelf andAttacmentImage:nil attachUrl:nil]];
                    }else{
                        
                        opponentUrl = dicionary [@"user"][@"img"][@"236_236"];
                        [self.messages addObject:[Message messageWithString:[dicionary objectForKey:@"message"] image:nil date:[dicionary objectForKey:@"created"] status:nil owner:ownerOther andAttacmentImage:nil attachUrl:nil]];
                    }
                    
                    
                    
                }
                NSArray *tmptocheck = (NSArray *)secceess[@"chat"][@"messages"];
                NSLog(@"Chat: %@",secceess);
                if(tmptocheck.count>0)
                {
                    
                        myMhatID = [NSString stringWithFormat:@"%@",secceess[@"chat"][@"id"]];
                        opponentId = opponentID;
                        opponentName = secceess[@"chat"][@"messages"][0][@"user"][@"name"];
                        self.opponntLabel.text = opponentName;
                        [self.tableView reloadData];
                        [self scrollToBottomTable];
                    
                    
                }
                
            } resultFailed:^(NSString *error) {
                
            }];
        
        
        }
      
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MC connected];
    self.opponntLabel.text = opponentName;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}

#pragma UpdateActions

- (void)updateAction{
    
    [[ApiCall sharedInstance] getChatHistory:myMhatID ResultSuccess:^(NSDictionary *secceess) {
        NSArray * arr = [[NSArray alloc] initWithArray: secceess[@"chat"][@"messages"]];
                         if([arr count]>[self.messages count]){
                             NSDictionary* dicionary  = [arr lastObject];
                             
                             if (! [[NSString stringWithFormat:@"%@",dicionary[@"user"][@"uId"]]isEqualToString:[ModalClass sharedInstance].userID ] ) {
                                 
                                 [self.messages insertObject:[Message messageWithString:[dicionary objectForKey:@"message"]  image:nil date:[dicionary objectForKey:@"created"] status:nil owner:ownerOther andAttacmentImage:nil attachUrl:NO] atIndex:[self.messages count]];
                
                                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.messages  count]-1 inSection:0];
                                 [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
                                 
                                 emsChatCell* cell = (emsChatCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                                 
                                 CATransition *transition = [CATransition animation];
                                 transition.duration = 1.0f;
                                 transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                 transition.type = kCATransitionPush;
                                 
                                 [cell.dateLable.layer addAnimation:transition forKey:nil];
                                 [cell.bubbleView.layer addAnimation:transition forKey:nil];
                                 [cell.textLabel.layer addAnimation:transition forKey:nil];
                                 [cell.arrowImage.layer addAnimation:transition forKey:nil];
                                 [self.tableView  performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
                                 
                                 
    
                             }
                          
                             
                             
        
        }
      
        
    } resultFailed:^(NSString *error) {
        
    }];

    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

# pragma UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSInteger textLength = 0;
   // textLength = [textField.text length] + [string length] - range.length;
    if([[textField text] length] == 0 && [string isEqualToString:@" "])
    {
        return NO;
    }else{
        return YES;
    }
}
- (void)keyboardWasShown:(NSNotification *)notification
{
   
    CGRect keyboardRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.contentView.frame =CGRectMake(self.contentView.frame.origin.x,
                                       self.view.frame.size.height -  keyboardRect.size.height -44,
                                       self.contentView.frame.size.width ,
                                       self.contentView.frame.size.height);
    
    
    [self scrollToBottomTable];
}


- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{

    
    self.contentView.frame =CGRectMake(self.contentView.frame.origin.x,
                                       523,
                                       self.contentView.frame.size.width,
                                       self.contentView.frame.size.height);
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}




#pragma mark - UITableViewDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}
-(IBAction)userProfile
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"hideButton"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self presentViewController:[[DetailUserVC alloc] initWithUser:opponentId] animated:YES completion:^{
        
    }];

    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [self.messages objectAtIndex:indexPath.row];
    UIImageView *avatarIm ;
    avatarIm.userInteractionEnabled = YES;
    
    
    NSString *CellIdentifier = [NSString stringWithFormat: @"Cell%li", (long)indexPath.row];
    emsChatCell *cell = (emsChatCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[emsChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = self.tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataSource = (id)self;
        cell.delegate = (id)self;
        cell.textLabel.text = message.message;
        if(message.messageDate.length<10){
            cell.dateLable.text = message.messageDate;
        }else{
            cell.dateLable.text  = [self strDate:[NSDate dateWithTimeIntervalSince1970:[message.messageDate integerValue]]];
        }
        
        avatarIm = [[UIImageView alloc] initWithFrame:CGRectMake(0,20, 54, 54)];
        [avatarIm setImageWithURL:[NSURL URLWithString:opponentUrl]];
        [self cornerIm:avatarIm];
        [cell.contentView addSubview:avatarIm];
        UIButton *btnProfile = [[UIButton alloc] initWithFrame:avatarIm.frame];
        [btnProfile addTarget:self action:@selector(userProfile) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnProfile];
        
    }
   
    if (message.messageOwner == ownerSelf) {
        avatarIm.hidden = YES;
        cell.authorType = cellAuthorTypeSelf;
    }else{
        cell.authorType = cellAuthorTypeOther;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [self.messages objectAtIndex:indexPath.row];
    CGSize size;
    size = [message.message sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:14] constrainedToSize:CGSizeMake(self.tableView.frame.size.width  -rImageSize - 8.0f - rWidthOffset, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];

return size.height +55.0f;

}

-(IBAction)addMess{

  if([self.commentsTF.text length]>0 && ![self.commentsTF.text isEqualToString:@" "])
  {
    
      
      [self.messages insertObject:[Message messageWithString:self.commentsTF.text  image:nil date:[self strDate:[NSDate date]] status:nil owner:ownerSelf andAttacmentImage:nil attachUrl:NO] atIndex:[self.messages count]];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.messages  count]-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    emsChatCell* cell = (emsChatCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    
    [cell.dateLable.layer addAnimation:transition forKey:nil];
    [cell.bubbleView.layer addAnimation:transition forKey:nil];
    [cell.textLabel.layer addAnimation:transition forKey:nil];
    [cell.arrowImage.layer addAnimation:transition forKey:nil];
    [self.tableView  performSelector:@selector(reloadData) withObject:nil afterDelay:.5];
    [self scrollToBottomTable];
    [self.commentsTF resignFirstResponder];
    NSString *strMess = self.commentsTF.text;
    self.commentsTF.text = @"";
      
    [[ApiCall sharedInstance] sendMessage:strMess andChatID:myMhatID ResultSuccess:^(NSDictionary *succeess) {
        
        
    } resultFailed:^(NSString *error) {
        
        
        
    }];
  }

}
-(void)cornerIm:(UIImageView*)imageView{
    imageView .layer.cornerRadius =  imageView.bounds.size.width/2;
    UIColor *color = [UIColor colorWithRed:139/255.0 green:185/255.0 blue:172/255.0 alpha:1];
    [imageView.layer setBorderColor:color.CGColor];
    [imageView.layer setBorderWidth:1.0];
    imageView.layer.masksToBounds = YES;
}

-(void)scrollToBottomTable{
    
    [UIView animateWithDuration:.8 animations:^{
        
        [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height-self.tableView.frame.size.height +44,
                                                       self.tableView.bounds.size.width,
                                                       self.tableView.bounds.size.height)
                                   animated:YES];
        
    }];
    
}
-(NSString*)strDate:(id)timeObj
{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSLocale *twelveHourLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    format.locale = twelveHourLocale;
    [format setDateFormat:@"hh:mm a"];
    NSString *string = [format stringFromDate:timeObj];
    return string;
}
#pragma Timer
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    [tm invalidate];
    tm = nil;
    
}
-(void)stopTimer{
    [tm invalidate];
    tm = nil;
    NSLog(@"Stop");
}
-(void)startTimer{
    
    tm = [NSTimer scheduledTimerWithTimeInterval:10. target:self selector:@selector(updateAction) userInfo:nil repeats:YES];
    
    NSLog(@"Start");
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self updateAction];
    
    tm = [NSTimer scheduledTimerWithTimeInterval:10. target:self selector:@selector(updateAction) userInfo:nil repeats:YES];
    
}

- (IBAction)backAction
{
    [self stopTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
