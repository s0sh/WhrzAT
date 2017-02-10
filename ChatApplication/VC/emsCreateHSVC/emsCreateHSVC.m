//

//  emsCreateHSVC.m

//  ChatApplication

//

//  Created by developer on 04/01/16.

//  Copyright © 2016 ErmineSoft. All rights reserved.

//



#import "emsCreateHSVC.h"

#import "HEBubbleView.h"

#import "HEBubbleViewItem.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "ApiCall.h"

#import "ModalClass.h"

#import "emsDetailHotSpot.h"

#import "emsHotSpot.h"

#import "UIImageView+AFNetworking.h"

#import "DemoImageEditor.h"

#import "hotSpotImage.h"

#import <CoreLocation/CoreLocation.h>
#import "emsGlobalLocationServer.h"

static BOOL isCustomTagSet = NO;

#define OFFSET_SAVE_BUTTON_ALWAYS_AT_BOTTOM_AND_VISIBLE 158



@interface emsCreateHSVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>{
    
    
    
    NSString *address;
    
    
    
    IBOutlet UIView *viewWithScroll;
    
    
    
    NSMutableArray *data;
    
    
    
    int buttonNo;
    
    
    
    HEBubbleView *bubbleView;
    
    
    
    NSInteger bubbleCount;
    
    
    
    NSTimer *timer;
    
    
    
    BOOL isPickerShow;
    
    
    
    UIImagePickerController *imgPicker;
    
    
    
    IBOutlet UIPickerView* numberPick;
    
    
    
    IBOutlet UIView *viewWithPicker;
    
    
    
    NSMutableArray *zero;
    
    NSArray *preloadedTagsConst;
    
    
    
    BOOL resise;
    
    
    
}

@property(nonatomic,strong) ALAssetsLibrary *library;

@property(nonatomic,strong) DemoImageEditor *imageEditor;

@property (retain, nonatomic) User *currentUser;

@property(nonatomic, weak)IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UIView *viewForTag;

@property (retain, nonatomic) IBOutlet UIImageView *avatarImage;

@property (weak, nonatomic) IBOutlet UITextView *discriptionTextView;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *adressTF;

@property (weak, nonatomic) IBOutlet UITextField *webTF;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UITextField *timeTF;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet UITextField *tagsTF;



@property (retain, nonatomic) IBOutlet UIImageView *holder;

@end



@implementation emsCreateHSVC



-(void)standartTags{
    
    
    
    zero = [[NSMutableArray alloc] initWithObjects:@"food",@"shopping",@"sport",@"entertainment",nil];
    
    preloadedTagsConst = [[NSArray alloc] initWithArray:zero];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    
    
    return 1;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    
    return [zero objectAtIndex:row];
    
}



- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    
    
    return [zero count];
    
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
    
    
    
    self.tagsTF.text = [zero objectAtIndex:row];
    
}

-(void)addDummyItem

{
    
    bubbleCount++;
    
    
    
    NSInteger index = [data count];
    
    
    
    if (index < 0) {
        
        index = 0;
        
    }
    
    
    
    if (index > [data count]) {
        
        index = [data count];
        
    }
    
    
    
    NSLog(@"%@",self.currentUser.tagsArray);
    
    
    
    
    
    
    
    [data insertObject:[NSString stringWithFormat:@"%@   х    ",[self.currentUser.tagsArray objectAtIndex:bubbleCount -1]] atIndex:index];
    
    
    
    [bubbleView addItemAnimated:YES];
    
    
    
}

-(IBAction)hidePicker{
    
    
    
    [self scrolToTextField:self.tagsTF];
    
    if (isPickerShow) {
        
        
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            
            
            
            viewWithPicker.frame = CGRectMake(0, kMainScreenBounds , 320, 255);
            
            
            
            isPickerShow=NO;
            
            [self addTag];
            
            
            
            
            
        }];
        
    }
    
    
    
}

-(IBAction)showPicker

{
    
    
    
    if (isPickerShow==NO) {
        
        
        
        
        
        [self scrolToTextField:self.tagsTF];
        
        if(zero.count>0)
            
            self.tagsTF.text = [zero objectAtIndex:0];
        
        
        
        [self.view endEditing:YES];
        
        
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            
            
            
            viewWithPicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-viewWithPicker.frame.size.height , 320, 555);
            
            isPickerShow=YES;
            
        }];
        
        
        
        
        
    }
    
}

-(void)picData

{
    
    
    
    isPickerShow=NO;
    
    viewWithPicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height , 320, 255);
    
    [self.view addSubview:viewWithPicker];
    
    
    
}





- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    address = [[NSString alloc] init];
    [self locationAdressCreate];
    resise= NO;
    
    [self setScroll];
    
    [self setTF];
    
    [self picData];
    
    [self setUpUser];
    
    [self setUpBubbles];
    
    self.discriptionTextView.layer.cornerRadius=2.0f;
    
    self.discriptionTextView.layer.masksToBounds=YES;
    
    self.discriptionTextView.layer.borderWidth= 1.0f;
    
    [self standartTags];
    
    
    
    [[ self.discriptionTextView layer] setBorderColor:[[UIColor colorWithRed:136.0/255.0
                                                        
                                                                       green:198.0/255.0
                                                        
                                                                        blue:200.0/255.0
                                                        
                                                                       alpha:1.0] CGColor]];
    
    numberPick.delegate = self;
    
    if([[ModalClass sharedInstance].street containsString:@"null"]){
        
        self.adressTF.text = @"Undefined address";
        
    }
    
    else{
        
        self.adressTF.text = [ModalClass sharedInstance].street;
        
    }
    
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    
    
}

//---------------------------



-(void)setScroll

{
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,self.scrollView.frame.size.height+64)];
    
    [self.scrollView setFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.view.frame.size.height)];
    
    [viewWithScroll addSubview:self.scrollView];
    
}

//---------------------------





-(void)viewWillAppear:(BOOL)animated

{
    
    
    
    [super viewWillAppear:animated];
    
    
    
    
    
    
    
    
    
    [data removeAllObjects];
    
    
    
    bubbleCount = 0;
    
    
    
    bubbleView.frame = self.view.bounds;
    
    
    
    
    
    
    
}



-(void)setTF

{
    
    
    
    
    
    for (UITextField *tf in self.scrollView.subviews) {
        
        
        
        
        
        if ([tf isKindOfClass:[UITextField class]]) {
            
            
            
            UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            
            [tf setLeftViewMode:UITextFieldViewModeAlways];
            
            [tf setLeftView:spacerView];
            
            UIColor *colorText = [UIColor colorWithRed:92.0/255.0
                                  
                                                 green:97.0/255.0
                                  
                                                  blue:101.0/255.0
                                  
                                                 alpha:1.0] ;
            
            tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:tf.placeholder
                                        
                                                                       attributes:@{NSForegroundColorAttributeName: colorText,
                                                                                    
                                                                                    NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0]}];
            
            
            
            
            
            tf.layer.cornerRadius = 2.0f;
            
            tf.layer.masksToBounds=YES;
            
            tf.layer.borderWidth= 1.0f;
            
            
            
            [[tf layer] setBorderColor:[[UIColor colorWithRed:136.0/255.0
                                         
                                                        green:198.0/255.0
                                         
                                                         blue:200.0/255.0
                                         
                                                        alpha:1.0] CGColor]];
            
            
            
            
            
            
            
        }
        
    }
    
}

-(void)setUpUser

{
    
    
    
    
    
    data = [[NSMutableArray alloc] init];
    
    
    
    bubbleCount = 0;
    
    
    
    
    
    self.currentUser = [[User alloc] init];
    
    
    
    self.currentUser .tagsArray =[[NSMutableArray alloc] init];
    
    
    
    self.currentUser .userID = [[NSNumber numberWithInt:0] stringValue];
    
    
    
    self.currentUser .userAge = [NSNumber numberWithInt:20];
    
    
    
    self.currentUser .currentStatus = @"Not the power to remember, but its very";
    
    
    
    self.currentUser .firstName = [NSString stringWithFormat:@" " ];
    
    
    
    self.currentUser .listName = [NSString stringWithFormat:@" " ];
    
    
    
    self.currentUser .eMail = [NSString stringWithFormat:@"parampam " ];
    
    
    
    self.currentUser .latitude = [[NSNumber numberWithFloat:37.800] stringValue];
    
    
    
    self.currentUser .longitude = [[NSNumber numberWithFloat:-122.0008] stringValue];
    
}

-(void)setUpBubbles{
    
    
    
    buttonNo = 0;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(addbuttons) userInfo:nil repeats:YES];
    
    bubbleView = [[HEBubbleView alloc] initWithFrame:self.viewForTag.frame];
    
    bubbleView.alwaysBounceVertical  = NO;
    
    bubbleView.bubbleDataSource = (id)self;
    
    bubbleView.bubbleDelegate = (id)self;
    
    bubbleView.selectionStyle = HEBubbleViewSelectionStyleDefault;
    
    bubbleView.itemHeight = USER_IDEOMA_IPHONE? 24 : 64;
    
    [self.viewForTag addSubview:bubbleView];
    
    
    
}



-(void) addbuttons {
    
    
    
    if ([self.currentUser.tagsArray count]) {
        
        [self performSelector:@selector(addDummyItem)];
        
        
        
        buttonNo++;
        
        
        
        if (buttonNo == [self.currentUser.tagsArray count]) {
            
            
            
            [timer invalidate];
            
            
            
            timer = nil;
            
        }
        
    }else{
        
        
        
        [timer invalidate];
        
    }
    
}







-(NSInteger)numberOfItemsInBubbleView:(HEBubbleView *)bubbleView

{
    
    return [self.currentUser.tagsArray count];
    
}





-(HEBubbleViewItem *)bubbleView:(HEBubbleView *)bubbleViewIN bubbleItemForIndex:(NSInteger)index

{
    
    
    
    NSString *itemIdentifier = @"bubble";
    
    
    
    HEBubbleViewItem *item = [bubbleView dequeueItemUsingReuseIdentifier:itemIdentifier];
    
    
    
    //if (item == nil) {
    
    
    
    item = [[HEBubbleViewItem alloc] initWithReuseIdentifier:itemIdentifier];
    
    
    
    //}
    
    
    
    item.textLabel.text = data[index];
    
    
    
    return item;
    
}

-(NSString *)fixStringWitXCharacterAndWhites:(NSString*)brokenTag

{
    
    NSString *newTag = @"";
    
    NSString *tmp = [NSString stringWithString:brokenTag];
    
    NSString *res = [tmp  stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if([brokenTag isEqualToString:res]){
        
        return brokenTag;
        
    }
    
    newTag = [res substringToIndex:[res length]-1];
    
    return newTag;
    
    
    
}

-(BOOL)checkTagForPreloaded:(NSString *)tag

{
    
    BOOL persist = NO;
    
    for(NSString *cur in preloadedTagsConst){
        
        if([cur isEqualToString:tag])
            
            persist = YES;
        
    }
    
    
    
    return persist;
    
}

-(void)deleteSelectedBubble:(id)sender

{
    
    NSString *check = [self fixStringWitXCharacterAndWhites:data[bubbleView.activeBubble.index]];
    
    if([self checkTagForPreloaded:check]){
        
        [zero addObject:check];
        
    }else{
        
        isCustomTagSet=NO;
        
    }
    
    [data removeObjectAtIndex:bubbleView.activeBubble.index];
    
    [numberPick reloadAllComponents];
    
    [bubbleView removeItemAtIndex:bubbleView.activeBubble.index animated:YES];
    
    
    
    self.tagsTF.text = @"";
    
    [self.tagsTF resignFirstResponder];
    
    
    
    
    
    
    
    if ([data count] == 0) {
        
        [self viewForTagIsEpty ];
        
        
        
    }
    
}



-(void)bubbleView:(HEBubbleView *)bubbleView didSelectBubbleItemAtIndex:(NSInteger)index

{
    
    
    
}





-(BOOL)bubbleView:(HEBubbleView *)bubbleView shouldShowMenuForBubbleItemAtIndex:(NSInteger)index

{
    
    return YES;
    
}

-(BOOL)canBecomeFirstResponder

{
    
    
    
    return YES;
    
}

-(NSArray *)bubbleView:(HEBubbleView *)bubbleView menuItemsForBubbleItemAtIndex:(NSInteger)index

{
    
    
    
    
    
    NSArray *items;
    
    
    
    UIMenuItem *item0 = [[UIMenuItem alloc] initWithTitle:@"Delete Tag" action:@selector(deleteSelectedBubble:)];
    
    
    
    
    
    items = @[item0];
    
    
    
    
    
    return items;
    
    
    
}

-(void)bubbleView:(HEBubbleView *)bubbleView didHideMenuForBubbleItemAtIndex:(NSInteger)index

{
    
    
    
}

//----------------------------------------------



-(IBAction)fromGallary:(id)sender{
    
    
    
    [self.view endEditing:YES];
    
    
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select option:" delegate:(id)self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            
                            @"From Gallery",
                            
                            @"From Camera",
                            
                            nil];
    
    popup.tag = 1;
    
    [popup showInView:self.view];
    
    
    
    
    
    return;
    
    //    if (!imgPicker) {
    
    //
    
    //        imgPicker = [[UIImagePickerController alloc] init];
    
    //
    
    //        [imgPicker setDelegate:(id)self];
    
    //
    
    //    }
    
    //
    
    //    imgPicker.allowsEditing = NO;
    
    //
    
    //    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    //    [ModalClass sharedInstance].hotSpotCropp = YES;
    
    //    [self presentViewController:imgPicker animated:TRUE completion:^{
    
    //
    
    //    }];
    
    //
    
    //    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    //    self.imageEditor = [[DemoImageEditor alloc] initWithNibName:@"DemoImageEditor" bundle:nil];
    
    //    self.imageEditor.checkBounds = YES;
    
    //    self.imageEditor.rotateEnabled = YES;
    
    //    self.library = library;
    
    //
    
    //    __weak typeof(self) weakSelf = self;
    
    //
    
    //    self.imageEditor.doneCallback = ^(UIImage *editedImage, BOOL canceled){
    
    //
    
    //
    
    //        if(!canceled) {
    
    //
    
    //           weakSelf.holder.hidden =YES;
    
    //
    
    //            weakSelf.avatarImage.image = editedImage;
    
    //
    
    //
    
    //        }
    
    //
    
    //
    
    //
    
    //        [weakSelf dismissViewControllerAnimated:FALSE completion:^{
    
    //
    
    //        }];
    
    //
    
    //    };
    
    
    
}



-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

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
        
        
        
        
        
    } failureBlock:^(NSError *error) {
        
        
        
    }];
    
    
    
}







#pragma mark social TFDelegate



-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    //    [self scrollBack:textField];
    
    [self scrollBack];
    
    return YES;
    
}



- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self scrolToTextField:textField];
    
}





- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    
    
    
    
    
    [textField resignFirstResponder];
    
    
    
    //    if (textField == self.tagsTF) {
    
    //        [textField resignFirstResponder];
    
    //    }
    
    //
    
    //    if (textField == self.nameTF) {
    
    //        [self.webTF becomeFirstResponder];
    
    //    }
    
    //    if (textField == self.adressTF) {
    
    //        [self.webTF becomeFirstResponder];
    
    //    }
    
    //    if (textField == self.webTF) {
    
    //        [self.phoneTF becomeFirstResponder];
    
    //    }
    
    //    if (textField == self.phoneTF) {
    
    //       [self.timeTF becomeFirstResponder];
    
    //    }
    
    //    if (textField == self.timeTF) {
    
    //       [ self.discriptionTextView becomeFirstResponder];
    
    //    }
    
    
    
    
    
    return YES;
    
}



-(void)scrolToTextField:(UITextField *)sender{
    
    
    
    [UIView animateWithDuration:0.4f animations:^{
        
        
        
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x ,sender.frame.origin.y - kScrollUP);
        
        
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    
    
    
}



-(void)scrollBack{
    
    
    
    [UIView animateWithDuration:0.4f animations:^{
        
        
        
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, OFFSET_SAVE_BUTTON_ALWAYS_AT_BOTTOM_AND_VISIBLE);
        
        NSLog(@"frameOffset: %@", NSStringFromCGPoint(self.scrollView.contentOffset));
        
        
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    
    
    
}





//-(void)scrollBack:(UITextField *)sender{

//

//    [UIView animateWithDuration:0.4f animations:^{

//

//        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x ,sender.frame.origin.y - kScrollUP*2);

//        NSLog(@"frameOffset: %@", NSStringFromCGPoint(self.scrollView.contentOffset));

//

//    } completion:^(BOOL finished) {

//

//    }];

//

//}





#pragma mark Actions



-(IBAction)leftDrawerButtonPress{
    
    [APP leftOpen];
    
}



-(IBAction)createHotSpotAction:(id)sender{
    
    
    
    
    
    for (UITextField *tf in self.scrollView.subviews) {
        
        
        
        
        
        if ([tf isKindOfClass:[UITextField class]]||[tf isKindOfClass:[UITextView class]]) {
            
            
            
            [tf resignFirstResponder];
            
            
            
        }
        
    }
    
    
    
    [UIView animateWithDuration:0.4f animations:^{
        
        
        
        self.scrollView.contentOffset = CGPointMake(0 ,140);
        
        
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    
    
    
    
    
    if(!self.nameTF.text.length){
        
        
        
        [MC alertText:@"Please enter your name"];
        
        
        
        return;
        
        
        
    }
    
//    if(self.self.discriptionTextView.text.length==0 || [self.discriptionTextView.text isEqualToString:@"Please enter description"]){
//        
//        
//        
//        [MC alertText:@"Please enter description"];
//        
//        
//        
//        return;
//        
//        
//        
//    }
    
    
    
    if(self.avatarImage.image == nil){
        
        
        
        [MC alertText:@"Please upload image"];
        
        
        
        return;
        
        
        
    }
    
    if(self.currentUser.tagsArray.count==0)
        
    {
        
        [MC alertText:@"Please select at least one tag"];
        
        
        
        return;
        
        
        
    }
    [self locationAdressCreate];
    
    [[ApiCall sharedInstance] createHotSpot:self.nameTF.text andAddress:address andtime:self.timeTF.text andDescription:self.discriptionTextView.text andLat:@"" andLng:@"" andPhone: self.phoneTF.text andlink:self.webTF.text andTags:self.currentUser.tagsArray andImage:self.avatarImage.image ResultSuccess:^(NSDictionary  *succeess) {
        
        
        
        [ModalClass sharedInstance].newHotSpot = YES;
        
        
        
        emsHotSpot * hotSpot = [[emsHotSpot alloc] init];
        
        NSArray *arr =  succeess[@"spot"][@"tags"];
        
        hotSpot.hotSpotImageURL = succeess[@"spot"][@"img"][@"path"][@"236_236"];
        
        hotSpot.rectangularHotSpotImageURL = succeess[@"spot"][@"img"][@"path"][@"640_360"];
        
        hotSpot.hotSpotTitle = succeess[@"spot"][@"name"];
        
        hotSpot.hotSpotAdress =succeess[@"spot"][@"address"];
        
        hotSpot.hotSpotWorkingTime=succeess[@"spot"][@"time"];
        
        hotSpot.hotSpotSiteAdress =succeess[@"spot"][@"link"];
        
        hotSpot.hotSpotPhoneNumber =succeess[@"spot"][@"phone"];
        
        hotSpot.hotSpotTags =[[NSMutableArray alloc] initWithArray: arr];
        
        hotSpot.hotSpotDescription =succeess[@"spot"][@"description"];
        
        hotSpot.followersCount =[NSString stringWithFormat:@"%@",succeess[@"spot"][@"check_ins"]];
        
        hotSpot.isMember = [NSString stringWithFormat:@"%@",succeess[@"spot"][@"is_member"]];
        
        hotSpot.hotSpotID = succeess[@"spot"][@"sId"];
        
        NSArray *items345 = succeess[@"spot"][@"tags"];
        
        hotSpot.hotSpotImages = [[NSMutableArray alloc] init];
        
        
        
        for (NSDictionary *dic in succeess[@"spot"][@"files"]) {
            
            hotSpotImage *spotImage = [[hotSpotImage alloc] init];
            
            spotImage.ownerID =dic[@"uId"];
            
            spotImage.ownerName =dic[@"name"];
            
            spotImage.imageUrl =dic[@"spotPath"][@"640_360"];
            
            spotImage.kubImageUrl =dic[@"spotPath"][@"236_236"];
            
            spotImage.ownerAvaUrl =dic[@"userPath"][@"236_236"];
            
            spotImage.isMyFriend =[NSString stringWithFormat:@"%@",dic[@"isMyFriend"]] ;
            
            [hotSpot.hotSpotImages addObject:spotImage];
            
        }
        
        
        
        hotSpot.hotSpotTags =[[NSMutableArray alloc] initWithArray: items345];
        
        
        
        [self presentViewController:[[emsDetailHotSpot alloc] initWithHotSpot:hotSpot] animated:YES completion:^{
            
            
            
        }];
        
        
        
        
        
        
        
    } resultFailed:^(NSString *error) {
        
        
        
    }];
    
    
    
    
    
    
    
}


-(void)locationAdressCreate
{
    CLLocation *location = [[CLLocation alloc]initWithLatitude:[[[emsGlobalLocationServer sharedInstance] latitude] longLongValue]
                                                     longitude:[[[emsGlobalLocationServer sharedInstance] longitude] longLongValue]];
    
    [[[CLGeocoder alloc]init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            CLPlacemark *placemark = placemarks[0];
            NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
            address = [lines componentsJoinedByString:@"\n"];
            self.adressTF.text = address;
            NSLog(@"Address Created: %@", address);
        }];
    }];
    
}



-(void)viewForTagIsEpty{
    
    
    
    resise = NO;
    
    
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        
        
        
        
        
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width ,self.scrollView.contentSize.height -120)];
        
        
        
        self.viewForTag.hidden = YES;
        
        [self.discriptionTextView setFrame:CGRectMake(self.discriptionTextView.frame.origin.x,self.discriptionTextView.frame.origin.y - 120, self.discriptionTextView.frame.size.width, self.discriptionTextView.frame.size.height)];
        
        
        
        
        
        [self.nameTF setFrame:CGRectMake(self.nameTF.frame.origin.x,self.nameTF.frame.origin.y - 120, self.nameTF.frame.size.width, self.nameTF.frame.size.height)];
        
        
        
        [self.adressTF setFrame:CGRectMake(self.adressTF.frame.origin.x,self.adressTF.frame.origin.y - 120, self.adressTF.frame.size.width, self.adressTF.frame.size.height)];
        
        
        
        [self.webTF setFrame:CGRectMake(self.webTF.frame.origin.x,self.webTF.frame.origin.y - 120, self.webTF.frame.size.width, self.webTF.frame.size.height)];
        
        
        
        [self.phoneTF setFrame:CGRectMake(self.phoneTF.frame.origin.x,self.phoneTF.frame.origin.y - 120, self.phoneTF.frame.size.width, self.phoneTF.frame.size.height)];
        
        
        
        [self.timeTF setFrame:CGRectMake(self.timeTF.frame.origin.x,self.timeTF.frame.origin.y - 120, self.timeTF.frame.size.width, self.timeTF.frame.size.height)];
        
        [self.saveBtn setFrame:CGRectMake(self.saveBtn.frame.origin.x,self.saveBtn.frame.origin.y - 120, self.saveBtn.frame.size.width, self.saveBtn.frame.size.height)];
        
        
        
    }];
    
    
    
    
    
}

-(void)addTag

{
    
    
    
    if(isCustomTagSet && ![self checkTagForPreloaded:self.tagsTF.text])
        
    {
        
        
        
        UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@"Tags"
                                
                                                          message:@"You can add only one own tag"
                                
                                                         delegate:nil
                                
                                                cancelButtonTitle:@"Ok"
                                
                                                otherButtonTitles:nil, nil];
        
        [warning show];
        
        
        
        return;
        
        
        
    }
    
    if (self.tagsTF.text.length==0 || [self.tagsTF.text isEqualToString:@" "] || self.tagsTF.text.length >15) {
        
        return;
        
    }
    
    if ([data count] == 5){
        
        
        
        UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@""
                                
                                                          message:@"You  can  not  add more than 5 tags"
                                
                                                         delegate:nil
                                
                                                cancelButtonTitle:@"Ok"
                                
                                                otherButtonTitles:nil, nil];
        
        [warning show];
        
        self.tagsTF.text = @"";
        
        [self.tagsTF resignFirstResponder];
        
        
        
        return;
        
    }
    
    if (resise == NO) {
        
        
        
        resise= YES;
        
        
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            
            [self.scrollView setFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.view.frame.size.height+280)];
            
            [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,self.scrollView.frame.size.height+280)];
            
            
            
            self.viewForTag.hidden = NO;
            
            [self.discriptionTextView setFrame:CGRectMake(self.discriptionTextView.frame.origin.x,self.discriptionTextView.frame.origin.y + 120, self.discriptionTextView.frame.size.width, self.discriptionTextView.frame.size.height)];
            
            
            
            
            
            [self.nameTF setFrame:CGRectMake(self.nameTF.frame.origin.x,self.nameTF.frame.origin.y + 120, self.nameTF.frame.size.width, self.nameTF.frame.size.height)];
            
            [self.adressTF setFrame:CGRectMake(self.adressTF.frame.origin.x,self.adressTF.frame.origin.y + 120, self.adressTF.frame.size.width, self.adressTF.frame.size.height)];
            
            [self.webTF setFrame:CGRectMake(self.webTF.frame.origin.x,self.webTF.frame.origin.y + 120, self.webTF.frame.size.width, self.webTF.frame.size.height)];
            
            [self.phoneTF setFrame:CGRectMake(self.phoneTF.frame.origin.x,self.phoneTF.frame.origin.y + 120, self.phoneTF.frame.size.width, self.phoneTF.frame.size.height)];
            
            [self.timeTF setFrame:CGRectMake(self.timeTF.frame.origin.x,self.timeTF.frame.origin.y + 120, self.timeTF.frame.size.width, self.timeTF.frame.size.height)];
            
            [self.saveBtn setFrame:CGRectMake(self.saveBtn.frame.origin.x,self.saveBtn.frame.origin.y + 120, self.saveBtn.frame.size.width, self.saveBtn.frame.size.height)];
            
            
            
        }];
        
        
        
    }
    
    
    
    [self.currentUser.tagsArray addObject:[self checkTagForPreloaded:self.tagsTF.text]?self.tagsTF.text:[self fixStringWitXCharacterAndWhites:self.tagsTF.text]];
    
    [zero removeObject:self.tagsTF.text];
    
    [numberPick reloadAllComponents];
    
    [self addbuttons ];
    
    if(![self checkTagForPreloaded:self.tagsTF.text]){
        
        isCustomTagSet = YES;
        
        
        
    }
    
    self.tagsTF.text =@"";
    
    [self.tagsTF resignFirstResponder];
    
    [self hidePicker];
    
    
    
    
    
}

-(IBAction)addNewTag:(id)sender{
    
    
    
    
    
    [self addTag];
    
    
    
}



- (void)textViewDidBeginEditing:(UITextView *)textView

{
    
    [UIView animateWithDuration:0.4f animations:^{
        
        
        
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x ,textView.frame.origin.y - kScrollUP);
        
        
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    
    
    
    if ([textView.text containsString:@"description"]) {
        
        textView.text = @"";
        
        textView.textColor = [UIColor blackColor]; //optional
        
    }
    
    [textView becomeFirstResponder];
    
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    
    NSInteger textLength = 0;
    
    textLength = [textView.text length] + [text length] - range.length;
    
    NSLog(@"%ld",(long)textLength);
    
    if( textLength==500)
        
    {
        
        return NO;
        
        
        
    }
    
    if([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    
    
    else{
        
        
        
        return YES;
        
        
        
    }
    
    
    
    
    
}



- (void)textViewDidEndEditing:(UITextView *)textView

{
    
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x ,140);
    
    if ([textView.text isEqualToString:@""]) {
        
        textView.text = @"Please enter description";
        
        textView.textColor = [UIColor lightGrayColor]; //optional
        
    }
    
    [textView resignFirstResponder];
    
    [self scrollBack];
    
}



- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    
    
    
    
    
    switch (buttonIndex) {
            
        case 0:
            
            [self gall];
            
            break;
            
        case 1:
            
            [self cam];
            
            break;
            
    }
    
}



-(void)gall{
    
    if (!imgPicker) {
        
        
        
        imgPicker = [[UIImagePickerController alloc] init];
        
        
        
        [imgPicker setDelegate:(id)self];
        
        
        
    }
    
    
    
    imgPicker.allowsEditing = NO;
    
    
    
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
            
            
            
            weakSelf.holder.hidden =YES;
            
            
            
            weakSelf.avatarImage.image = editedImage;
            
            
            
            
            
        }
        
        
        
        
        
        
        
        [weakSelf dismissViewControllerAnimated:FALSE completion:^{
            
            
            
        }];
        
        
        
    };
    
    
    
}



-(void)cam{
    
    if (!imgPicker) {
        
        
        
        imgPicker = [[UIImagePickerController alloc] init];
        
        
        
        [imgPicker setDelegate:(id)self];
        
        
        
    }
    
    
    
    imgPicker.allowsEditing = NO;
    
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        
        [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        [ModalClass sharedInstance].hotSpotCropp = YES;
        
        [self presentViewController:imgPicker animated:TRUE completion:^{
            
            
            
        }];
        
        
        
    }else{
        
        UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@"Error"
                                
                                                          message:@"Your Device doesn't support a camera"
                                
                                                         delegate:nil
                                
                                                cancelButtonTitle:@"Cancel"
                                
                                                otherButtonTitles:nil, nil];
        
        [warning show];
        
        
        
    }
    
    
    
    
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    self.imageEditor = [[DemoImageEditor alloc] initWithNibName:@"DemoImageEditor" bundle:nil];
    
    self.imageEditor.checkBounds = YES;
    
    self.imageEditor.rotateEnabled = YES;
    
    self.library = library;
    
    
    
    __weak typeof(self) weakSelf = self;
    
    
    
    self.imageEditor.doneCallback = ^(UIImage *editedImage, BOOL canceled){
        
        
        
        
        
        if(!canceled) {
            
            
            
            weakSelf.holder.hidden =YES;
            
            
            
            weakSelf.avatarImage.image = editedImage;
            
            
            
            
            
        }
        
        
        
        
        
        
        
        [weakSelf dismissViewControllerAnimated:FALSE completion:^{
            
            
            
        }];
        
        
        
    };
    
    
    
}





@end

