//
//  HorizontalScrollView.h
//  split
//
//  Created by kongkong on 13-6-25.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

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