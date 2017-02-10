//
//  emsDetailHotSpot.m
//  ChatApplication
//
//  Created by developer on 16/12/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "emsDetailHotSpot.h"
#import "emsHotSpot.h"
#import "HEBubbleView.h"
#import "HEBubbleViewItem.h"
#import "emsDetailSpotCell.h"
#import "UIImageView+AFNetworking.h"
#import "ModalClass.h"
#import "UserMapVC.h"
#import "emsImagesVC.h"
#import "UIImageView+AFNetworking.h"
#import "DemoImageEditor.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "hotSpotImage.h"
#import "ApiCall.h"
@interface emsDetailHotSpot (){
    IBOutlet UIView *viewWithScroll;
    
    //-------------------------------------
    
    NSMutableArray *data;
    int buttonNo;
    HEBubbleView *bubbleView;
    NSInteger bubbleCount;
    NSTimer *timer;
    UIImagePickerController *imgPicker;
    BOOL checkedIn;
    BOOL showPhotoInfo;
    BOOL isCurrentHotspotCreatedFromWebPanel;
    
    //-------------------------------------
}

@property(nonatomic,strong) DemoImageEditor *imageEditor;
@property(nonatomic,strong) ALAssetsLibrary *library;
@property (nonatomic, weak) IBOutlet UILabel *hotSpotName;
@property (nonatomic, weak) IBOutlet UIImageView *hotSpotImage;
@property (nonatomic) NSMutableArray *hotSpotTagsArray;
@property (nonatomic) NSMutableArray *hotSpotimagesArray;
@property (nonatomic, weak) IBOutlet UILabel *hotSpotPlaceLabel;
@property (nonatomic, weak) IBOutlet UILabel *hotSpotSiteLabel;
@property (nonatomic, weak) IBOutlet UIButton *checkInBtn;
@property (nonatomic, weak) IBOutlet UILabel *hotSpotPhoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *hotSpotOpenTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *hotSpotDescriptionLabel;
@property (nonatomic, weak) IBOutlet UICollectionView *imsgeCollection;
@property (nonatomic, weak) IBOutlet UIView *viewForTag;
@property (nonatomic)__block emsHotSpot *currentHotSpot;
@property (nonatomic, weak) IBOutlet UIImageView *hotSpotReitingImage;
@property(nonatomic, weak)IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *hotSpotUserCount;
//-------
@property (nonatomic, weak) IBOutlet UIView *thankYouView;
@property (nonatomic, weak) IBOutlet UIView *bgViewThankYou;
//-------
@property (nonatomic, weak) IBOutlet UIView *photoInformationView;
@property (nonatomic, weak) IBOutlet UIView *bgphotoInformationView;


@property (nonatomic, weak) IBOutlet UIImageView *checkInImage;


@property (weak, nonatomic) IBOutlet UIImageView *iconLocation;
@property (weak, nonatomic) IBOutlet UIImageView *iconWebAddress;
@property (weak, nonatomic) IBOutlet UIImageView *iconPhone;
@property (weak, nonatomic) IBOutlet UIImageView *iconOpenTime;



@end

@implementation emsDetailHotSpot

-(void)refreshUI
{
    self.imsgeCollection.delegate = self;
    self.imsgeCollection.dataSource = self;
    [self initUI];
    [self setUpBubbles];
    bubbleView.frame = self.view.bounds;
   
    [self.view addSubview:self.thankYouView];
    self.thankYouView.hidden = YES;
    [self.view addSubview:self.photoInformationView];
    self.photoInformationView.hidden = YES;
    showPhotoInfo = NO;
    
    if ([self.currentHotSpot.isMember isEqualToString:@"1"]) {
        
        self.checkInImage.image = [UIImage imageNamed:@"checked"];
        checkedIn = YES;
        
    }
    else{
        self.checkInImage.image = [UIImage imageNamed:@"unchecked"];
        checkedIn = NO;
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            
            if ([self.currentHotSpot.isMember isEqualToString:@"1"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self performSelector:@selector(setUpSelfThankYouView) withObject:nil afterDelay:3];
                });
                
            }
            
            
        });
        
    }
    switch (self.currentHotSpot.hotSpotType) {
            
        case zeroType:
            self.hotSpotReitingImage.image = [UIImage imageNamed:@"fire_wht_0"];
            break;
        case firstTipe:
            self.hotSpotReitingImage.image = [UIImage imageNamed:@"fire_wht_1"];
            break;
        case secondTipe:
            self.hotSpotReitingImage.image = [UIImage imageNamed:@"fire_wht_2"];
            break;
        case thirdTipe:
            self.hotSpotReitingImage.image = [UIImage imageNamed:@"fire_wht_3"];
            break;
            
        case fourthTipe:
            self.hotSpotReitingImage.image = [UIImage imageNamed:@"fire_wht_4"];
            break;
        case fifthTipe:
            self.hotSpotReitingImage.image = [UIImage imageNamed:@"fire_wht_5"];
            break;
            
    }
    
    [self.imsgeCollection registerClass:[emsDetailSpotCell class] forCellWithReuseIdentifier:@"emsDetailSpotCell"];//register cell class
    self.hotSpotName.text = self.currentHotSpot.hotSpotTitle;
    self.hotSpotTagsArray =[[NSMutableArray alloc] initWithArray:self.currentHotSpot.hotSpotTags];
    self.hotSpotImage.image =[UIImage imageNamed:[NSString stringWithFormat:@"b%@",self.currentHotSpot.imageNameHP]];
    self.hotSpotPlaceLabel.text = self.currentHotSpot.hotSpotAdress;
    self.hotSpotSiteLabel.text = self.currentHotSpot.hotSpotSiteAdress;
    self.hotSpotPhoneLabel.text = self.currentHotSpot.hotSpotPhoneNumber;
    self.hotSpotOpenTimeLabel.text = self.currentHotSpot.hotSpotWorkingTime;
    self.hotSpotDescriptionLabel.text = self.currentHotSpot.hotSpotDescription;
    self.hotSpotimagesArray = [[NSMutableArray alloc] initWithArray:self.currentHotSpot.hotSpotImages];
    
    if (self.currentHotSpot.hotSpotImageURL) {
        [self.hotSpotImage  setImageWithURL:[NSURL URLWithString:self.currentHotSpot.rectangularHotSpotImageURL]];
    }
    if(self.currentHotSpot.followersCount==nil){
        self. hotSpotUserCount.text = @"0 users in";
    }
    else{
        self. hotSpotUserCount.text = [NSString stringWithFormat:@"%@ users in",self.currentHotSpot.followersCount];
    }

    [self.imsgeCollection reloadData];


}
-(void)refreshData
{
    
    
    _currentHotSpot.hotSpotImages = [[NSMutableArray alloc] init];
    
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
        
        
            [self refreshUI];
        }];
        
        
    } resultFailed:^(NSString *error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
    
}
-(void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:YES];
    [self refreshData];
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (id)initWithHotSpot:(emsHotSpot*)hotSpot{
    
    self = [super init];
    if (self) {
        
        data = [[NSMutableArray alloc] init];
        bubbleCount = 0;
        self.currentHotSpot =hotSpot;
        isCurrentHotspotCreatedFromWebPanel = YES;
        
        if (!self.currentHotSpot.hotSpotSiteAdress &&
            !self.currentHotSpot.hotSpotPhoneNumber &&
            !self.currentHotSpot.hotSpotWorkingTime &&
            !self.currentHotSpot.hotSpotDescription.length) {
            
            isCurrentHotspotCreatedFromWebPanel = NO;
        }
        [self refreshUI];
    }
    return self;
}

- (void) initUI{
    
    if (!isCurrentHotspotCreatedFromWebPanel) {
        
        self.hotSpotPlaceLabel.hidden = YES;
        self.hotSpotSiteLabel.hidden = YES;
        self.hotSpotPhoneLabel.hidden = YES;
        self.hotSpotOpenTimeLabel.hidden = YES;
        self.hotSpotDescriptionLabel.hidden = YES;
        
        self.iconLocation.hidden = YES;
        self.iconPhone.hidden = YES;
        self.iconOpenTime.hidden = YES;
        self.iconWebAddress.hidden = YES;
    }
}
-(IBAction)hidePhotoInformationView{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.bgphotoInformationView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.photoInformationView.frame =CGRectMake( self.bgViewThankYou.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}

-(void)setPhotoInformationView{
    
    self.photoInformationView.frame = CGRectMake( 0 , self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    self.photoInformationView.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.photoInformationView.frame  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.bgphotoInformationView.alpha = 1;
        }];
    }];
}
-(void)setUpSelfThankYouView{
    
    
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
-(IBAction)hideHardThankYouAndOpenGallary{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.bgViewThankYou.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.thankYouView.frame =CGRectMake( self.bgViewThankYou.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            [self fromGallary:nil];
        }];
    }];
    
}
-(IBAction)hideHardPhotoInformationViewAndOpenGallary{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.bgphotoInformationView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.photoInformationView.frame =CGRectMake( self.bgViewThankYou.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            [self choose];
        }];
    }];
    
}
-(void)mainInit
{


}
- (void)viewDidLoad {
    [super viewDidLoad];
    [data removeAllObjects];
    bubbleCount = 0;
    checkedIn = NO;
    bubbleView.frame = self.view.bounds;
    [self setScroll];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)backAction
{
    self.currentHotSpot = nil;
    if ([ModalClass sharedInstance].newHotSpot == YES) {
         [self dismissViewControllerAnimated:YES completion:^{
             [ModalClass sharedInstance].newHotSpot= NO;
             [APP myMain:[[UserMapVC alloc] init]];
         }];
       
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setScroll{
    
    if (!isCurrentHotspotCreatedFromWebPanel) {
        
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,self.scrollView.frame.size.height-160)];
        
        [self.scrollView setFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.view.frame.size.height)];
    }
    else
    {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,self.scrollView.frame.size.height+60)];
        
        [self.scrollView setFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.view.frame.size.height)];
    }
    
    [viewWithScroll addSubview:self.scrollView];
}
//--------------------------------------------------

-(void)setUpBubbles{
    
    buttonNo = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(addbuttons) userInfo:nil repeats:YES];
    bubbleView = [[HEBubbleView alloc] initWithFrame:self.viewForTag.frame];
    bubbleView.alwaysBounceVertical  = NO;
    bubbleView.bubbleDataSource =(id)self;
    bubbleView.bubbleDelegate = (id)self;
    bubbleView.selectionStyle = HEBubbleViewSelectionStyleDefault;
    bubbleView.itemHeight = USER_IDEOMA_IPHONE? 24 : 64;
    [self.viewForTag addSubview:bubbleView];
    
}

-(void) addbuttons {
    
    
    if ([self.hotSpotTagsArray count]) {
        [self performSelector:@selector(addDummyItem)];
        
        buttonNo++;
        
        if (buttonNo == [self.hotSpotTagsArray count]) {
            
            [timer invalidate];
            
            timer = nil;
        }
    }else{
        
        [timer invalidate];
    }
    
}
-(void)addDummyItem
{
    if(bubbleCount == [self.hotSpotTagsArray count]) return;
    NSLog(@"%@",self.hotSpotTagsArray);
    [data addObject:[NSString stringWithFormat:@"%@    ",[self.hotSpotTagsArray objectAtIndex:bubbleCount]]];
    [bubbleView addItemAnimated:YES];
    bubbleCount++;
    
}


-(NSInteger)numberOfItemsInBubbleView:(HEBubbleView *)bubbleView
{
    return [self.hotSpotTagsArray count];
}


-(HEBubbleViewItem *)bubbleView:(HEBubbleView *)bubbleViewIN bubbleItemForIndex:(NSInteger)index
{
    
    NSString *itemIdentifier = @"bubble";
    
    HEBubbleViewItem *item = [bubbleView dequeueItemUsingReuseIdentifier:itemIdentifier];
    
    if (item == nil) {
        
        item = [[HEBubbleViewItem alloc] initWithReuseIdentifier:itemIdentifier];
        
    }
    
    item.textLabel.text = data[index];
    
    return item;
}

//--------------------------------------------------

#pragma CollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.currentHotSpot.hotSpotImages count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"emsDetailSpotCell";
    
    emsDetailSpotCell *cell = (emsDetailSpotCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    hotSpotImage *spotImage  = [self.currentHotSpot.hotSpotImages  objectAtIndex:indexPath.row];
    
    [cell.detailHotSpotImage setImageWithURL:[NSURL URLWithString:spotImage.kubImageUrl]];
    
    return cell;
}
#pragma mark Collection view layout things

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}


- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0,2,0,2);
}
-(IBAction)press:(id)sender{
    
    
    [self presentViewController:[[emsImagesVC alloc] initWithHotSpot:self.currentHotSpot] animated:YES completion:^{
        
    }];
    
}
-(void)choose
{
    
    [[[UIActionSheet alloc]initWithTitle:@"Get Image"
                                delegate:self
                       cancelButtonTitle:@"Cancel"
                  destructiveButtonTitle:nil
                       otherButtonTitles:@"Camera",@"Library",nil]
     showInView:self.view];
    
}
#pragma mark -
#pragma mark - Action sheet delegate methods
- (void)actionSheet:(UIActionSheet *)action clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    
    if (!imgPicker) {
        
        imgPicker = [[UIImagePickerController alloc] init];
        [imgPicker setDelegate:self];
    }
    
    imgPicker.allowsEditing = YES;
    
    
    switch(buttonIndex)
    {
        case 0 : {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                [[[UIAlertView alloc] initWithTitle:@"Picture" message:@"This device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                return;
            } else {
                [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                [self presentViewController:imgPicker animated:YES completion:nil];
                
                
            }
        }
            break;
            
        case 1 : {
           
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [ModalClass sharedInstance].hotSpotCropp = YES;
            [self presentViewController:imgPicker animated:TRUE completion:^{
                
            }];
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            self.imageEditor = [[DemoImageEditor alloc] initWithNibName:@"DemoImageEditor" bundle:nil];
            self.imageEditor.checkBounds = YES;
            self.imageEditor.rotateEnabled = YES;
            self.library = library;
            
            __weak typeof(self) weakSelf = self;
            
            self.imageEditor.doneCallback = ^(UIImage *editedImage, BOOL canceled){
                
                if(!canceled) {
                    
                    [[ApiCall sharedInstance] addImageToHotSpot:weakSelf.currentHotSpot.hotSpotID andImage:editedImage ResultSuccess:^(NSDictionary *success) {
                        
                        [weakSelf.currentHotSpot.hotSpotImages removeAllObjects];
                        
                        for (NSDictionary *dic in success[@"spot"][@"files"]) {
                            
                            hotSpotImage *spotImage = [[hotSpotImage alloc] init];
                            spotImage.ownerID =dic[@"uId"];
                            spotImage.fileID =dic[@"fId"];
                            spotImage.ownerName =dic[@"name"];
                            spotImage.imageUrl =dic[@"spotPath"][@"640_360"];
                            spotImage.kubImageUrl =dic[@"spotPath"][@"236_236"];
                            spotImage.ownerAvaUrl =dic[@"userPath"][@"236_236"];
                            [weakSelf.currentHotSpot.hotSpotImages addObject:spotImage];
                        }
                        
                        
                        [weakSelf.imsgeCollection reloadData];
                    } resultFailed:^(NSString *erorr) {
                        
                    }];
                    
                }
                
                [weakSelf dismissViewControllerAnimated:FALSE completion:^{
                    
                }];
                
            };
 
            
        }
            break;
            
        default:
            break;
    }
    
}

-(IBAction)fromGallary:(id)sender{
    
    
    
    NSDictionary *neededData = [NSDictionary dictionaryWithObjectsAndKeys:self.currentHotSpot.hotSpotID,@"spot_id", nil];
    
    [[ApiCall sharedInstance] checkDistance:neededData andResult:^(NSDictionary* result){
        
        NSLog(@"%@",result[@"distance"]);
        
        checkedIn = [[NSString stringWithFormat:@"%@",result[@"is_checkin"]] boolValue];
        
        
        
        if (!checkedIn)
            
        {
            
            if([[NSString stringWithFormat:@"%@",result[@"distance"]] doubleValue]<=0.1f){
                
                
                
                [self setPhotoInformationView];
                
                
                
            }else{
                
                
                
                [[[UIAlertView alloc] initWithTitle:@"Add Image" message:@"You should be located at the hot spot" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                
                
                
            }
            
            
            
            
            
        }
        
        else
            
        {
            
            
            
            if([[NSString stringWithFormat:@"%@",result[@"distance"]] doubleValue]<=0.1f){
                
                
                
                [self choose];
                
                
                
            }else{
                
                
                
                [[[UIAlertView alloc] initWithTitle:@"Add Image" message:@"You should be located at the hot spot" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                
                
                
            }
            
            
            
        }
        
        
        
        
        
    } resultFailed:^(NSString *failed){
        
        
        
        
        
    }];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagepicker{
    [imagepicker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
    UIImage *image =  [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    image =  [info objectForKey:UIImagePickerControllerOriginalImage];
    assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    [self.library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        
            UIImage *preview = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
            self.imageEditor.sourceImage = image;
            self.imageEditor.previewImage = preview;
            [self.imageEditor reset:NO];
            [picker pushViewController:self.imageEditor animated:YES];
            [picker setNavigationBarHidden:YES animated:NO];
        
        NSData* content = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage],0.5);
        [[ApiCall sharedInstance] addImageToHotSpot:self.currentHotSpot.hotSpotID andImage:[UIImage imageWithData:content] ResultSuccess:^(NSDictionary *success) {
            
            [self.currentHotSpot.hotSpotImages removeAllObjects];
            
            for (NSDictionary *dic in success[@"spot"][@"files"]) {
                
                hotSpotImage *spotImage = [[hotSpotImage alloc] init];
                spotImage.ownerID =dic[@"uId"];
                spotImage.fileID =dic[@"fId"];
                spotImage.ownerName =dic[@"name"];
                spotImage.imageUrl =dic[@"spotPath"][@"640_360"];
                spotImage.kubImageUrl =dic[@"spotPath"][@"236_236"];
                spotImage.ownerAvaUrl =dic[@"userPath"][@"236_236"];
                [self.currentHotSpot.hotSpotImages addObject:spotImage];
            }
            [self checkInVoid];
            [self.imsgeCollection reloadData];
            
        } resultFailed:^(NSString *erorr) {
            
        }];

        
        
        
    } failureBlock:^(NSError *error) {
        
    }];
    }
    else
    {
        NSData* content = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage],0.5);
        [[ApiCall sharedInstance] addImageToHotSpot:self.currentHotSpot.hotSpotID andImage:[UIImage imageWithData:content] ResultSuccess:^(NSDictionary *success) {
            
            [self.currentHotSpot.hotSpotImages removeAllObjects];
            
            for (NSDictionary *dic in success[@"spot"][@"files"]) {
                
                hotSpotImage *spotImage = [[hotSpotImage alloc] init];
                spotImage.ownerID =dic[@"uId"];
                spotImage.fileID =dic[@"fId"];
                spotImage.ownerName =dic[@"name"];
                spotImage.imageUrl =dic[@"spotPath"][@"640_360"];
                spotImage.kubImageUrl =dic[@"spotPath"][@"236_236"];
                spotImage.ownerAvaUrl =dic[@"userPath"][@"236_236"];
                [self.currentHotSpot.hotSpotImages addObject:spotImage];
            }
            [self checkInVoid];
            [self.imsgeCollection reloadData];
            
        } resultFailed:^(NSString *erorr) {
            
        }];
        
        
    
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)checkInVoid
{

    if([self.currentHotSpot.hotSpotDistance doubleValue]<=0.1f){
        
    if(self.currentHotSpot.followersCount==nil){
        self.currentHotSpot.followersCount=@"0";
    }
    
    __block int fCount = [self.currentHotSpot.followersCount intValue];
    
    
    [[ApiCall sharedInstance] checkInInHotSpot:_currentHotSpot.hotSpotID checkIn:!checkedIn ResultSuccess:^(NSDictionary *success){
       
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
         
        
        checkedIn=!checkedIn;
        if(checkedIn==YES){
            self.checkInImage.image = [UIImage imageNamed:@"checked"];
           [self setUpSelfThankYouView];
            fCount++;
            self.currentHotSpot.followersCount=[NSString stringWithFormat:@"%d",fCount];
            self. hotSpotUserCount.text = [NSString stringWithFormat:@"%@ users in",self.currentHotSpot.followersCount];
        }else{
            fCount--;
            self.checkInImage.image = [UIImage imageNamed:@"unchecked"];
        }
        self.currentHotSpot.isMember = [NSString stringWithFormat:@"%i",checkedIn];
        self.currentHotSpot.followersCount=[NSString stringWithFormat:@"%@",success[@"spot"][@"check_ins"]];
        self.hotSpotUserCount.text = [NSString stringWithFormat:@"%@ users in",success[@"spot"][@"check_ins"]];
        
            
        }];
        
    } resultFailed:^(NSString *erorr) {
        
    }];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Check-In" message:@"You should be located near the hot spot" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];

    }
}
-(IBAction)checkIn
{

    [self checkInVoid];

}

@end
