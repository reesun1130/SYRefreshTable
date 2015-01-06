/**
 * This file is part of the SYRefreshTable package.
 * (c) Ree Sun <ree.sun.cn@hotmail.com || 743523983@qq.com>
 *
 * For more information, please view SYRefreshTable (https://github.com/reesun1130/SYRefreshTable)
 */

/**
 *
 *  SEE SYRefreshTable (https://github.com/reesun1130/SYRefreshTable) for instructions.
 *
 *  USE SYRefreshTable LIKE:
 *
 *  @interface ViewController : SYTableViewController
 *
 *  OVERRIDE refresh、loadMore、scrollViewDidScroll
 *
 */

//设备宽/高/坐标
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#define KDeviceFrame [UIScreen mainScreen].bounds

//只在debug模式下才打印日志
//release后不打印日志
#ifndef SYLog
#if DEBUG
#define SYLog(xxx, ...) NSLog((@"%s [%d行]: " xxx), __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define SYLog(xxx, ...)
#endif
#endif

#import <UIKit/UIKit.h>

@interface SYTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
@protected
    BOOL isRefreshing;//正在刷新
    BOOL isLoadingMore;//正在加载
    BOOL isDragging;//正在拖动
    BOOL willLoadMore;//将要加载
    BOOL willRefresh;//将要刷新

@private
    NSDate *refreshDate;//刷新时间
    NSDateFormatter *dateFormatter;//格式装换
}

/**
 *  用于头部刷新的view 默认使用STableHeaderView.h
 */
@property (nonatomic, strong) UIView *headerView;

/**
 *  用于底部加载更多的view 默认使用STableFooterView.h
 */
@property (nonatomic, strong) UIView *footerView;

/**
 *  tableview 可以为纯列表或者是分组的列表
 *  UITableViewStyleGrouped|UITableViewStylePlain
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 *  用于存放数据源
 */
@property (nonatomic, strong) NSMutableArray *itemArray;

/**
 *  分页加载使用到 页数：1-max
 */
@property (nonatomic) NSInteger pageCount;

/**
 *  是否可以加载更多
 */
@property (nonatomic) BOOL canLoadMore;

/**
 *  是否可以刷新
 */
@property (nonatomic) BOOL canRefresh;


#pragma mark - 
#pragma mark 下拉刷新

/**
 *  Override该方法实现刷新动作，首先要实现[super refresh]判断是否可以刷新
 *
 *  @return 是否可以刷新
 */
- (BOOL)refresh;

/**
 *  刷新结束
 */
- (void)refreshCompleted;


#pragma mark - 
#pragma mark 上拉加载更多

/**
 *  Override该方法实现加载更多动作，首先要实现[super loadMore]判断是否可以加载更多
 *
 *  @return 是否可以加载更多
 */
- (BOOL)loadMore;

/**
 *  加载结束
 */
- (void)loadMoreCompleted;


#pragma mark - 
#pragma mark 刷新加载完毕、释放view

- (void)makeAllLoadingCompleted;
- (void)releaseViewComponents;

@end
