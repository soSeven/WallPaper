//
//  QXPageController.m
//  VideoStudio
//
//  Created by LiQi on 2020/3/11.
//  Copyright © 2020 优贝科技. All rights reserved.
//

#import "QXPageController.h"

static const NSInteger QXNotFound = -1;

@interface QXScrollView : UIScrollView<UIGestureRecognizerDelegate>

@end

@implementation QXScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //MARK: UITableViewCell 删除手势
    if ([NSStringFromClass(otherGestureRecognizer.view.class) isEqualToString:@"UITableViewWrapperView"]
        && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

@end

@interface QXPageController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger childControllersCount;

@property (nonatomic, strong) NSMutableDictionary *displayControllers;
@property (nonatomic, strong) NSMutableArray *childViewFrames;

@property (nonatomic, assign) BOOL isShouldNotScroll;
@property (nonatomic, assign) BOOL isHasInited;
@property (nonatomic, assign) BOOL isStartDragging;
@property (nonatomic, assign) CGFloat targetX;

@property (nonatomic, assign) NSInteger memoryWarningCount;
@property (nonatomic, strong) NSCache *memoryCache;
@property (nonatomic, assign) QXControllerCachePolicy cachePolicy;
@property (nonatomic, strong) NSMutableDictionary *backgroundCache;

@property (nonatomic, assign) QXControllerPreloadPolicy preloadPolicy;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger initializedIndex;

@property (nonatomic, strong) UIViewController *currentViewController;

@end

@implementation QXPageController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.childViewFrames = [NSMutableArray array];
    
    self.displayControllers = [NSMutableDictionary dictionary];
    
    self.memoryCache = [[NSCache alloc] init];
    self.backgroundCache = [NSMutableDictionary dictionary];
    
    self.preloadPolicy = QXControllerPreloadPolicyNear;
    self.cachePolicy = QXControllerCachePolicyNoLimit;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyAfterMemoryWarning) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyToHigh) object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupScrollView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!CGSizeEqualToSize(self.scrollView.bounds.size, self.view.bounds.size)) {
        if (!self.isHasInited) {
            self.childControllersCount = [self getChildViewControllerNumber];
            [self adjustScrollViewFrame];
            [self calculateChildControllerSize];
            [self addChildControllerWithIndex:self.selectedIndex];
            self.currentViewController = self.displayControllers[@(self.selectedIndex)];
            [self didEnterChildViewController:self.currentViewController index:self.selectedIndex];
            self.isHasInited = YES;
        }
        else {
            [self adjustScrollViewFrame];
            [self calculateChildControllerSize];
            [self.displayControllers enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIViewController * _Nonnull vc, BOOL * _Nonnull stop) {
                NSInteger index = key.integerValue;
                CGRect frame = [self.childViewFrames[index] CGRectValue];
                vc.view.frame = frame;
            }];
        }
    }
}

#pragma mark - Frame

- (void)calculateChildControllerSize
{
    [self.childViewFrames removeAllObjects];
    
    for (int i = 0; i < self.childControllersCount; i++) {
        CGRect frame = CGRectMake(i * self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        [self.childViewFrames addObject:[NSValue valueWithCGRect:frame]];
    }
}

- (void)adjustScrollViewFrame
{
    // While rotate at last page, set scroll frame will call `-scrollViewDidScroll:` delegate
    // It's not my expectation, so I use `_shouldNotScroll` to lock it.
    // Wait for a better solution.
    self.isShouldNotScroll = YES;
    CGFloat oldContentOffsetX = self.scrollView.contentOffset.x;
    CGFloat contentWidth = self.scrollView.contentSize.width;
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(self.childControllersCount * self.view.bounds.size.width, self.view.bounds.size.height);
    CGFloat xContentOffset = contentWidth == 0 ? self.selectedIndex * self.view.bounds.size.width: oldContentOffsetX / contentWidth * self.childControllersCount * self.view.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake(xContentOffset, 0)];
    self.isShouldNotScroll = NO;
}

#pragma mark - Notification

- (void)willResignActive:(NSNotification *)notification
{
    for (int i = 0; i < self.childControllersCount; i++) {
        id obj = [self.memoryCache objectForKey:@(i)];
        if (obj) {
            [self.backgroundCache setObject:obj forKey:@(i)];
        }
    }
}

- (void)willEnterForeground:(NSNotification *)notification
{
    for (NSNumber *key in self.backgroundCache.allKeys) {
        if (![self.memoryCache objectForKey:key]) {
            [self.memoryCache setObject:self.backgroundCache[key] forKey:key];
        }
    }
    [self.backgroundCache removeAllObjects];
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.memoryWarningCount++;
    self.cachePolicy = QXControllerCachePolicyLowMemory;
    // 取消正在增长的 cache 操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyAfterMemoryWarning) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyToHigh) object:nil];
    
    [self.memoryCache removeAllObjects];
    
    // 如果收到内存警告次数小于 3，一段时间后切换到模式 Balanced
    if (self.memoryWarningCount < 3) {
        [self performSelector:@selector(growCachePolicyAfterMemoryWarning) withObject:nil afterDelay:3.0 inModes:@[NSRunLoopCommonModes]];
    }
}

- (void)growCachePolicyAfterMemoryWarning
{
    self.cachePolicy = QXControllerCachePolicyBalanced;
    [self performSelector:@selector(growCachePolicyToHigh) withObject:nil afterDelay:2.0 inModes:@[NSRunLoopCommonModes]];
}

- (void)growCachePolicyToHigh
{
    self.cachePolicy = QXControllerCachePolicyHigh;
}

#pragma mark - Child Controllers

// add

- (void)addChildControllerWithIndex:(NSInteger)indx
{
    // 1.先从缓存中取
    UIViewController *childController = [self.memoryCache objectForKey:@(indx)];
    if (!childController) {
        childController = [self childViewControllerWithIndex:indx];
    }
    [self addChildViewController:childController index:indx];
}

- (void)addChildViewController:(UIViewController *)childController
                         index:(NSInteger)index
{
    [self addChildViewController:childController];
    childController.view.frame = [self.childViewFrames[index] CGRectValue];
    [childController didMoveToParentViewController:self];
    [self.scrollView addSubview:childController.view];
    [self willEnterChildViewController:childController index:index];
    self.displayControllers[@(index)] = childController;
}

// remove

- (void)removeChildController:(UIViewController *)childController
                     index:(NSInteger)index
{
    [childController.view removeFromSuperview];
    [childController willMoveToParentViewController:nil];
    [childController removeFromParentViewController];
    [self.displayControllers removeObjectForKey:@(index)];
    
    if (self.cachePolicy == QXControllerCachePolicyDisabled) {
        return;
    }
    //缓存
    if (![self.memoryCache objectForKey:@(index)]) {
        [self.memoryCache setObject:childController forKey:@(index)];
    }
}

- (void)layoutChildControllers
{
    CGFloat offsetX = self.scrollView.contentOffset.x;
    CGFloat width = self.view.bounds.size.width;
    NSInteger currentPageIndex = offsetX / width;
    NSInteger length = (NSInteger)self.preloadPolicy;
    NSInteger leftPageIndex = currentPageIndex - length - 1;
    NSInteger rightPageIndex = currentPageIndex + length + 1;
    
    for (NSInteger i = 0; i < self.childControllersCount; i++) {
        UIViewController *vc = self.displayControllers[@(i)];
        CGRect frame = [self.childViewFrames[i] CGRectValue];
        if (!vc) {
            if ([self isAppearInScrollViewWithFrame:frame]) {
                [self addChildControllerWithIndex:i];
            }
        }
        else if (i <= leftPageIndex || i >= rightPageIndex) {
            if (![self isAppearInScrollViewWithFrame:frame]) {
                [self removeChildController:vc index:i];
            }
        }
    }
}

// 是否在 ScrollView 中显示
- (BOOL)isAppearInScrollViewWithFrame:(CGRect)frame
{
    CGFloat x = frame.origin.x;
    CGFloat scrollViewWidth = self.scrollView.bounds.size.width;
    
    CGFloat offsetX = self.scrollView.contentOffset.x;
    
    if (CGRectGetMaxX(frame) > offsetX
        && (x - offsetX) < scrollViewWidth) {
        return YES;
    }
    return NO;
}

// delegate & dataSource

- (void)willEnterChildViewController:(UIViewController *)childController
                               index:(NSInteger)index
{
    self.selectedIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageController:willEnterChildViewController:index:)]) {
        [self.delegate pageController:self willEnterChildViewController:childController index:index];
    }
}

- (void)didEnterChildViewController:(UIViewController *)childController
                               index:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageController:didEnterChildViewController:index:)]) {
        [self.delegate pageController:self didEnterChildViewController:childController index:index];
    }
    
    // 当控制器创建时，调用延迟加载的代理方法
    if (self.initializedIndex == index &&
        [self.delegate respondsToSelector:@selector(pageController:lazyLoadChildViewController:index:)]) {
        [self.delegate pageController:self lazyLoadChildViewController:childController index:index];
        self.initializedIndex = QXNotFound;
    }
    
    // 预加载控制器
    if (self.preloadPolicy == QXControllerPreloadPolicyNear) {
        return;
    }
    
    NSInteger length = (NSInteger)self.preloadPolicy;
    NSInteger start = 0;
    NSInteger end = self.childControllersCount - 1;
    if (index > length) {
        start = index - length;
    }
    if (end > length + index) {
        end = length + index;
    }
    
    for (NSInteger i = start; i <= end; i++) {
        // 如果已存在，不需要预加载
        if (![self.memoryCache objectForKey:@(i)]
            && self.displayControllers[@(i)]) {
            UIViewController *childController = [self childViewControllerWithIndex:i];
            [self addChildViewController:childController index:i];
        }
    }
    
    self.selectedIndex = index;
}

- (UIViewController *)childViewControllerWithIndex:(NSInteger)index
{
    return [self.dataSource pageController:self childViewControllerAtIndex:index];
}

- (NSInteger)getChildViewControllerNumber
{
    return [self.dataSource numberOfChildViewControllerInPageController:self];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
                animated:(BOOL)animated
{
    _isStartDragging = NO;
    NSInteger lastSelectedIndex = self.selectedIndex;
    self.selectedIndex = selectedIndex;
    CGPoint target = CGPointMake(self.scrollView.bounds.size.width*selectedIndex, 0);
    [self.scrollView setContentOffset:target animated:animated];
    if (animated) {
        return;
    }
    // 由于不触发 -scrollViewDidScroll: 手动处理控制器
    UIViewController *currentViewController = self.displayControllers[@(lastSelectedIndex)];
    if (currentViewController) {
        [self removeChildController:currentViewController index:lastSelectedIndex];
    }
    [self layoutChildControllers];
    self.currentViewController = self.displayControllers[@(self.selectedIndex)];
    [self didEnterChildViewController:self.currentViewController index:self.selectedIndex];
}

#pragma mark - ScrollView

- (void)setupScrollView
{
    QXScrollView *scrollView = [[QXScrollView alloc] init];
    scrollView.scrollsToTop = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    if (!self.navigationController) return;
    for (UIGestureRecognizer *gestureRecognizer in scrollView.gestureRecognizers) {
        [gestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isShouldNotScroll) return;
    
    [self layoutChildControllers];
    if (self.isStartDragging) {
        CGFloat offSetX = scrollView.contentOffset.x;
        if (offSetX < 0) {
            offSetX = 0;
        }
        if (offSetX > scrollView.contentSize.width - scrollView.bounds.size.width) {
            offSetX = scrollView.contentSize.width - scrollView.bounds.size.width;
        }
        if (self.itemBar) {
            CGFloat rate = offSetX / scrollView.bounds.size.width;
            if ([self.itemBar respondsToSelector:@selector(pageController:slideToProgress:)]) {
                [self.itemBar pageController:self slideToProgress:rate];
            }
        }
//#warning ...
//        [self.menuView slideMenuAtProgress:rate];
    }
   
    // Fix scrollView.contentOffset.y -> (-20) unexpectedly.
    if (scrollView.contentOffset.y == 0) return;
    CGPoint contentOffset = scrollView.contentOffset;
    contentOffset.y = 0.0;
    scrollView.contentOffset = contentOffset;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isStartDragging = YES;
//#warning ...
    if (self.itemBar) {
        self.itemBar.userInteractionEnabled = NO;
    }
//    self.menuView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
// #warning ...
    if (self.itemBar) {
        self.itemBar.userInteractionEnabled = YES;
    }
//    self.menuView.userInteractionEnabled = YES;
    self.selectedIndex = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width);
    self.currentViewController = self.displayControllers[@(self.selectedIndex)];
    [self didEnterChildViewController:self.currentViewController index:self.selectedIndex];
//#warning ...
//    [self.menuView deselectedItemsIfNeeded];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.currentViewController = self.displayControllers[@(self.selectedIndex)];
    [self didEnterChildViewController:self.currentViewController index:self.selectedIndex];
//    #warning ...
    //    [self.menuView deselectedItemsIfNeeded];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
//        #warning ...
        if (self.itemBar) {
            self.itemBar.userInteractionEnabled = YES;
            CGFloat rate = self.targetX / scrollView.frame.size.width;
            if ([self.itemBar respondsToSelector:@selector(pageController:slideToProgress:)]) {
                [self.itemBar pageController:self slideToProgress:rate];
            }
        }
//        self.menuView.userInteractionEnabled = YES;
//        CGFloat rate = _targetX / _contentViewFrame.size.width;
//        [self.menuView slideMenuAtProgress:rate];
//        [self.menuView deselectedItemsIfNeeded];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    self.targetX = targetContentOffset->x;
}


@end
