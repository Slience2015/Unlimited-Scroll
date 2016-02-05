//
//  ANGButton.m
//  08-无限滚动
//
//  Created by caoang on 16/2/3.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "ANGButton.h"

@interface ANGButton()

@property(nonatomic ,strong) UIImageView *imageView;
@property(nonatomic ,strong) UILabel *textLabel;

@end

@implementation ANGButton

- (instancetype)initWithFrame:(CGRect)frame withImage:(NSString *)image withText:(NSString *)text
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = frame;
        
        [self setImageWith:image setTextWith:text];
    }
    return self;
}

- (void)setImageWith:(NSString *)image setTextWith:(NSString *)text
{
    if (self.frame.size.height == self.frame.size.width)
    {
        //frame的宽高相等 设置图片的宽高为frame的2/3 文本的宽为frame的宽，高为frame的1/3
        CGFloat imageWith = self.frame.size.height*2/3;
        CGFloat imageX = (self.frame.size.width - imageWith)/2;
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, 0, imageWith, imageWith)];
        [self addSubview:_imageView];
        [_imageView setImage:[UIImage imageNamed:image]];
        
        CGFloat textHeight = self.frame.size.height*1/3;
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageView.frame.size.height, self.frame.size.width, textHeight)];
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
        _textLabel.text = text;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor blackColor];
    }
    else
    {
       //frame的宽大于高 设置图片的宽高为frame的高 文本的高为frame的高，宽为frame的宽减去图片的宽
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0     , 0, self.frame.size.height, self.frame.size.height)];
        [self addSubview:_imageView];
        [_imageView setImage:[UIImage imageNamed:image]];
        
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(_imageView.frame.size.width , 0, self.frame.size.width - _imageView.frame.size.width, self.frame.size.height)];
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
        _textLabel.text = text;
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.textColor = [UIColor blackColor];
    }
}

- (void)setImagecornerRadius:(CGFloat)radius
{
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = radius;
}

@end
