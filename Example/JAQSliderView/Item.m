//
//  Item.m
//  JAQSliderView
//
//  Created by Javier Querol on 28/10/14.
//  Copyright (c) 2014 Javier Querol. All rights reserved.
//

#import "Item.h"

@implementation Item

+ (Item *)fakeItemWithImageURL:(NSString *)imageURL andContent:(NSString *)contentURL {
	Item *item = [Item new];
	item.contentURL = contentURL;
	item.imageURL = imageURL;
	return item;
}

@end
