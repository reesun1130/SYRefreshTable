# SYRefreshTable
简单易用的上拉加载、下拉刷新组件，可自定义头部和底部视图，可单独实现下拉刷新，上拉加载更多。

用法：(具体请查看DEMO)
  
  /**  SEE SYRefreshTable (https://github.com/reesun1130/SYRefreshTable) for instructions.  
    *  USE SYRefreshTable LIKE:  
    *  @interface ViewController : SYTableViewController  
    *  OVERRIDE refresh、loadMore、scrollViewDidScroll  
    */
    
////////// 只需实现这三个方法 即可实现下拉刷新，上拉加载更多
#Pull to Refresh

    *  - (BOOL)refresh
    *  {
    *     if (![super refresh])
    *        return NO;
          
          self.pageCount = 1;
          
          [lockLoadData lock];
          [self performSelector:@selector(loadItemData) withObject:nil afterDelay:0.01];
          [lockLoadData unlock];
          
          return YES;
       }

#Load More
    *  - (BOOL)loadMore
    *  {
    *      if (![super loadMore])
    *         return NO;
           
           self.pageCount ++;
  
           [lockLoadData lock];
           [self performSelector:@selector(loadItemData) withObject:nil afterDelay:0.01];
           [lockLoadData unlock];
  
           return YES;
       }

#UIScrollViewDelegate Method
    *  - (void)scrollViewDidScroll:(UIScrollView *)scrollView
       {
          [super scrollViewDidScroll:scrollView];
       }
////////// 只需实现这三个方法 即可实现下拉刷新，上拉加载更多
*/

