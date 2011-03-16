//
//  CustomView.m
//  ScaleView
//
//  Created by Cory D. Wiles on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomView.h"


@implementation CustomView

@synthesize animationLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
  if (self) {
      self.backgroundColor = [UIColor redColor];
      self.tag             = 1111;
      self.alpha           = 0.0;
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
}

@end
