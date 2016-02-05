//
//  ANGButton.h
//  08-无限滚动
//
//  Created by caoang on 16/2/3.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANGButton : UIControl

- (instancetype)initWithFrame:(CGRect)frame withImage:(NSString *)image withText:(NSString *)text;
- (void)setImagecornerRadius:(CGFloat)radius;
@end
