//
//  HorizontalScrollView.m
//  split
//
//  Created by kongkong on 13-6-25.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "HorizontalScrollView.h"
#import "UIView+EZ.h"
#define kContentOffsetKey @"contentOffset"

@interface HorizontalScrollView(){
    NSInteger       _lastDidLoadIndex;  /// 当前index
    NSInteger       _lastShouldLoadPreIndex;
    NSInteger       _lastShouldLoadNextIndex;
}

@end

@implementation HorizontalScrollView

-(id)initWithFrame:(CGRect)frame delegate:(id<HorizontalScrollViewDelegate>)delegate{
    return [self initWithFrame:frame delegate:delegate beginAt:0];
}

- (id)initWithFrame:(CGRect)frame delegate:(id<HorizontalScrollViewDelegate>)delegate beginAt:(NSUInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        self.horizontalDelegate = delegate;
        self.showsHorizontalScrollIndicator = NO;
        
        self.showsVerticalScrollIndicator = NO;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.pagingEnabled = YES;
        
        _lastDidLoadIndex = index;
        
        _lastShouldLoadPreIndex = INT_MAX;
        
        _lastShouldLoadNextIndex = INT_MAX;
        
        self.contentSize = CGSizeMake(self.width*(index+1)+1,self.height);
        
        self.contentOffset = CGPointMake(self.width*index, 0);
        
        [self _viewAtIndex:index];
        
        self.delegate = self;
        
        [self addObserver:self
               forKeyPath:kContentOffsetKey
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    }
    return self;
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:kContentOffsetKey];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = self.contentOffset.x/self.width;
    
    
    if (0 == (((int)self.contentOffset.x)%((int)self.width))) {
        [self _didLoadViewAtIndex:index];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSInteger index = self.contentOffset.x/self.width;
    
    if (0 == (((int)self.contentOffset.x)%((int)self.width))) {
        [self _didLoadViewAtIndex:index];
    }
}

#pragma -mark KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:kContentOffsetKey]) {
        [self horizontalScroll];
    }
}


#pragma -mark custom action
-(void)horizontalScroll{
    NSInteger x = self.contentOffset.x;
    NSInteger width = self.width;
    NSInteger index = x/width;
    
    if (0 != (x%width)) {
        /// back
        if (_lastDidLoadIndex > index) {
            if ([self _shouldLoadViewAtindex:_lastDidLoadIndex-1] && _lastShouldLoadPreIndex != index) {
                _lastShouldLoadPreIndex = index;
                [self _willLoadViewAtIndex:_lastDidLoadIndex-1];
                [self _viewAtIndex:_lastDidLoadIndex-1];
            }
        }
        /// forward
        else{
            if ([self _shouldLoadViewAtindex:_lastDidLoadIndex+1] && _lastShouldLoadNextIndex != index) {
                _lastShouldLoadNextIndex = index;
                [self _willLoadViewAtIndex:_lastDidLoadIndex+1];
                [self _viewAtIndex:_lastDidLoadIndex+1];
            }
        }
    }
}

#pragma -mark add view

/**
 * @brief 添加View，当前view中不存在这个位置的view则添加，如果已经存在这个tag的view的话，则判断是否需要重新load
 **/
-(void)_viewAtIndex:(NSUInteger)index{
    
    UIView* view = [self viewWithTag:[self tagAtIndex:index]];
    /// 当前存在这个view,则判断是否需要重新加载
    if (view) {
        if ([self.horizontalDelegate respondsToSelector:@selector(horizontalViewReloadView:atIndex:)]) {
            UIView* newView = [self.horizontalDelegate horizontalViewReloadView:(view?&view:nil) atIndex:index];
            
            /// 更新的view存在，则位置的view remove
            if (newView) {
                [view removeFromSuperview];
                view = newView;
                
            }
        }
    }/// 重新添加view
    else if ([self.horizontalDelegate respondsToSelector:@selector(horizontalViewAtIndex:)]) {
        view = [self.horizontalDelegate horizontalViewAtIndex:index];
    }
    
    if (view) {
        view.tag = [self tagAtIndex:index];
        [view removeFromSuperview];
        [self addSubview:view];
        
        view.frame = self.bounds;
        view.left = index*self.width;
    }
    
}

#pragma -mark should load view
-(BOOL)_shouldLoadViewAtindex:(NSInteger)index{
    BOOL shouldLoad = NO;
    
    if ([self.horizontalDelegate respondsToSelector:@selector(horizontalShouldloadViewAtIndex:)]) {
        shouldLoad = [self.horizontalDelegate horizontalShouldloadViewAtIndex:index];
        if (shouldLoad) {
            if (self.contentSize.width < (index+1)*self.width){
                self.contentSize = CGSizeMake((index+1)*self.width,self.height);
            }
        }
    }
    return shouldLoad;
}

#pragma -mark will load view
-(void)_willLoadViewAtIndex:(NSInteger)index{
    if ([self.horizontalDelegate respondsToSelector:@selector(horizontalWillloadViewAtIndex:)]) {
        [self.horizontalDelegate horizontalWillloadViewAtIndex:index];
    }
}

#pragma -mark did load view
-(void)_didLoadViewAtIndex:(NSInteger)index{
    if (_lastDidLoadIndex == index) {
        return;
    }
    
    _lastDidLoadIndex = index;
    if ([self.horizontalDelegate respondsToSelector:@selector(horizontalDidloadViewAtIndex:)]) {
        [self.horizontalDelegate horizontalDidloadViewAtIndex:index];
    }
    _lastShouldLoadNextIndex = -1;
    _lastShouldLoadPreIndex = -1;
}


-(NSInteger)tagAtIndex:(NSInteger)index{
    return -(index+100);
}

-(UIView*)viewAtIndex:(NSInteger)index{
    if (index != _lastDidLoadIndex &&
        index != _lastShouldLoadPreIndex &&
        index != _lastShouldLoadNextIndex) {
        return nil;
    }
    
    return [self viewWithTag:[self tagAtIndex:index]];
}
@end
