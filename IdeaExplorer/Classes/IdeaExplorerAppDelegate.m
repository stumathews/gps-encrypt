//
//  IdeaExplorerAppDelegate.m
//  IdeaExplorer
//
//  Created by Stuart Mathews on 11/06/2010.
//  Copyright Stuart Mathews Inc. 2010. All rights reserved.
//

#import "IdeaExplorerAppDelegate.h"
#import "IdeaExplorerViewController.h"

@implementation IdeaExplorerAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
