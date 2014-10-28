//
//  JAQSliderView.m
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

#import "JAQSliderView.h"
#import "JAQImageItemProtocol.h"
#import <SDWebImage/SDWebImageManager.h>

#define enlargeRatio 1.1
#define imageBufer 3

@interface JAQSliderView ()
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, assign) CGFloat showImageDuration;
@property (nonatomic, assign) BOOL shouldLoop;
@property (nonatomic, assign) BOOL isLandscape;
@end


@implementation JAQSliderView

#pragma mark - Initialization

- (id)init {
	self = [super init];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)awakeFromNib {
	[self setup];
}

- (void)setup {
	self.backgroundColor = [UIColor clearColor];
	self.layer.masksToBounds = YES;
	self.userInteractionEnabled = YES;
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedItem:)];
	[tap setNumberOfTapsRequired:1];
	[self addGestureRecognizer:tap];
}

- (void)animateWithImageItems:(NSArray *)items transitionDuration:(float)duration initialDelay:(float)delay loop:(BOOL)shouldLoop isLandscape:(BOOL)isLandscape {
	[self startAnimationsWithData:items transitionDuration:duration initialDelay:delay loop:shouldLoop isLandscape:isLandscape];
}

- (void)startAnimationsWithData:(NSArray *)data transitionDuration:(float)duration initialDelay:(float)delay loop:(BOOL)shouldLoop isLandscape:(BOOL)isLandscape {
	_itemsArray	        = [data mutableCopy];
	_showImageDuration  = duration;
	_shouldLoop         = shouldLoop;
	_isLandscape        = isLandscape;
	
	_currentItemIndex = -1;
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self nextImage];
	});
}


#pragma mark - Animation control

- (void)stopAnimation {
	[self.layer removeAllAnimations];
}

- (void)addItem:(NSObject <JAQSliderDelegate> *)item {
	[_itemsArray addObject:item];
}

#pragma mark - Image management

- (NSArray *)items {
	return _itemsArray;
}

- (void)currentItem:(void (^)(NSObject <JAQImageItemProtocol> *item))itemBlock {
	NSObject <JAQImageItemProtocol> *currentItem = [_itemsArray count] > 0 ? _itemsArray[MIN([_itemsArray count] - 1, MAX(self.currentItemIndex, 0))] : nil;
	if (currentItem.image) {
		itemBlock(currentItem);
	} else {
		[[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:currentItem.imageURL]
														options:SDWebImageCacheMemoryOnly
													   progress:nil
													  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
														  if (error) {
															  NSLog(@"error downloading image: %@",imageURL.description);
															  itemBlock(nil);
														  } else {
															  currentItem.image = image;
															  itemBlock(currentItem);
														  }
													  }];
	}
}

- (void)nextImage {
	_currentItemIndex++;
	[self currentItem:^(NSObject <JAQImageItemProtocol> *item) {
		if (item) {
			float originX       = -1;
			float originY       = -1;
			float zoomInX       = -1;
			float zoomInY       = -1;
			float moveX         = -1;
			float moveY         = -1;
			
			float frameWidth    = _isLandscape ? self.bounds.size.width: self.bounds.size.height;
			float frameHeight   = _isLandscape ? self.bounds.size.height: self.bounds.size.width;
			
			float resizeRatio = [self getResizeRatioFromImage:item.image width:frameWidth height:frameHeight];
			float optimusWidth  = (item.image.size.width * resizeRatio) * enlargeRatio;
			float optimusHeight = (item.image.size.height * resizeRatio) * enlargeRatio;
			
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, optimusWidth, optimusHeight)];
			imageView.backgroundColor = [UIColor blackColor];
			
			// Calcule the maximum move allowed.
			float maxMoveX = optimusWidth - frameWidth;
			float maxMoveY = optimusHeight - frameHeight;
			
			float rotation = (arc4random() % 9) / 100;
			int moveType = arc4random() % 4;
			
			switch (moveType) {
				case 0:
					originX = 0;
					originY = 0;
					zoomInX = 1.25;
					zoomInY = 1.25;
					moveX   = -maxMoveX;
					moveY   = -maxMoveY;
					break;
					
				case 1:
					originX = 0;
					originY = frameHeight - optimusHeight;
					zoomInX = 1.10;
					zoomInY = 1.10;
					moveX   = -maxMoveX;
					moveY   = maxMoveY;
					break;
					
				case 2:
					originX = frameWidth - optimusWidth;
					originY = 0;
					zoomInX = 1.30;
					zoomInY = 1.30;
					moveX   = maxMoveX;
					moveY   = -maxMoveY;
					break;
					
				case 3:
					originX = frameWidth - optimusWidth;
					originY = frameHeight - optimusHeight;
					zoomInX = 1.20;
					zoomInY = 1.20;
					moveX   = maxMoveX;
					moveY   = maxMoveY;
					break;
					
				default:
					originX = 0;
					originY = 0;
					zoomInX = 1;
					zoomInY = 1;
					moveX   = -maxMoveX;
					moveY   = -maxMoveY;
					break;
			}
			
			CALayer *picLayer    = [CALayer layer];
			picLayer.contents    = (id)item.image.CGImage;
			picLayer.anchorPoint = CGPointMake(0, 0);
			picLayer.bounds      = CGRectMake(0, 0, optimusWidth, optimusHeight);
			picLayer.position    = CGPointMake(originX, originY);
			
			[imageView.layer addSublayer:picLayer];
			
			CATransition *animation = [CATransition animation];
			[animation setDuration:1];
			[animation setType:kCATransitionFade];
			[[self layer] addAnimation:animation forKey:nil];
			
			// Remove the previous view
			if ([[self subviews] count] > 0) {
				UIView *oldImageView = [[self subviews] objectAtIndex:0];
				[oldImageView removeFromSuperview];
				oldImageView = nil;
			}
			
			[self addSubview:imageView];
			
			// Generates the animation
			[UIView animateWithDuration:_showImageDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				CGAffineTransform rotate    = CGAffineTransformMakeRotation(rotation);
				CGAffineTransform moveRight = CGAffineTransformMakeTranslation(moveX, moveY);
				CGAffineTransform combo1    = CGAffineTransformConcat(rotate, moveRight);
				CGAffineTransform zoomIn    = CGAffineTransformMakeScale(zoomInX, zoomInY);
				CGAffineTransform transform = CGAffineTransformConcat(zoomIn, combo1);
				imageView.transform = transform;
			} completion:^(BOOL finished) {
				if (finished) {
					[self nextImage];
				}
			}];
			
			[self notifyDelegate];
			
			if (_currentItemIndex == _itemsArray.count - 1) {
				if (_shouldLoop) {
					_currentItemIndex = -1;
				}
			}
		}
	}];
}

- (float)getResizeRatioFromImage:(UIImage *)image width:(float)frameWidth height:(float)frameHeight {
	float resizeRatio   = -1;
	float widthDiff     = -1;
	float heightDiff    = -1;
	
	if (image.size.width > frameWidth) {
		widthDiff = image.size.width - frameWidth;
		if (image.size.height > frameHeight) {
			heightDiff = image.size.height - frameHeight;
			if (widthDiff > heightDiff)	resizeRatio = frameHeight / image.size.height;
			else resizeRatio = frameWidth / image.size.width;
		} else {
			heightDiff = frameHeight - image.size.height;
			if (widthDiff > heightDiff)	resizeRatio = frameWidth / image.size.width;
			else resizeRatio = self.bounds.size.height / image.size.height;
		}
	} else {
		widthDiff = frameWidth - image.size.width;
		if (image.size.height > frameHeight) {
			heightDiff = image.size.height - frameHeight;
			if (widthDiff > heightDiff) resizeRatio = image.size.height / frameHeight;
			else resizeRatio = frameWidth / image.size.width;
		} else {
			heightDiff = frameHeight - image.size.height;
			if (widthDiff > heightDiff)	resizeRatio = frameWidth / image.size.width;
			else resizeRatio = frameHeight / image.size.height;
		}
	}
	
	return resizeRatio;
}

- (void)tappedItem:(id)sender {
	if ([_delegate respondsToSelector:@selector(kenBurns:didTapItem:)]) {
		[self currentItem:^(NSObject <JAQImageItemProtocol> *item) {
			if (item) {
				[_delegate kenBurns:self didTapItem:item];
			}
		}];
	}
}

- (void)notifyDelegate {
	if([_delegate respondsToSelector:@selector(kenBurns:didShowItem:atIndex:)]) {
		[self currentItem:^(NSObject <JAQImageItemProtocol> *item) {
			if (item) {
				[_delegate kenBurns:self didShowItem:item atIndex:_currentItemIndex];
			}
		}];
	}
	
	if (_currentItemIndex == ([_itemsArray count] - 1) && !_shouldLoop && [_delegate respondsToSelector:@selector(kenBurns:didFinishAllItems:)]) {
		[_delegate kenBurns:self didFinishAllItems:[_itemsArray copy]];
	}
}

@end
