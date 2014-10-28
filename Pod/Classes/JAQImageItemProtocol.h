//
//  JAQImageItemProtocol.h
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

#import <Foundation/Foundation.h>

@protocol JAQImageItemProtocol <NSObject>

@required

/**
 *  @return The string url that represents the final image.
 *  @warning You must not return `nil` from this method.
 */
- (NSString *)imageURL;

/**
 *  @return The string url attached to an image.
 *  @warning You must not return `nil` from this method.
 */
- (NSString *)contentURL;

/**
 *  @return The image loaded from imageURL.
 *  @warning You don't have to set the image.
 */
@property (nonatomic, strong) UIImage *image;

@end
