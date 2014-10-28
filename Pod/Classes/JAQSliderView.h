//
//  JAQSliderView.h
//  JAQSliderView
//
//  Created by Javier Querol on 28/10/14.
//  Copyright (c) 2014 Javier Querol. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this
//  software and associated documentation files (the "Software"), to deal in the Software
//  without restriction, including without limitation the rights to use, copy, modify, merge,
//  publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
//  to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies
//  or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
//  PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
//  FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

@import QuartzCore;

#import "JAQImageItemProtocol.h"

@class JAQSliderView;

@protocol JAQSliderDelegate <NSObject>

@optional
- (void)kenBurns:(JAQSliderView *)kenBurns didShowItem:(NSObject <JAQImageItemProtocol> *)item atIndex:(NSUInteger)index;
- (void)kenBurns:(JAQSliderView *)kenBurns didFinishAllItems:(NSArray *)items;
- (void)kenBurns:(JAQSliderView *)kenBurns didTapItem:(NSObject <JAQImageItemProtocol> *)item;
@end

@interface JAQSliderView : UIView

@property (nonatomic,weak) id<JAQSliderDelegate> delegate;
@property (nonatomic,assign,readonly) NSInteger currentItemIndex;

///----------------------------------
/// @name Initialization
///----------------------------------

/**
 Start the animation with a NSArray of NSObjects that conforms JAQImageItemProtocol.
 @param imageItems 	A NSArray of NSObjects that conforms JAQImageItemProcotol.
 @param time        The number of second of each image.
 @param isLoop      YES if you want to play the animation in loop.
 @param isLandscape YES if the view is in landscape mode.
 */
- (void)animateWithImageItems:(NSArray *)items
		   transitionDuration:(float)time
				 initialDelay:(float)delay
						 loop:(BOOL)isLoop
				  isLandscape:(BOOL)isLandscape;


///----------------------------------
/// @name Manage animation
///----------------------------------

/**
 Stop the current animation.
 */
- (void)stopAnimation;

/**
 Add an item to the current animation.
 @param item A NSObject that conforms JAQImageItemProcotol to add to the animation playback.
 */
- (void)addItem:(NSObject <JAQImageItemProtocol> *)item;


///----------------------------------
/// @name Animation getters
///----------------------------------

/**
 Returns the NSArray of current item on the animation.
 @return A NSArray with the items in the animation.
 */
- (NSArray *)items;

/**
 Return the current item on the animation.
 @param block A block that take a NSObject <JAQImageItemProcotol> as parameter.
 */
- (void)currentItem:(void (^)(NSObject <JAQImageItemProtocol> *item))itemBlock;

@end
