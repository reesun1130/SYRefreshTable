//
//  ViewController.m
//  SYRefreshTable
//
//  Created by sunbb on 14-12-25.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import "ViewController.h"
#import "SYTableFooterView.h"
#import "SYTableHeaderView.h"

static NSString *cellID = @"cellID";

@interface ViewController ()
{
    NSLock *lockLoadData;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     *  设置头部和底部视图，可以选择设置，然后实现相应的方法
     */
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SYTableFooterView" owner:self options:nil];
    SYTableFooterView *footerView = (SYTableFooterView *)[nib objectAtIndex:0];
    self.footerView = footerView;
    //self.footerView.backgroundColor = [UIColor yellowColor];
    
    nib = [[NSBundle mainBundle] loadNibNamed:@"SYTableHeaderView" owner:self options:nil];
    SYTableHeaderView *headerView = (SYTableHeaderView *)[nib objectAtIndex:0];
    self.headerView = headerView;
   // self.headerView.backgroundColor = [UIColor redColor];
    
    self.pageCount = 1;
    
    lockLoadData = [[NSLock alloc] init];
    
    self.tableView.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
    [self loadItemData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  可以请求你的网络数据，demo为了方便只加载本地数据
 */
- (void)loadItemData
{
    if (self.pageCount == 1)
    {
        [self.itemArray removeAllObjects];
    }
    
    int count = (arc4random() % 10) + 1;
    
    for (int i = 0; i < count; i++)
    {
        [self.itemArray addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    
    if (count < 5)
    {
        self.canLoadMore = NO;
    }
    else
    {
        self.canLoadMore = YES;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self refreshCompleted];
        [self loadMoreCompleted];
        
        if (self.itemArray.count > 0)
        {
            [self.tableView reloadData];
        }
    });
}


////////// 只需实现这三个方法 即可实现下拉刷新，上拉加载更多
#pragma mark - 
#pragma mark Pull to Refresh

- (BOOL)refresh
{
    if (![super refresh])
        return NO;
    
    self.pageCount = 1;
    
    [lockLoadData lock];
    [self performSelector:@selector(loadItemData) withObject:nil afterDelay:0.01];
    [lockLoadData unlock];
    
    return YES;
}


#pragma mark -
#pragma mark Load More

- (BOOL)loadMore
{
    if (![super loadMore])
        return NO;
    
    self.pageCount ++;
    
    [lockLoadData lock];
    [self performSelector:@selector(loadItemData) withObject:nil afterDelay:0.01];
    [lockLoadData unlock];
    
    return YES;
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
}
////////// 只需实现这三个方法 即可实现下拉刷新，上拉加载更多


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //SYLog(@"=======%d",self.itemArray.count);
    return self.itemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if (self.itemArray && self.itemArray.count > 0)
    {
        if (indexPath.row >= self.itemArray.count) {
            return cell;
        }
        
        cell.textLabel.text = self.itemArray[indexPath.row];
    }
    
    return cell;
}


#pragma mark - 
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYLog(@"selected row==%ld",(long)indexPath.row);
}

@end
