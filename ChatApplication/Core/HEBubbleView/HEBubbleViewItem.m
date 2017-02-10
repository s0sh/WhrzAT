//
//  HEBubbleViewItem.m
//  HEBubbleView
//
//  Created by developer on 19.07.12.
//  Copyright (c) 2012 Clemens Hammerl / Adam Eri. All rights reserved.
//

#import "HEBubbleViewItem.h"
#import <QuartzCore/QuartzCore.h>

static UIColor* UIColorFromRGB(NSInteger red, NSInteger green, NSInteger blue, NSInteger alpha) {
    return [UIColor colorWithRed:((float)red)/255.0
                           green:((float)green)/255.0
                            blue:((float)blue)/255.0
                           alpha:((float)alpha)/255.0];
}

@interface HEBubbleViewItem (private)
// no private methods yet
@end

@implementation HEBubbleViewItem

@synthesize delegate;
@synthesize index;
@synthesize userInfo;

@synthesize unselectedBGColor;
@synthesize selectedBGColor;

@synthesize unselectedBorderColor;
@synthesize selectedBorderColor;

@synthesize unselectedTextColor;
@synthesize selectedTextColor;

@synthesize reuseIdentifier;
@synthesize isSelected;
@synthesize textLabel;
@synthesize bubbleTextLabelPadding;

@synthesize highlightTouches;

//////////////// Memory management //////////////////////

-(void)dealloc
{
    delegate = nil;
    
    
    
    
}

//////////////////// Initialization //////////////////////
#pragma mark - initialization


-(id)initWithReuseIdentifier:(NSString *)reuseIdentifierIN;
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        reuseIdentifier = reuseIdentifierIN;
        
        textLabel = [[UILabel alloc] initWithFrame:self.bounds];
       // textLabel.font = DEFAULT_FONT;
        
              
        textLabel.textColor = [UIColor colorWithRed:95/255.f green:129/255.f blue:139/255.f alpha:1];
        
        if (USER_IDEOMA_IPHONE) {
            [textLabel setStyleLabelWhisBorder];
        }else{
            [textLabel setStyleLabelWhisBorderIpad];
        }
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        //self.backgroundColor = DEFAULT_BG_COLOR;
        
        [self addSubview:textLabel];
        
//        UIImageView* viewIm = [[UIImageView alloc] init];
//        
//        UIImage *deleteImage = [UIImage imageNamed:@"marker_yellowA.png"];
//        
//        viewIm.image =
//        
//        [self addSubview:deleteImage];
        
        self.bubbleTextLabelPadding = kITEM_TEXTLABELPADDING_LEFT_AND_RIGHT;
        
        //self.unselectedBGColor = DEFAULT_BG_COLOR;
       // self.selectedBGColor = DEFAULT_SELECTED_BG_COLOR;
        //self.unselectedTextColor = DEFAULT_TEXT_COLOR;
       // self.selectedTextColor = DEFAULT_SELECTED_TEXT_COLOR;
       // self.unselectedBorderColor = DEFAULT_BORDER_COLOR;
        //self.selectedBorderColor = DEFAULT_SELECTED_BORDER_COLOR;
        
        self.highlightTouches = YES;
        
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    
    return [self initWithReuseIdentifier:nil];
}

-(id)init
{
    return [self initWithReuseIdentifier:nil];
}

///////////////// View Logic //////////////////
#pragma mark - View Logic

-(void)layoutSubviews
{
    
    self.textLabel.frame = CGRectMake(bubbleTextLabelPadding, self.bounds.origin.y, self.bounds.size.width-2*bubbleTextLabelPadding, self.bounds.size.height);
    
  //  self.layer.masksToBounds = YES;
   // self.layer.cornerRadius = self.bounds.size.height/2;
   // self.layer.borderWidth = DEFAULT_BORDER_WIDTH;
   // self.layer.borderColor = [unselectedBorderColor CGColor];
    
   // [super layoutSubviews];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        
        if (animated) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.1];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.backgroundColor = selectedBGColor;
            self.textLabel.textColor = selectedTextColor;
            self.layer.borderColor = selectedBorderColor.CGColor;
            [UIView commitAnimations];
            
        }else {
            self.backgroundColor = selectedBGColor;
            self.textLabel.textColor = selectedTextColor;
            self.layer.borderColor = selectedBorderColor.CGColor;
        }
        
        
    }else {
        
        if (animated) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.1];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.backgroundColor = unselectedBGColor;
            self.textLabel.textColor = unselectedTextColor;
            self.layer.borderColor = unselectedBorderColor.CGColor;
            [UIView commitAnimations];
            
        }else {
            self.backgroundColor = unselectedBGColor;
            self.textLabel.textColor = unselectedTextColor;
            self.layer.borderColor = unselectedBorderColor.CGColor;
        }
        
        
    }
    
    isSelected = selected;
}


//////////////////// Bubble Item Logic /////////////////////
#pragma mark - bubble item logic

-(void)setBubbleItemIndex:(NSInteger)itemIndex
{
    index = itemIndex;
}


/*
 Resetting all values for reuse
 */

-(void)prepareItemForReuse
{
    self.textLabel.text = nil;
    [self setSelected:NO animated:NO];
    self.index = 0;
    self.delegate = nil;
    isSelected = NO;
    self.userInfo = nil;
    
    [CATransaction begin];
    [self.layer removeAllAnimations];
    [CATransaction commit];
    self.alpha = 1.0;
    self.unselectedBGColor = kDEFAULT_BG_COLOR;
    self.selectedBGColor = kDEFAULT_SELECTED_BG_COLOR;
    self.unselectedTextColor = kDEFAULT_TEXT_COLOR;
    self.selectedTextColor = kDEFAULT_SELECTED_TEXT_COLOR;
    self.unselectedBorderColor = kDEFAULT_BORDER_COLOR;
    self.selectedBorderColor = kDEFAULT_SELECTED_BORDER_COLOR;
    
    self.highlightTouches = YES;
    
}

//////////////// TOUCH HANDLING ///////////////////////
#pragma mark - Touch Handling

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    touchBegan = touchPoint;
    
    if (highlightTouches) {
        [self setSelected:YES animated:NO];
    }
    
    
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (!CGRectContainsPoint(self.bounds, touchPoint)) {
        [self touchesCancelled:touches withEvent:event];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchPoint)) {
        [self touchesCancelled:touches withEvent:event];
        
        
        if ([delegate respondsToSelector:@selector(selectedBubbleItem:)]) {
            [delegate selectedBubbleItem:self];
        }
        
        
        
        return;
    }
    
    [self setSelected:NO animated:NO];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setSelected:NO animated:NO];
}

@end
