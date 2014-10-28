//
//  JAQViewController.m
//  JAQSliderView
//
//  Created by Javier Querol on 10/28/2014.
//  Copyright (c) 2014 Javier Querol. All rights reserved.
//

#import "JAQViewController.h"
#import "Item.h"
#import "JAQSliderView.h"
#import "JAQImageItemProtocol.h"

@interface JAQViewController () <JAQSliderDelegate>
@property (nonatomic, weak) IBOutlet JAQSliderView *sliderView;
@end

@implementation JAQViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSArray *array = @[[Item fakeItemWithImageURL:@"http://www.mobilethemesworld.com/file/2012/09/1136-x-640-wallpaper.jpg"
									   andContent:@"http://google.com"],
					   [Item fakeItemWithImageURL:@"http://www.wallpaper-mobile.com/free_download/640_1136_wallpapers/11201321/B/B_projection_H3pfMcEO.jpg"
									   andContent:@"http://apple.com"],
					   [Item fakeItemWithImageURL:@"http://www.wallpaper-mobile.com/free_download/640_1136_wallpapers/11201321/B/B_iphoneglow_XspvwN2w.jpg"
									   andContent:@"http://amazon.com"],
					   [Item fakeItemWithImageURL:@"http://www.wallpaper-mobile.com/free_download/640_1136_wallpapers/11201321/B/B_colorfulum_e4OGGqkU.jpg"
									   andContent:@"http://twitter.com"],
					   [Item fakeItemWithImageURL:@"http://www.wallpaper-mobile.com/free_download/640_1136_wallpapers/11201321/B/B_iphoneglow_jhEXxZlq.jpg"
									   andContent:@"http://yahoo.com"]];
	
	self.sliderView.delegate = self;
	[self.sliderView animateWithImageItems:array transitionDuration:5 initialDelay:0 loop:YES isLandscape:YES];
}

- (void)kenBurns:(JAQSliderView *)kenBurns didFinishAllItems:(NSArray *)items {
	NSLog(@"All finished");
}

- (void)kenBurns:(JAQSliderView *)kenBurns didShowItem:(NSObject<JAQImageItemProtocol> *)item atIndex:(NSUInteger)index {
	NSLog(@"Showing another image");
}

- (void)kenBurns:(JAQSliderView *)kenBurns didTapItem:(NSObject<JAQImageItemProtocol> *)item {
	NSLog(@"Tapped item with imageURL: %@, here you can open a browser with the contentURL: %@",item.imageURL,item.contentURL);
}

@end

