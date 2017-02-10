//
//  emsChatCell.m
//  Fishy
//
//  Created by developer on 11/03/15.
//  Copyright (c) 2015 Roman Bigun. All rights reserved.
//

#import "emsChatCell.h"
#import <QuartzCore/QuartzCore.h>
const CGFloat WidthOffset = 30.0f;
const CGFloat ImageSize = 50.0f;
@implementation emsChatCell

- (void)layoutSubviews
{
    [self updateFramesForAuthorType:self.authorType];
}

- (void)setAuthorType:(AuthorType)type
{
    _authorType = type;
    [self updateFramesForAuthorType:_authorType];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _bubbleView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _dateLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _arrowImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _statusImage= [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_dateLable];
        [self.contentView addSubview:_bubbleView];
        [self.contentView addSubview:_arrowImage];
        [self.contentView addSubview:_statusImage];
        self.dateLable.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:8];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
        self.textLabel.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:0.7];

    }
    
    return self;
}
- (void)updateFramesForAuthorType:(AuthorType)type
{
    CGSize size;
    CGSize sizeDate;
    CGFloat minInset = 0.0f;
  
    sizeDate = [self.dateLable.text sizeWithFont:self.dateLable.font constrainedToSize:CGSizeMake(self.frame.size.width - minInset - WidthOffset - ImageSize - 8.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    size = [self.textLabel.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:14] constrainedToSize:CGSizeMake(self.frame.size.width - minInset - WidthOffset - ImageSize -12.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    
    if(type == cellAuthorTypeSelf)
    {
        [self setImageForBubbleColor];
        
        self.bubbleView.frame = CGRectMake(self.frame.size.width - (size.width + WidthOffset)  - 3.0f, self.frame.size.height - (size.height + 33.0f) -8, size.width + WidthOffset, size.height + 24.0f);
               self.textLabel.frame = CGRectMake(self.frame.size.width - (size.width + WidthOffset - 10.0f) , self.frame.size.height - (size.height + 27.0f) -4, size.width + WidthOffset - 23.0f, size.height+10);
        self.dateLable.frame =  CGRectMake(self.frame.size.width - sizeDate.width  - 12 , self.frame.size.height -10 ,sizeDate.width,11);
        self.statusImage.frame =CGRectMake(self.frame.size.width - self.dateLable.frame.size.width- ImageSize - WidthOffset+4 , self.imageView.frame.origin.y +(self.imageView.frame.size.height)+2  ,7,7);

      
        self.arrowImage.image = [UIImage imageNamed:@"Bubble_greeen_part"];
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.bubbleView.transform = CGAffineTransformIdentity;
        
  
    }
    else
    {
        [self setImageForBubbleColorGray];
        self.bubbleView.frame = CGRectMake(ImageSize + 13.0f, self.frame.size.height - (size.height + 15.0f)-22, size.width + WidthOffset-10, size.height  + 20.0f);
        self.imageView.frame = CGRectMake(5.0, self.frame.size.height - ImageSize - 12.0f, ImageSize, ImageSize);
        self.textLabel.frame = CGRectMake(ImageSize + 8.0f + 16.0f, self.frame.size.height - (size.height + 15.0f) -13, size.width + WidthOffset - 23.0f, size.height+10);
        self.dateLable.frame =  CGRectMake(80,  self.bubbleView.frame.size.height+15 ,sizeDate.width,11);
        self.arrowImage.image = [UIImage imageNamed:@"Bubble_gray_part"];
     

        self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        self.bubbleView.transform = CGAffineTransformIdentity;
        self.bubbleView.transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
        
        
          }
    

    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: self.textLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.textLabel.text length])];
    self.textLabel.attributedText = attributedString ;
    
}
- (void)setImageForBubbleColorGray
{
    self.bubbleView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"Bubble_gray"]] resizableImageWithCapInsets:UIEdgeInsetsMake(11.0f, 15.0f, 16.0f, 18.0f)];
}

- (void)setImageForBubbleColor
{
    self.bubbleView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"Bubble_green"]] resizableImageWithCapInsets:UIEdgeInsetsMake(11.0f, 15.0f, 16.0f, 18.0f)];
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    
    while(tableView)
    {
        if([tableView isKindOfClass:[UITableView class]])
        {
            return (UITableView *)tableView;
        }
        
        tableView = tableView.superview;
    }
    
    return nil;
}
-(void)cornerIm:(UIImageView*)imageView{
    imageView .layer.cornerRadius =  imageView.bounds.size.width/2;
    UIColor *color = [UIColor colorWithRed:139/255.0 green:185/255.0 blue:172/255.0 alpha:1];
    [imageView.layer setBorderColor:color.CGColor];
    [imageView.layer setBorderWidth:1.0];
    imageView.layer.masksToBounds = YES;
}




@end


