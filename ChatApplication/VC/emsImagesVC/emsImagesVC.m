//
//  emsImagesVC.m
//  ChatApplication
//
//  Created by developer on 19/01/16.
//  Copyright © 2016 ErmineSoft. All rights reserved.
//

#import "emsImagesVC.h"
#import "hotSpotImage.h"
#import "UIImageView+AFNetworking.h"
#import "DetailUserVC.h"
#import "DetailChatVC.h"
#import "ModalClass.h"
#import "emsDetailProfile.h"
#import "emsHotSpot.h"
@interface emsImagesVC (){
    int selectedIdex;
}
@property (retain, nonatomic) NSMutableArray * imagesArray;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelAddress;
@property (retain, nonatomic)__block emsHotSpot * currentHotSpot;
@property (weak, nonatomic) IBOutlet UITableView *imagesTableView;
@property (strong, nonatomic) NSString *titleString;

@end

@implementation emsImagesVC


-(void)refreshData
{

    __weak __typeof(self)weakSelf = self;
    
    [_currentHotSpot.hotSpotImages removeAllObjects];
    
    
    
    [[ApiCall sharedInstance] getDetailSpot:self.currentHotSpot.hotSpotID andResult:^(NSDictionary *dic) {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
    for (NSDictionary *dictionary in dic[@"spot"][@"files"]) {
        
        hotSpotImage *spotImage = [[hotSpotImage alloc] init];
        spotImage.ownerID = dictionary[@"uId"];
        spotImage.fileID = dictionary[@"fId"];
        spotImage.loveCounter = dictionary[@"love_count"];
        spotImage.imageUrl =dictionary[@"spotPath"][@"640_360"];
        spotImage.kubImageUrl =dictionary[@"spotPath"][@"236_236"];
        spotImage.ownerName =dictionary[@"name"];
        spotImage.ownerAvaUrl =dictionary[@"userPath"][@"236_236"];
        spotImage.isMyFriend =[NSString stringWithFormat:@"%@",dictionary[@"isMyFriend"]] ;
        [_currentHotSpot.hotSpotImages addObject:spotImage];
    }
    
    _currentHotSpot.hotSpotID =dic[@"spot"][@"sId"];
    NSArray *items345 = dic[@"spot"][@"tags"];
    _currentHotSpot.hotSpotDescription = dic[@"spot"][@"description"];
    _currentHotSpot.hotSpotTitle = dic[@"spot"][@"name"];
    _currentHotSpot.hotSpotAdress = dic[@"spot"][@"address"];
    _currentHotSpot.hotSpotSiteAdress = dic[@"spot"][@"link"];
    _currentHotSpot.hotSpotPhoneNumber = dic[@"spot"][@"phone"];
    _currentHotSpot.isMember = [NSString stringWithFormat:@"%@",dic[@"spot"][@"is_member"]];
    _currentHotSpot.hotSpotWorkingTime =  dic[@"spot"][@"time"];
    _currentHotSpot.hotSpotImageURL = [(NSArray*)dic[@"spot"][@"img"] count]>0?dic[@"spot"][@"img"][@"path"][@"236_236"]:@"";
    _currentHotSpot.rectangularHotSpotImageURL = [(NSArray*)dic[@"spot"][@"img"] count]>0?dic[@"spot"][@"img"][@"path"][@"640_360"]:@"";
    _currentHotSpot.hotSpotTags =[[NSMutableArray alloc] initWithArray: items345];
    _currentHotSpot.lontitude = dic[@"spot"][@"lng"];
    _currentHotSpot.langitude = dic[@"spot"][@"lat"];
    [_currentHotSpot.hotSpotMainImage setImageWithURL:[NSURL URLWithString:_currentHotSpot.hotSpotImageURL ]];
    _currentHotSpot.hotSpotType =[dic[@"spot"][@"brightness"] integerValue];
    _currentHotSpot.followersCount = [NSString stringWithFormat:@"%@",dic[@"spot"][@"check_ins"]];
    _currentHotSpot.hotSpotDistance = dic[@"spot"][@"distance"];
    _currentHotSpot.isPromotion = [dic[@"spot"][@"isPromotion"] boolValue];
    
        weakSelf.imagesArray = [[NSMutableArray alloc] initWithArray:weakSelf.currentHotSpot.hotSpotImages];
        weakSelf.titleString = weakSelf.currentHotSpot.hotSpotTitle;
        [weakSelf.imagesTableView reloadData];
        
    }];
      
    } resultFailed:^(NSString *error) {
        
        NSLog(@"%@",error);
        
    }];

}
- (id)initWithHotSpot:(emsHotSpot*)hotSpot
{
    self = [super init];
    
    if (self) {
        self.currentHotSpot = [[emsHotSpot alloc] init];
        self.currentHotSpot = hotSpot;
        self.imagesTableView.delegate = self;
        self.imagesTableView.dataSource = self;
        
    }
    self.titleString = self.currentHotSpot.hotSpotTitle;
    self.titleLabelAddress.text = self.currentHotSpot.hotSpotAdress;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentHotSpot.hotSpotImages = [[NSMutableArray alloc] init];
    self.titleLabel.text = self.titleString;
    self.titleLabelAddress.text = self.currentHotSpot.hotSpotAdress;
    [self refreshData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.imagesArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    emsImageVCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];

    if (!cell) {
        NSArray* xibCell = [[NSBundle mainBundle] loadNibNamed:@"emsImageVCCell" owner:self options:nil];
         cell = [xibCell objectAtIndex:0];
         cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    hotSpotImage *spotImage = [self.imagesArray objectAtIndex:indexPath.row];
    [cell.mainImage setImageWithURL:[NSURL URLWithString:spotImage.imageUrl]];
    [cell.userAvarat setImageWithURL:[NSURL URLWithString:spotImage.ownerAvaUrl]];
    cell.nameLabel.text = spotImage.ownerName;
    
    cell.loveCount = [[NSString stringWithFormat:@"%@",spotImage.loveCounter] intValue];
    cell.fileID = spotImage.fileID;
    [cell.heart setImageForLoveCount:cell.loveCount];
    cell.loveCountLbl.text = [NSString stringWithFormat:@"%d",cell.loveCount];
    
    [self cornerIm:cell.userAvarat];
    cell.uId = spotImage.ownerID;
    cell.userBtn.tag = indexPath.row;
    cell.delegate = self;
    cell.requestBtn.alpha=0;
    cell.chatBtn.alpha=1;
    if([[ModalClass sharedInstance].userID isEqualToString:spotImage.ownerID])
    {
        cell.requestBtn.alpha=0; 
        cell.chatBtn.alpha=0;
        cell.loveBtn.userInteractionEnabled = NO;
    }
    else{
    
        cell.requestBtn.alpha=0;
        cell.chatBtn.alpha=1;
    }
    
    
    [cell.userBtn addTarget:self action:@selector(ansverToRequestPositive:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)ansverToRequestPositive:(UIButton*)sender{
    
    
     selectedIdex = (int)sender.tag;
     hotSpotImage *spotImage = [self.imagesArray objectAtIndex:selectedIdex];
    if(![spotImage.ownerID isEqualToString:[[ModalClass sharedInstance] userID]]){
    
        [self presentViewController:[[DetailUserVC alloc]initWithUser:spotImage.ownerID] animated:YES completion:^{
        
     }];
    }
    else
    {
        
    }
}
-(void)cornerIm:(UIView*)imageView{
    imageView .layer.cornerRadius = imageView.frame.size.height / 2 ;
    imageView.layer.masksToBounds = YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    emsImageVCCell *cell = (emsImageVCCell *)[tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:.6 animations:^{
        
        cell.detailView.alpha = 1;
        
    }];
    
}
-(IBAction)back{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)cellController:(emsImageVCCell*)cellController
                       userId:(NSString *)iId
{
    [self presentViewController:[[DetailChatVC alloc] initWithUser:iId andName:@"" andIDChat:@""] animated:YES completion:^{
        
    }];
    
}
@end
