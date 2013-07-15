/*
 The MIT License (MIT)
 
 Copyright (c) 2013 Elvis Zhou<tonightelvis@gmail.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

@protocol HorizontalScrollViewDelegate;

@interface HorizontalScrollView : UIScrollView<UIScrollViewDelegate>

@property(nonatomic,assign)id<HorizontalScrollViewDelegate> horizontalDelegate;

-(id)initWithFrame:(CGRect)frame delegate:(id<HorizontalScrollViewDelegate>)delegate;

-(id)initWithFrame:(CGRect)frame delegate:(id<HorizontalScrollViewDelegate>)delegate beginAt:(NSUInteger)index;

-(UIView*)viewAtIndex:(NSInteger)index;
@end


@protocol HorizontalScrollViewDelegate <NSObject>

/**
 * @brief   是否需要加载index位置的View
 **/
-(BOOL)horizontalShouldloadViewAtIndex:(NSUInteger)index;

/**
 * @brief   获取位置index的view
 **/
-(UIView*)horizontalViewAtIndex:(NSUInteger)index;

@optional
/**
 * @brief   将要加载index位置的view
 **/
-(void)horizontalWillloadViewAtIndex:(NSUInteger)index;

/**
 * @brief   已经加载在index位置的view
 **/
-(void)horizontalDidloadViewAtIndex:(NSUInteger)index;

/**
 * @brief   获取需要 “更新”index位置的View
 */
-(UIView*)horizontalViewReloadView:(UIView**)view atIndex:(NSUInteger)index;
@end