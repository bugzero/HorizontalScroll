//
//  ViewController.m
//  HorizontalScroll
//
//  Created by kongkong on 13-7-15.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "ViewController.h"
#import "HorizontalScrollView.h"
#import "UIView+EZ.h"

@interface ViewController ()<HorizontalScrollViewDelegate>

@end

static NSArray* colorArry = nil;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    
    colorArry = [NSArray arrayWithObjects:[UIColor greenColor],[UIColor yellowColor],[UIColor lightGrayColor],nil];
    
    srandom(time(NULL));
    
    HorizontalScrollView* scrollView = [[HorizontalScrollView alloc]initWithFrame:self.view.bounds delegate:self];
    
    [self.view addSubview:scrollView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark
#pragma -mark HorizontalScrollViewDelegate

-(UIView*)horizontalViewAtIndex:(NSUInteger)index{
    
    UIView* view = [[UIView alloc]init];
    
    if (index < colorArry.count)
        view.backgroundColor = colorArry[index];
    else
        view.backgroundColor = [UIColor colorWithRed:0.0f green:(rand()%255)/255.0 blue:(rand()%255)/255.0 alpha:(rand()%255)/255.0];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.width, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:45];
    label.text = [NSString stringWithFormat:@"%d",index];
    
    [view addSubview:label];
    
    
    return view;
}

-(UIView *)horizontalViewReloadView:(UIView *__autoreleasing *)view atIndex:(NSUInteger)index{
    
    return nil;
}

-(BOOL)horizontalShouldloadViewAtIndex:(NSUInteger)index{
    if (index < 3) {
        return YES;
    }
    return NO;
}


@end
