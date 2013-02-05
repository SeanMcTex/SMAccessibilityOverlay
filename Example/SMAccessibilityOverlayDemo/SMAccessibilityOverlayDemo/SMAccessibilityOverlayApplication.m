//
//  SMAccessibilityOverlayApplication.m
//  SMAccessibilityOverlayDemo
//
//  Created by Sean McMains on 2/4/13.
//  Copyright (c) 2013 Sean McMains. All rights reserved.
//

#import "SMAccessibilityOverlayApplication.h"
#import "SMAccessibilityOverlay.h"

@implementation SMAccessibilityOverlayApplication

- (id)init
{
    self = [super init];
    if (self) {
        _accessibilityOverlayAppearsOnShake = YES;
    }
    return self;
}

# pragma mark - Private

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    BOOL eventWasShakeMotion = (motion == UIEventSubtypeMotionShake);
    
    if ( eventWasShakeMotion && self.accessibilityOverlayAppearsOnShake ) {
        SMAccessibilityOverlay *overlay = [SMAccessibilityOverlay accessibilityOverlay];
        [overlay show];
    }
}




@end
