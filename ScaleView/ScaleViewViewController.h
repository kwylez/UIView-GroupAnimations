//
//  ScaleViewViewController.h
//  ScaleView
//
//  Created by Cory D. Wiles on 1/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"

@interface ScaleViewViewController : UIViewController {

  CustomView *customView;
  UIButton *btn;
  UIButton *orig;
  CGPoint origCenter;
  CGRect origFrame;
  
  UIView *containerSubview;
}

@property (nonatomic, retain) CustomView *customView;
@property (nonatomic, retain) IBOutlet UIButton *btn;
@property (nonatomic, retain) IBOutlet UIButton *orig;
@property (nonatomic, assign) CGPoint origCenter;
@property (nonatomic, assign) CGRect origFrame;
@property (nonatomic, retain) UIView *containerSubview;

- (IBAction)resizeView:(id)sender;
- (IBAction)origView:(id)sender;

@end
