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

+(SMAccessibilityOverlay*)accessibilityOverlay {
    return [[SMAccessibilityOverlay alloc] init];
}

-(void)show {
    [self showWithWindow:nil];
}

-(void)showWithWindow:(UIWindow *)window {
    
    self.mainWindow = window ? window : [[UIApplication sharedApplication] keyWindow];
    
    BOOL windowIsAccessibilityOverlay = [self.mainWindow.rootViewController isKindOfClass:[SMAccessibilityOverlay class]];
    if ( !windowIsAccessibilityOverlay ) {
        [self configureOverlayWindow];
        [self populateOverlayWindow];
        [self.overlayWindow makeKeyAndVisible];
    }
}

# pragma mark - UI Event Handlers

-(void)didTapRootView {
    [self.mainWindow makeKeyAndVisible];
    [self.overlayWindow removeFromSuperview];
    self.overlayWindow = nil;
}

# pragma mark - Overlay Methods

-(void)configureOverlayWindow {
    self.overlayWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.overlayWindow.windowLevel = UIWindowLevelStatusBar;
	self.overlayWindow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
	self.overlayWindow.rootViewController = self;
    CGAffineTransform transform = self.mainWindow.rootViewController.view.transform;
    self.overlayWindow.rootViewController.view.transform = transform;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                    action:@selector(didTapRootView)];
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void)populateOverlayWindow {
    self.viewsToProcess = [NSMutableArray array];
    UIViewController *rootViewController = self.mainWindow.rootViewController;
    if ( rootViewController != nil ) {
        [self.viewsToProcess addObject:rootViewController.view];
    }
    
    NSUInteger *accessibilityItemsFound = 0;
    while ( [self.viewsToProcess count] > 0 ) {
        UIView *currentView = [self.viewsToProcess objectAtIndex:0];
        
        if ( currentView.isAccessibilityElement ) {
            [self processAccessibilityElement:currentView];
            accessibilityItemsFound++;
        }
        
        [self.viewsToProcess addObjectsFromArray:currentView.subviews];
        
        [self.viewsToProcess removeObject:currentView];
    }
    
    if ( accessibilityItemsFound == 0 ) {
        [self addWarningLabel];
    }
    
}

-(void)processAccessibilityElement:(UIView*)view {
    BOOL isButtonLabel = [view.superview isKindOfClass:[UIButton class]];
    BOOL isSegmentedControlLabel = [view.superview.superview isKindOfClass:[UISegmentedControl class]];
    BOOL excludeElement = isButtonLabel || isSegmentedControlLabel;
    
    if ( !excludeElement ) {
        CGRect elementFrame = [view convertRect:view.bounds toView:view.window];
        
        UILabel *overlayElement = [[UILabel alloc] init];
        overlayElement.adjustsFontSizeToFitWidth = YES;
        overlayElement.backgroundColor = [UIColor redColor];
        overlayElement.textAlignment = NSTextAlignmentCenter;
        overlayElement.text = view.accessibilityLabel;
        overlayElement.transform = self.overlayWindow.rootViewController.view.transform;
        overlayElement.frame = elementFrame;
        
        // iOS 5 doesn't support this
        if ( [overlayElement respondsToSelector:@selector(setMinimumScaleFactor:)]) {
            overlayElement.minimumScaleFactor = 0.5;
        }
        
        [self.overlayWindow addSubview:overlayElement];
    }
}

-(void)addWarningLabel {
    UILabel *warningLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.overlayWindow.frame, 10, 10)];
    warningLabel.numberOfLines = 0;
    warningLabel.textAlignment = NSTextAlignmentCenter;
    warningLabel.text = @"No accessibility items found.\n\n(If you're running in the simulator, be sure to turn on the Accessibility Inspector.)";
    warningLabel.backgroundColor = [UIColor clearColor];
    warningLabel.textColor = [UIColor whiteColor];
    [self.overlayWindow addSubview:warningLabel];
}


@end
