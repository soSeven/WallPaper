//
//  QXPageController.h
//  VideoStudio
//
//  Created by LiQi on 2020/3/11.
//  Copyright © 2020 优贝科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QXItemLayoutMode) {
    QXItemLayoutModeScatter, // 默认的布局模式, item 会均匀分布在屏幕上，呈分散状
    QXItemLayoutModeLeft,    // Item 紧靠屏幕左侧
    QXItemLayoutModeRight,   // Item 紧靠屏幕右侧
    QXItemLayoutModeCenter,  // Item 紧挨且居中分布
};

typedef NS_ENUM(NSUInteger, QXControllerPreloadPolicy) {
    QXControllerPreloadPolicyNever = 0,
    QXControllerPreloadPolicyNext,
    QXControllerPreloadPolicyNear,
};

typedef NS_ENUM(NSInteger, QXControllerCachePolicy) {
    QXControllerCachePolicyDisabled   = -1,  // Disable Cache
    QXControllerCachePolicyNoLimit    = 0,   // No limit
    QXControllerCachePolicyLowMemory  = 1,   // Low Memory but may block when scroll
    QXControllerCachePolicyBalanced   = 3,   // Balanced ↑ and ↓
    QXControllerCachePolicyHigh       = 5    // High
};

@class QXPageController;

@protocol QXPageControllerItemBarDelegate <NSObject>

- (void)pageController:(QXPageController *)pageController
       slideToProgress:(CGFloat)progress;

@end

@protocol QXPageControllerDataSource <NSObject>

- (NSInteger)numberOfChildViewControllerInPageController:(QXPageController *)pageController;

- (__kindof UIViewController *)pageController:(QXPageController *)pageController
                   childViewControllerAtIndex:(NSInteger)index;

@end

@protocol QXPageControllerDelegate <NSObject>

- (void)pageController:(QXPageController *)pageController
willEnterChildViewController:(__kindof UIViewController *)childViewController
                 index:(NSInteger)index;

- (void)pageController:(QXPageController *)pageController
didEnterChildViewController:(__kindof UIViewController *)childViewController
                 index:(NSInteger)index;

- (void)pageController:(QXPageController *)pageController
lazyLoadChildViewController:(__kindof UIViewController *)childViewController
                 index:(NSInteger)index;

@end

@interface QXPageController : UIViewController

@property (nonatomic, weak) id<QXPageControllerDataSource> dataSource;
@property (nonatomic, weak) id<QXPageControllerDelegate> delegate;

@property (nonatomic, strong) UIView<QXPageControllerItemBarDelegate> *itemBar;

@property (nonatomic, assign, readonly) NSInteger selectedIndex;

- (void)setSelectedIndex:(NSInteger)selectedIndex
                animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
