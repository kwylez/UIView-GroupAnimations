//
//  ScaleViewAppDelegate.h
//  ScaleView
//
//  Created by Cory D. Wiles on 1/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScaleViewViewController;

@interface ScaleViewAppDelegate : NSObject <UIApplicationDelegate> {
@private

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ScaleViewViewController *viewController;

@end
