//
//  SettingVC.m
//  ChatApplication
//
//  Created by developer on 06/11/14.
//  Copyright (c) 2014 developer. All rights reserved.
//

#import "SettingVC.h"

const float INFINITY_RADIUS_INT_CONST = 50000.0;
const float NONINFINITY_RADIUS_INT_CONST = 50.0;

@interface SettingVC ()

@property (assign, nonatomic) BOOL previousSettedRadiusWasInfinity;
@property (strong, nonatomic) NSNumber *currentRadius;


@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *radiusLbl;
@property (weak, nonatomic) IBOutlet UISwitch *InfinityRadiusSwitch;


@end

@implementation SettingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.slider.minimumValue = 1;
    self.slider.maximumValue = 100;
    
    __weak typeof(self) weakSelf = self;
    [[ApiCall sharedInstance] getRadiusResultSuccess:^(NSDictionary *result) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf) {
            NSNumber *radius = result[@"settings"][@"radius"];
            
            self.currentRadius = radius;
            
            self.previousSettedRadiusWasInfinity = ([self.currentRadius floatValue] == INFINITY_RADIUS_INT_CONST);
            
            if (!self.previousSettedRadiusWasInfinity)
            {
                self.InfinityRadiusSwitch.on = NO;
            }
            
            [self updateUI];
        }
    }
                                        resultFailed:^(NSString *fail) {
                                            
                                        }];
    
    [self.slider addTarget:self
                    action:@selector(sliderDidEndMoving:)
          forControlEvents:UIControlEventTouchUpInside];
}




- (void) updateRadiusLabel:(NSString *) radiusString
{
    self.radiusLbl.text = radiusString;
}

-(IBAction)leftDrawerButtonPress{
    [APP leftOpen];
}

- (IBAction)sliderDidEndMoving:(id)sender {
    
    int radius = (int)self.slider.value;
    [self updateRadiusLabel:[NSString stringWithFormat:@"%d", radius]];
    
    [self setRadius:radius];
}

- (void) setRadius:(int) miles
{
    [[ApiCall sharedInstance] setRadius:[NSString stringWithFormat:@"%d", miles]
                          ResultSuccess:^(NSDictionary *result) {
                              
                          }
                           resultFailed:^(NSString *fail) {
                               
                           }];
}

- (void) updateUI
{
    if (self.previousSettedRadiusWasInfinity) {
        
        self.slider.enabled = NO;
        [self updateRadiusLabel:@"Infinity"];
        self.previousSettedRadiusWasInfinity = NO;
    }
    else
    {
        self.slider.enabled = YES;
        [self updateRadiusLabel:[NSString stringWithFormat:@"%d", [self.currentRadius intValue]]];
        self.previousSettedRadiusWasInfinity = YES;
    }
    
    self.slider.value = [self.currentRadius floatValue];
}

- (IBAction)flip:(id)sender {
    
    if (self.InfinityRadiusSwitch.on)
    {

        self.currentRadius = [NSNumber numberWithFloat:INFINITY_RADIUS_INT_CONST];
    }
    else
    {
        self.currentRadius = [NSNumber numberWithFloat:NONINFINITY_RADIUS_INT_CONST];
    }
    
    [self setRadius:[self.currentRadius intValue]];
    [self updateUI];
    
}

@end
