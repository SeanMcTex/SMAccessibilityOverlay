//
//  SMAccessibilityOverlayApplication.h
//  SMAccessibilityOverlayDemo
//
//  Created by Sean McMains on 2/4/13.
//  Copyright (c) 2013 Sean McMains. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMAccessibilityOverlayApplication : UIApplication

/**
 When this is set to YES, the class will watch for shake gestures and, when one
 is received, activate the accessibility overlay for the current key window.
 */
@property (nonatomic, assign) BOOL accessibilityOverlayAppearsOnShake;

@end
