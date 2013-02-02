//
//  SMViewController.m
//  SMAccessibilityOverlayDemo
//
//  Created by Sean McMains on 2/2/13.
//  Copyright (c) 2013 Sean McMains. All rights reserved.
//

#import "SMViewController.h"
#import "SMAccessibilityOverlay.h"

@interface SMViewController ()

@end

@implementation SMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapShowAccessibilityOverlay:(id)sender {
    SMAccessibilityOverlay *accessibilityOverlay = [[SMAccessibilityOverlay alloc] init];
    [accessibilityOverlay show];
}
@end
