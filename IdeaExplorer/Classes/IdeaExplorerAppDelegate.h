//
//  IdeaExplorerAppDelegate.h
//  IdeaExplorer
//
//  Created by Stuart Mathews on 11/06/2010.
//  Copyright Stuart Mathews Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IdeaExplorerViewController;

@interface IdeaExplorerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    IdeaExplorerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet IdeaExplorerViewController *viewController;

@end

