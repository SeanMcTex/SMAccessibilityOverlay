//
//  SMAccessibilityOverlay.m
//  AccessibilityOverlay
//
//  Created by Sean McMains on 2/2/13.
//  Copyright (c) 2013 Sean McMains. All rights reserved.
//

#import "SMAccessibilityOverlay.h"

@interface SMAccessibilityOverlay ()
@property (nonatomic, strong) UIWindow *mainWindow;
@property (nonatomic, strong) UIWindow *overlayWindow;
@property (nonatomic, strong) NSMutableArray *viewsToProcess;
@end

@implementation SMAccessibilityOverlay

# pragma mark - Public Methods

-(void)show {
    [self showWithWindow:nil];
}

-(void)showWithWindow:(UIWindow *)window {
    
    self.mainWindow = window ? window : [[UIApplication sharedApplication] keyWindow];
    
    [self configureOverlayWindow];
    [self populateOverlayWindow];
    [self.overlayWindow makeKeyAndVisible];

}

# pragma mark - UI Event Handlers

-(void)didTapRootView {
    [self.mainWindow makeKeyAndVisible];
    [self.overlayWindow removeFromSuperview];
    self.overlayWindow = nil;
}

# pragma mark - Private Methods

-(void)configureOverlayWindow {
    self.overlayWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.overlayWindow.windowLevel = UIWindowLevelStatusBar;
	self.overlayWindow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
	self.overlayWindow.rootViewController = self;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                    action:@selector( didTapRootView )];
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void)populateOverlayWindow {
    self.viewsToProcess = [NSMutableArray array];
    [self.viewsToProcess addObject:self.mainWindow.rootViewController.view];
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    blueView.backgroundColor = [UIColor blueColor];
    [self.overlayWindow addSubview:blueView];
    
    while ( [self.viewsToProcess count] > 0 ) {
        UIView *currentView = [self.viewsToProcess objectAtIndex:0];
        
        if ( currentView.isAccessibilityElement ) {
            [self processAccessibilityElement:currentView];
        }
        
        [self.viewsToProcess addObjectsFromArray:currentView.subviews];
        
        [self.viewsToProcess removeObject:currentView];
    }
    
}

-(void)processAccessibilityElement:(UIView*)view {
    BOOL isButtonLabel = [view.superview isKindOfClass:[UIButton class]];
    BOOL isSegmentedControlLabel = [view.superview.superview isKindOfClass:[UISegmentedControl class]];
    BOOL excludeElement = isButtonLabel || isSegmentedControlLabel;
    
    if ( !excludeElement ) {
        CGRect elementFrame = [view convertRect:view.bounds toView:view.window];
        
        UILabel *overlayElement = [[UILabel alloc] initWithFrame:elementFrame];
        overlayElement.adjustsFontSizeToFitWidth = YES;
        overlayElement.minimumScaleFactor = 0.5;
        overlayElement.backgroundColor = [UIColor redColor];
        overlayElement.textAlignment = NSTextAlignmentCenter;
        overlayElement.text = view.accessibilityLabel;
        
        [self.overlayWindow addSubview:overlayElement];
    }
}


@end
