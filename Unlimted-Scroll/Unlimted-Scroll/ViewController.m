//
//  MJViewController.m
//  08-无限滚动
//
//  Created by apple on 14-5-31.
//  Copyright (c) 2014年 itcast. All rights reserved.
//
#import "ViewController.h"
#import "NewsCell.h"
#import "News.h"
#import "MJExtension.h"
#import "YYModel.h"
#import "ANGButton.h"
#import "PureLayout.h"

#define SCREENWEITH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) NSArray *newses;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,strong) UIPageControl *pageControl;
@property (nonatomic ,assign) CGRect frame;

@property (nonatomic ,strong) ANGButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 注册cell
    UINib *nib = [UINib nibWithNibName:@"NewsCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"news"];
    
    [self.view bringSubviewToFront:self.pageControl];
    [self.view addSubview:self.pageControl];
    self.pageControl.numberOfPages = self.newses.count;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    [self timerFire];
    
    self.btn = [[ANGButton alloc]initWithFrame:CGRectMake(0, 200, 60, 60) withImage:@"img_01" withText:@"hello!"];
    [self.btn setImagecornerRadius:20];
    [self.view addSubview:self.btn];
    
    ANGButton *leftImageBtn = [[ANGButton alloc]initWithFrame:CGRectMake(100, 200, 120, 30) withImage:@"img_02" withText:@"World!"];
    [leftImageBtn setImagecornerRadius:15];
    [leftImageBtn addTarget:self action:@selector(NSLogPrintf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftImageBtn];
}

- (void)NSLogPrintf
{
    NSLog(@"Btn ~~~~~~~~~~~~~");
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    _frame = CGRectMake(SCREENWEITH - 20 - 16*self.newses.count, self.collectionView.frame.origin.y + self.collectionView.frame.size.height - 20, 16*self.newses.count, 20);
    self.pageControl.frame = _frame;
    return self.newses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"news";
    NewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.news = self.newses[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.item = %ld",(long)indexPath.item);
}

/* 定义每个UICollectionView 的大小 */
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(self.collectionView.frame.size.width , self.collectionView.frame.size.height);
//}

/* 定义每个UICollectionView 的边缘 */
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 5, 0, 5);//上 左 下 右
//}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.collectionView]) {
        NSLog(@"scrollView");
    }
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self performSelector:@selector(timerFire) withObject:nil afterDelay:3];
}

- (void)timerFire
{
    [self.timer fire];
}

- (void)scrollPositionCell
{
    //1）获取当前正在展示的位置
    NSIndexPath *currentIndexPath=[[self.collectionView indexPathsForVisibleItems]lastObject];

    //2）计算出下一个需要展示的位置
    NSInteger nextItem=currentIndexPath.item+1;
    NSInteger nextSection=currentIndexPath.section;
    BOOL animation = YES;
    if (nextItem==self.newses.count)
    {
        nextItem=0;
        self.pageControl.currentPage = 0;
//            nextSection++;
        animation = NO;
    }
    self.pageControl.currentPage += 1;
    NSIndexPath *nextIndexPath=[NSIndexPath indexPathForItem:nextItem inSection:nextSection];

    //3）通过动画滚动到下一个位置
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:animation];

}

- (NSArray *)newses
{
    if (!_newses) {
        
        //MJExtension 解析
        //        self.newses = [News objectArrayWithFilename:@"newses.plist"];
        
        //YYModel 解析
        NSString *file = [[NSBundle mainBundle] pathForResource:@"newses.plist" ofType:nil];
        NSArray *keyValuesArray = [NSArray arrayWithContentsOfFile:file];
        NSMutableArray *modelArray = [NSMutableArray array];
        for (NSDictionary *keyValues in keyValuesArray) {
            if (![keyValues isKindOfClass:[NSDictionary class]]) continue;
            
            News *model = [News yy_modelWithJSON:keyValues];
            [modelArray addObject:model];
        }
        self.newses = modelArray;
        
    }
    return _newses;
}

#pragma mark getter
- (NSTimer *)timer
{
    if (!_timer) {
        self.timer = [[NSTimer alloc]initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:3] interval:3 target:self selector:@selector(scrollPositionCell) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.collectionView.frame.size.height + self.collectionView.frame.origin.y - 20, SCREENWEITH, 15)];
        self.pageControl.currentPage = 0;
    }
    return _pageControl;
}

@end
