//
//  EditProfileVC.m
//  ChatApplication
//
//  Created by developer on 02/07/14.
//  Copyright (c) 2014 developer. All rights reserved.
//


#import "EditProfileVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DemoImageEditor.h"
#import "UserMapVC.h"
#import <CoreLocation/CoreLocation.h>
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "ModalClass.h"
@interface EditProfileVC (){
    
    //-------------------------------------

    NSMutableArray *data;
    
    int buttonNo;
    
    NSInteger bubbleCount;
    
    NSTimer *timer;
    
    //-------------------------------------
    
    UIImagePickerController *imgPicker;
    
    BOOL isPickerShow;
    
    IBOutlet UIDatePicker* numberPick;
    
    IBOutlet UIView *viewWithPicker;
    
    CLLocationManager *locationManager;
    
    double currentLongitude;
    
    double currentlatitude;
    
    UIPopoverController*  popoverController ;

}



//---------------------------
@property (weak,nonatomic)IBOutlet UIScrollView *tagsScrol;
@property (retain, nonatomic) IBOutlet UILabel *dateLable;
@property (retain, nonatomic) IBOutlet UIImageView *avatarImage;
@property (nonatomic, retain) IBOutlet UITextField *nameTF;
@property (nonatomic, retain) IBOutlet UITextField *surnameTF;
@property (nonatomic, retain) IBOutlet UITextField *aboutMeTF;
@property (nonatomic, retain) IBOutlet UITextField *emailTF;
@property (nonatomic, retain)  IBOutlet UIButton *dateOfBornButton;
@property (nonatomic, retain)  IBOutlet UIButton *deleteProfileBtn;
@property (nonatomic, retain)  IBOutlet UIButton *tagsButton;
@property (nonatomic, retain)  IBOutlet UILabel* aboutLable;
@property (nonatomic, retain)  IBOutlet UILabel* youCanLable;
@property(nonatomic,strong) DemoImageEditor *imageEditor;
@property(nonatomic,strong) ALAssetsLibrary *library;
@property (nonatomic, retain)  IBOutlet UIButton *backButton;
@property (nonatomic, retain)  NSString *dobString;
@property (retain, nonatomic) NSMutableArray *tagsArray;
@property (retain, nonatomic) User *currentUser;
@property (retain, nonatomic) IBOutlet UILabel *editProfileLable;
@property (nonatomic, retain)  IBOutlet UIButton *saveButton;
@property (retain, nonatomic) IBOutlet UILabel *dateLableDescript;
@property (retain, nonatomic) IBOutlet UILabel *tagsLable;
@property (retain, nonatomic) IBOutlet UIImageView *backButtonImg;
@property (weak, nonatomic) IBOutlet UIView *viewForTag;

@property (weak, nonatomic) IBOutlet UITextView *discriptionTextView;
@property (retain, nonatomic) IBOutlet UILabel *editProfileLbl;
@end

@implementation EditProfileVC


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)cornerIm:(UIView*)imageView{
    imageView .layer.cornerRadius = imageView.frame.size.height / 2 ;
    imageView.layer.masksToBounds = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self cornerIm: self.avatarImage];
   
    [self setUI];
    [data removeAllObjects];
    self.nameTF.text = [ModalClass sharedInstance].userFullName;
    self.discriptionTextView.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"profileUserDescription"];
    bubbleCount = 0;
    if([[APP registeredKeyIsInstalled] isEqualToString:@"1"]){
        self.deleteProfileBtn.hidden = NO;
           self.editProfileLbl.text = @"Edit Profile";
    }else{
        self.deleteProfileBtn.hidden = YES;
    }
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
          }
    return self;
}


-(IBAction)popover{
    
    if (self.view.window!=nil) {
        
        if (!imgPicker) {
            imgPicker = [[UIImagePickerController alloc] init];
            imgPicker.delegate = (id)self;
        }
        
        [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        popoverController = [[UIPopoverController alloc] initWithContentViewController:imgPicker];
        CGRect popoverRect = [self.view convertRect:[self.view.window frame]
                                           fromView:[self.view.window superview]];
        
        popoverRect.size.width = MIN(popoverRect.size.width, 100) ;

        [popoverController
         presentPopoverFromRect:popoverRect
         inView:self.view
         permittedArrowDirections:UIPopoverArrowDirectionAny
         animated:YES];
        
    }
}


-(id)initWhithUser:(User *)user{
    
    self = [super init];
    
    if (self) {
        
        self.nameTF.text = user.firstName;
        
        self.emailTF.text = user.eMail;
        
        self.aboutMeTF.text = user.about;
    
    }
    
    return self;
    
}
-(IBAction)back
{

    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MC connected];
    [self.avatarImage setImageWithURL:[NSURL URLWithString:[ModalClass sharedInstance].userAvatarImageUrl] ];
    
    [self picData];
    
    UIColor *color = [UIColor colorWithRed:136.0/255.0
                                     green:198.0/255.0
                                      blue:200.0/255.0
                                     alpha:1.0] ;
    
    self.nameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.nameTF.placeholder attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:13.0]}];

}

- (void)setUI{
    
    self.nameTF.layer.cornerRadius=6.0f;
    self.nameTF.layer.masksToBounds=YES;
        self.nameTF.layer.borderWidth= 1.0f;

    [[ self.nameTF layer] setBorderColor:[[UIColor colorWithRed:136.0/255.0
                                                       green:198.0/255.0
                                                        blue:200.0/255.0
                                                       alpha:1.0] CGColor]];
    
    self.discriptionTextView.layer.cornerRadius=6.0f;
    self.discriptionTextView.layer.masksToBounds=YES;
    self.discriptionTextView.layer.borderWidth= 1.0f;
    
    [[ self.discriptionTextView layer] setBorderColor:[[UIColor colorWithRed:136.0/255.0
                                                          green:198.0/255.0
                                                           blue:200.0/255.0
                                                          alpha:1.0] CGColor]];

    
    
    [self picData];
    
    
}
-(IBAction)mapActiom:(id)sender{

    if (self.avatarImage.image == nil || [self.avatarImage.image isEqual:[UIImage imageNamed:@"user_photo"]] ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Select Image"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
        
        return;
 
    }
    
    
    if (self.nameTF.text.length == 0 || [self.nameTF.text isEqualToString:@" "]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please enter your name"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
        
        
        return;

    }
    
    if ([self.discriptionTextView.text isEqualToString:@"Please enter description"]) {
        self.discriptionTextView.text = @"";
    }
    
    [[ApiCall sharedInstance] udateProfile:self.nameTF.text andDescription:self.discriptionTextView.text andImage:self.avatarImage.image ResultSuccess:^(NSString *succeess) {
         [APP installRegisteredKey:YES];
         [APP setUpNavigator];
    } resultFailed:^(NSString *error) {
        
    }];
    

}
-(void)picData{
    
    isPickerShow=NO;
    
    viewWithPicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height , 320, 255);
    
    [self.view addSubview:viewWithPicker];

}
-(void)resingTF{
    
    [self.nameTF resignFirstResponder];
    
    [self.aboutMeTF resignFirstResponder];
    
}



-(IBAction)hidePicker{
    
    if (isPickerShow) {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMMM dd, yyyy"];
        NSString * date = [dateFormat stringFromDate:[numberPick date] ];
        self.dobString = date;
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            
            viewWithPicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height , 320, 255);
            
            self.dateLable.hidden = NO;
            
            self.dateLable.text = self.dobString;
            
            isPickerShow=NO;
       }];
        
    }
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 1;
}

-(void)imageRound{
    
    //[self.avatarImage setCornerRadiusForUIImageView];
}

-(IBAction)fromGallary:(id)sender{
    
    if (!USER_IDEOMA_IPHONE && !IS_iOS_7) {
        
        [self popover];
        
        return;
    }
 
    if (!imgPicker) {
        
        imgPicker = [[UIImagePickerController alloc] init];
        
        [imgPicker setDelegate:(id)self];
        
    }
    imgPicker.allowsEditing = NO;
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [ModalClass sharedInstance].profileCropp = YES;
    [self presentViewController:imgPicker animated:TRUE completion:^{
        
    }];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    self.imageEditor = [[DemoImageEditor alloc] initWithNibName:@"DemoImageEditor" bundle:nil];
    self.imageEditor.checkBounds = YES;
    self.imageEditor.rotateEnabled = YES;
    self.library = library;
    
    __weak typeof(self) weakSelf = self;
    
    self.imageEditor.doneCallback = ^(UIImage *editedImage, BOOL canceled){
        [MC saveData:editedImage toArchive:@"myAvatar"];
        if(!canceled) {
            weakSelf.avatarImage.image = editedImage;
        }
        [weakSelf dismissViewControllerAnimated:FALSE completion:^{
            
        }];
    };
}


-(IBAction)iditeImage{

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    self.imageEditor = [[DemoImageEditor alloc] initWithNibName:@"DemoImageEditor" bundle:nil];
    
    self.imageEditor.checkBounds = YES;
    
    self.imageEditor.rotateEnabled = YES;
    
    self.library = library;
    
    __weak typeof(self) weakSelf = self;

    self.imageEditor.sourceImage = API.userAvatar;;
   // self.imageEditor.previewImage = preview;
    [self.imageEditor reset:NO];
    
    [self presentViewController:self.imageEditor animated:YES completion:^{
        
    }];
    //[self setNavigationBarHidden:YES animated:NO];
    
    self.imageEditor.doneCallback = ^(UIImage *editedImage, BOOL canceled){
        
        [MC saveData:editedImage toArchive:@"myAvatar"];
        
        if(!canceled) {

            
            weakSelf.avatarImage.image = editedImage;
        
        }
        
        
        [weakSelf dismissViewControllerAnimated:FALSE completion:^{
            
        }];
        
    };

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




-(void)roundAvatar:(UIImage*)imageAvatar{
    
    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(self.avatarImage.frame.origin.x, self.avatarImage.frame.origin.y,
                                                                       self.avatarImage.frame.size.width, self.avatarImage.frame.size.height)];
    
    image.image = imageAvatar;
    image.center =  self.avatarImage.center;
    CALayer* containerLayer = [CALayer layer];
  
    containerLayer.shadowRadius = 10.f;
    containerLayer.shadowOffset = CGSizeMake(0.f, 5.f);
    containerLayer.shadowOpacity = 1.f;
   
    image.layer.cornerRadius = roundf(image.frame.size.width/2.0);
    image.layer.masksToBounds = YES;
    [containerLayer addSublayer:image.layer];
    [self.view.layer addSublayer:containerLayer];
    
}


- (void)didTakePicture:(UIImage *)picture
{
//    UIImage * flippedImage = [UIImage imageWithCGImage:picture.CGImage scale:picture.scale orientation:UIImageOrientationLeftMirrored];
//    
   /// picture = flippedImage; проверить
}


-(void)setUpUser{
    
    NSDate *lastUpdate = [[NSDate alloc] initWithTimeIntervalSince1970:[_currentUser.DoB doubleValue]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"MMMM dd, yyyy"];
   
    self.dateLable.hidden = NO;
    
    self.dateLable.text = [dateFormat stringFromDate:lastUpdate ];
    
 //   self.avatarImage.image = API.userAvatar;

    self.nameTF.text = self.currentUser.firstName;
    
    self.emailTF.text = self.currentUser.eMail;
    
    self.aboutMeTF.text = self.currentUser.about;
    
    self.backButton.hidden = NO;
}

-(IBAction)fromCamera:(id)sender{
    
    if (imgPicker) {
        imgPicker = nil;
    }
    
    if (!imgPicker) {
        imgPicker = [[UIImagePickerController alloc] init];
        [imgPicker setDelegate:(id)self];
    }
    
    
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imgPicker animated:TRUE completion:nil];
        
        
    }else{
        UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Your Device doesn't support a camera"
                                                    delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:nil, nil];
        [warning show];
        
    }
    [ModalClass sharedInstance].profileCropp = YES;

    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    self.imageEditor = [[DemoImageEditor alloc] initWithNibName:@"DemoImageEditor" bundle:nil];
    self.imageEditor.checkBounds = YES;
    self.imageEditor.rotateEnabled = YES;
    self.library = library;
    __weak typeof(self) weakSelf = self;
    
        self.imageEditor.doneCallback = ^(UIImage *editedImage, BOOL canceled){
        
        [MC saveData:editedImage toArchive:@"myAvatar"];
        
        if(!canceled) {
            
            weakSelf.avatarImage.image = editedImage;
            

        }

        
        [weakSelf dismissViewControllerAnimated:FALSE completion:^{
            
        }];
        
    };
    
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [imgPicker dismissViewControllerAnimated:TRUE completion:^{
        
    }];
}


#pragma mark - CLLocationManagerDelegate


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        currentLongitude = currentLocation.coordinate.longitude;
        currentlatitude =  currentLocation.coordinate.latitude;
    }
}
-(IBAction)seveAction:(id)sender{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)dealloc{
    numberPick = nil;
    viewWithPicker = nil;
    locationManager = nil;
    _avatarImage = nil;
    _currentUser = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    
    [UIView animateWithDuration:0.4f animations:^{
        
        self.discriptionTextView.frame =CGRectMake(self.discriptionTextView.frame.origin.x,
                                                   150,
                                                   self.discriptionTextView.frame.size.width ,
                                                   self.discriptionTextView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];

    if ([textView.text isEqualToString:@"Please enter description"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.4f animations:^{
        
    self.discriptionTextView.frame =CGRectMake(self.discriptionTextView.frame.origin.x,
                                               230,
                                               self.discriptionTextView.frame.size.width,
                                               self.discriptionTextView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];

    if ([textView.text isEqualToString:@""]) {
        textView.text =  @"Please enter description";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger textLength = 0;
    textLength = [textView.text length] + [text length] - range.length;
    NSLog(@"%ld",(long)textLength);
    if( textLength==500)
    {
        [[[UIAlertView alloc] initWithTitle:@"Description"
                                                          message:@"You can not add more then 500 characters"
                                                         delegate:nil
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil, nil] show];
        
        
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
-(void)deleteProfile
{

    [[ApiCall sharedInstance]  profileDeleteWithResultSuccess:^(BOOL succeess) {
        NSLog(@"%i",succeess);
        [APP logOut];
        [APP iphoneLogin];
        
    } resultFailed:^(NSString *error) {
        NSLog(@"%@",error);
        
    }];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==666)
    {
        if(buttonIndex==0){
        
            [APP setUpNavigator];
        
        }
    
    }
    else
    {
        if(buttonIndex==0){
            [self deleteProfile];
        }
    }
    
}
-(IBAction)deleteProfileBtnAction
{
    UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@"Delete Profile"
                                                      message:@"Are you sure you want to delete your own profile?"
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:@"Cancel", nil];
    [warning show];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backAction
{
    
    UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@"Edit Profile"
                                                      message:@"All unsaved data will be lost"
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:@"Cancel", nil];
    warning.tag=666;
    [warning show];
    

}

@end
