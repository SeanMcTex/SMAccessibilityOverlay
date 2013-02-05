//
//  SMAccessibilityOverlay.h
//  AccessibilityOverlay
//
//  Created by Sean McMains on 2/2/13.
//  Copyright (c) 2013 Sean McMains. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMAccessibilityOverlay : UIViewController

/**
 Convenience method to get an initialized new instance of SMAccessibilityOverlay
 */
+(SMAccessibilityOverlay*)accessibilityOverlay;

/**
 Analyze the current key window, and display an overlay showing the accessibility
 properties of its subviews.
 */
-(void)show;
 
/**
 Analyze the specified window, and display an overlay showing the accessibility
 properties of its subviews.
 */ 
-(void)showWithWindow:(UIWindow*)view;

@end
