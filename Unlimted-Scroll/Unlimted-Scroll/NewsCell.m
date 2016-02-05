//
//  MJNewsCell.m
//  08-无限滚动
//
//  Created by apple on 14-5-31.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NewsCell.h"
#import "News.h"

@interface NewsCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation NewsCell
- (void)setNews:(News *)news
{
    _news = news;
    
    self.iconView.image = [UIImage imageNamed:news.icon];
//    self.titleLabel.text = news.title;
    self.titleLabel.text = [NSString stringWithFormat:@"  %@", news.title];
}

@end
