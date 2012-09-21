//
//  ViewController.m
//  PageView
//
//  Created by jesse on 12-9-21.
//  Copyright (c) 2012年 Jesse. All rights reserved.
//

#import "ViewController.h"
#import "ScrollPageView.h"


@interface ViewController () <ScrollPageViewDatasource, ScrollPageViewDelegate>

@property (nonatomic, retain) ScrollPageView *scrollPageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.scrollPageView];
    [self.scrollPageView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (ScrollPageView *)scrollPageView
{
    if (_scrollPageView == nil)
    {
        _scrollPageView = [[ScrollPageView alloc] initWithFrame:self.view.bounds];
        _scrollPageView.contentInsets = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
        _scrollPageView.delegate = self;
        _scrollPageView.datasource = self;
    }
    
    return _scrollPageView;
}


#pragma mark - ScrollPageView Datasource

- (UIView *)scrollPageView:(ScrollPageView *)scrollPageView viewsForPage:(NSInteger)page
{
    UIView *customCellView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds) - 40.0f, CGRectGetHeight(self.view.bounds))];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 100.0f, CGRectGetWidth(customCellView.bounds), 20.0f)];
    label.text = [NSString stringWithFormat:@"page %d", page];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [customCellView addSubview:label];
    [label release];
    
    switch (page) {
        case 0:
            customCellView.backgroundColor = [UIColor redColor];
            break;
        case 1:
            customCellView.backgroundColor = [UIColor greenColor];
            break;
        case 2:
            customCellView.backgroundColor = [UIColor yellowColor];
            break;
        case 3:
            customCellView.backgroundColor = [UIColor blueColor];
            break;
        case 4:
            customCellView.backgroundColor = [UIColor orangeColor];
            break;
        default:
            break;
    }
    
    return [customCellView autorelease];
}

- (NSInteger)numberOfPagesForScrollPageView:(ScrollPageView *)scrollPageView
{
    return 5;
}


#pragma mark - ScrollPageView Delegate

- (void)scrollPageView:(ScrollPageView *)scrollPageView PageChanged:(NSInteger)page
{
    //TODO
    NSLog(@"page changed %d", page);
}

- (void)scrollPageView:(ScrollPageView *)scrollPageView didScroll:(UIScrollView *)scrollView
{
    //TODO
//    NSLog(@"scroll did scroll");
}

@end
