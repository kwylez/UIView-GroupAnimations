//
//  CustomView.h
//  ScaleView
//
//  Created by Cory D. Wiles on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"

@interface CustomView : UIView {
@private

  CALayer *animationLayer;
}

@property (nonatomic, retain) CALayer *animationLayer;

@end
