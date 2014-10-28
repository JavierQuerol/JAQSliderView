//
//  Item.h
//  JAQSliderView
//
//  Created by Javier Querol on 28/10/14.
//  Copyright (c) 2014 Javier Querol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JAQImageItemProtocol.h"

@interface Item : NSObject <JAQImageItemProtocol>

@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *contentURL;
@property (nonatomic, strong) UIImage *image;

+ (Item *)fakeItemWithImageURL:(NSString *)imageURL andContent:(NSString *)contentURL;

@end
