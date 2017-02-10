//
//  LeftControl.m
//  ChatApplication
//
//  Created by developer on 02/07/14.
//  Copyright (c) 2014 developer. All rights reserved.
//

#import "LeftControl.h"
#import "DetailChatVC.h"
#import "UserMapVC.h"
#import "SettingVC.h"
#import "emsCreateHSVC.h"
#import "emsDetailProfile.h"
#import "DetailChatVC.h"
#import "emsFriendsVC.h"
#import "emsChatsVC.h"
#import "emsFriendsVC.h"
@interface LeftControl ()

@property(retain,nonatomic) IBOutlet UITableView* controlTableView;



@end

@implementation LeftControl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)dealloc{



}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload_Table_left) name:@"Clouse_keyBoardLeft" object:nil];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}


#pragma tablerView Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return kLeftControlCount;
    
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyIdentifier"] ;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    
   
    UIButton *deletebtn=[[UIButton alloc]init];
    
    deletebtn.frame=CGRectMake(0, 0, 100, 84);

    switch (indexPath.row) {
        case kMyProfile:
            [deletebtn setImage:[UIImage imageNamed:@"hotspots"] forState:UIControlStateNormal];
            [deletebtn setImage:[UIImage imageNamed:@"hotspots_hover"] forState:UIControlStateHighlighted];
            break;
        case kMyFriends:

            
            [deletebtn setImage:[UIImage imageNamed:@"new_hotspot"] forState:UIControlStateNormal];
            [deletebtn setImage:[UIImage imageNamed:@"new_hotspot_hover"] forState:UIControlStateHighlighted];
            break;
        case kMyChats:
            
            [deletebtn setImage:[UIImage imageNamed:@"my_profile"] forState:UIControlStateNormal];
            [deletebtn setImage:[UIImage imageNamed:@"my_profile_hover"] forState:UIControlStateHighlighted];
            break;
            
        case kMyMap:
            [deletebtn setImage:[UIImage imageNamed:@"chat_left"] forState:UIControlStateNormal];
            [deletebtn setImage:[UIImage imageNamed:@"chat_hover_left"] forState:UIControlStateHighlighted];
            break;
            
        case kSetting:
            [deletebtn setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
            [deletebtn setImage:[UIImage imageNamed:@"settings_hover"] forState:UIControlStateHighlighted];
            break;
        
            
        default:
            break;
    }
        
    [deletebtn addTarget:self action:@selector(DeleteRow:) forControlEvents:UIControlEventTouchUpInside];
    
    deletebtn.tag = indexPath.row;
    
    [cell.contentView addSubview:deletebtn];
        
    }
    return cell;
}
-(void)DeleteRow:(UIButton*)btn{

     if (USER_IDEOMA_IPHONE) {
    switch (btn.tag) {
        case kMyProfile:
            [APP myMain:[[UserMapVC alloc] init]];
            break;
        case kMyFriends:
            [APP myHotSpot:[[emsCreateHSVC alloc] init]];
            break;
        case kMyChats:
            [APP myDetailProfile:[[emsDetailProfile alloc] init]];
            break;
        case kMyMap:
            [APP myChats:[[emsChatsVC alloc] init]];
            break;
        case kSetting:
            [APP mySettings:[[SettingVC alloc] init]] ;
            break;    
        default:
            break;
    };
         
 }
}





-(void)reload_Table_left{
      [self.controlTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
