//
//  ScrollPageView.m
//  PageScrollView
//
//  Created by jesse on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScrollPageView.h"

#define kBufferSize 3

@interface ScrollPageView ()

@property (readonly, nonatomic) NSMutableArray *pages;

@end

@implementation ScrollPageView

@synthesize datasource          = _datasource;
@synthesize delegate            = _delegate;
@synthesize contentInsets       = _contentInsets;
@synthesize pages               = _pages;

- (void)dealloc
{
    [_pages release];
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_scrollView];
        [_scrollView release];
        
    }
    return self;
}


- (void)pageChanged:(NSInteger)page
{
    if (_currentPage == page)
        return;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollPageView:PageChanged:)])
    {
        [self.delegate scrollPageView:self PageChanged:page];
    }
    
    if (page < _currentPage)
    {
        if (page < 0)
            return;
        
        //remove buffer last view
        if (page < [self.datasource numberOfPagesForScrollPageView:self] - 2)
        {
            UIView *nextPageView = [self.pages lastObject];
            
            //NSLog(@"deleg a view %d", nextPageView.tag);
            
            [nextPageView removeFromSuperview];
            [self.pages removeObject:nextPageView];
        }
        
        //load pre page
        if (page > 0)
        {
            UIView *prePageView  = [self.datasource scrollPageView:self viewsForPage:page - 1];
            prePageView.tag = page - 1;
            CGRect nFrame = prePageView.frame;
            nFrame.origin.x = _scrollView.bounds.size.width * (page - 1);
            nFrame.origin.y = 0.0f;
            prePageView.frame = nFrame;
            
            [_scrollView addSubview:prePageView];
            [self.pages insertObject:prePageView atIndex:0];
            //NSLog(@"add a view %d", prePageView.tag);
        }
        
    }
    else
    {
        if (page > [self.datasource numberOfPagesForScrollPageView:self] - 1)
            return;

//        _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * [self.datasource numberOfPagesForScrollPageView:self], self.bounds.size.height);
        
        //remove buffer front view
        if (page > 1)
        {
            UIView *prePageView = [self.pages objectAtIndex:0];
            
            //NSLog(@"deleg a view %d", prePageView.tag);
            
            [prePageView removeFromSuperview];
            [self.pages removeObject:prePageView];
            
        }
        
        //load next page
        if (page + 1 < [self.datasource numberOfPagesForScrollPageView:self])
        {
            UIView *nextPageView = [self.datasource scrollPageView:self viewsForPage:page + 1];
            nextPageView.tag = page + 1;
            CGRect nFrame = nextPageView.frame;
            nFrame.origin.x = _scrollView.bounds.size.width * (page + 1);
            nFrame.origin.y = 0.0f;
            nextPageView.frame = nFrame;
            
            [_scrollView addSubview:nextPageView];
            [self.pages addObject:nextPageView];
            
            //NSLog(@"add a view %d", nextPageView.tag);
        }
    }
    
    _currentPage = page;    
}


- (UIView *)loadPageFromDatasource:(NSInteger)page
{
    if (self.datasource)
    {
        return [self.datasource scrollPageView:self viewsForPage:page];
    }
    else 
        return nil;
}


#pragma mark - public method

- (void)reloadData
{
    _currentPage = 0;
    _rCurrentPage = 0;
    _scrollView.frame = CGRectMake(_contentInsets.left, _contentInsets.top, 
                                   self.bounds.size.width - _contentInsets.left - _contentInsets.right,
                                   self.bounds.size.height - _contentInsets.top - _contentInsets.bottom);
    
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.pages removeAllObjects];
    
    for (int i = 0; i < [self.datasource numberOfPagesForScrollPageView:self] && i < 2; i++)
    {
        //change frame
        UIView *pageView = [self.datasource scrollPageView:self viewsForPage:i];
        pageView.tag = i;
        CGRect nFrame = pageView.frame;
        nFrame.origin.x = _scrollView.bounds.size.width * i;
        nFrame.origin.y = 0;
        pageView.frame = nFrame;
        
        [_scrollView addSubview:pageView];
        [self.pages addObject:pageView];
        
        //NSLog(@"add a view %d", pageView.tag);
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * [self.datasource numberOfPagesForScrollPageView:self], self.bounds.size.height);
}


- (void)scrollToPage:(int)page
{
    CGFloat offsetX = _scrollView.bounds.size.width * page;
    [_scrollView scrollRectToVisible:CGRectMake(offsetX, 0.0f, _scrollView.bounds.size.width, _scrollView.bounds.size.height) animated:YES];
}


- (CGFloat)contentOffsetRatio
{
    return _scrollView.contentOffset.x / _scrollView.contentSize.width;
}


- (void)updateNextPage
{
    if (self.pages.count <= 2)
    {
        //load next page
        if (_currentPage + 1 < [self.datasource numberOfPagesForScrollPageView:self])
        {
            UIView *nextPageView = [self.datasource scrollPageView:self viewsForPage:_currentPage + 1];
            nextPageView.tag = _currentPage + 1;
            CGRect nFrame = nextPageView.frame;
            nFrame.origin.x = _scrollView.bounds.size.width * (_currentPage + 1);
            nFrame.origin.y = 0.0f;
            nextPageView.frame = nFrame;
            
            [_scrollView addSubview:nextPageView];
            [self.pages addObject:nextPageView];
            
            //NSLog(@"add a view %d", nextPageView.tag);
        }
        
        _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * [self.datasource numberOfPagesForScrollPageView:self], self.bounds.size.height);
    }
}

- (NSInteger)currentPage
{
    return _currentPage;
}


#pragma mark - getter & setter

- (NSMutableArray *)pages
{
    if (_pages == nil)
    {
        _pages = [[NSMutableArray alloc] initWithCapacity:3];
    }
    
    return _pages;
}

- (BOOL)scrollEnabled
{
    return _scrollView.scrollEnabled;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollView.scrollEnabled = scrollEnabled;
}


#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollPageView:didScroll:)])
    {
        [self.delegate scrollPageView:self didScroll:scrollView];
    }
    
    CGFloat center = _rCurrentPage * scrollView.bounds.size.width;
    if (scrollView.contentOffset.x > center + (scrollView.bounds.size.width - _contentInsets.right))
    {
        //NSLog(@"R");
        [self pageChanged: (int)(scrollView.contentOffset.x/scrollView.bounds.size.width + 0.5)];
    }    
    else if (scrollView.contentOffset.x < center - (scrollView.bounds.size.width - _contentInsets.left))
    {
        //NSLog(@"L");
        [self pageChanged:(int)(scrollView.contentOffset.x/scrollView.bounds.size.width + 0.5)];
    }
    else 
    {
        //NSLog(@"O");
        [self pageChanged:_rCurrentPage];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _rCurrentPage = _currentPage;
}


#pragma mark - 

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView  *child = nil;
    if ((child = [super hitTest:point withEvent:event]) == self)
        return _scrollView;     
    
    return child;
}

@end
