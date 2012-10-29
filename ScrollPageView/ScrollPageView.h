//
//  ScrollPageView.h
//  PageScrollView
//
//  Created by jesse on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollPageViewDatasource;
@protocol ScrollPageViewDelegate;
@class ScrollView;

@interface ScrollPageView : UIView <UIScrollViewDelegate>
{
    ScrollView      *_scrollView;
    NSMutableArray  *_pages;
    NSInteger        _currentPage;
    NSInteger        _rCurrentPage;
}

@property (assign, nonatomic) id<ScrollPageViewDatasource> datasource;
@property (assign, nonatomic) id<ScrollPageViewDelegate> delegate;
@property (nonatomic) UIEdgeInsets contentInsets;
@property (assign, nonatomic) BOOL scrollEnabled;

- (void)reloadData;
- (void)scrollToPage:(int)page;
- (CGFloat)contentOffsetRatio;
- (void)updateNextPage;
- (NSInteger)currentPage;

@end


#pragma mark ScrollPageViewDatasource

@protocol ScrollPageViewDatasource <NSObject>

- (UIView *)scrollPageView:(ScrollPageView *)scrollPageView viewsForPage:(NSInteger)page;
- (NSInteger)numberOfPagesForScrollPageView:(ScrollPageView *)scrollPageView ;

@end

@protocol ScrollPageViewDelegate <NSObject>

@optional

- (void)scrollPageView:(ScrollPageView *)scrollPageView PageChanged:(NSInteger)page;
- (void)scrollPageView:(ScrollPageView *)scrollPageView didScroll:(UIScrollView *)scrollView;

@end
