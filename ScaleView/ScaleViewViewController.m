//
//  ScaleViewViewController.m
//  ScaleView
//
//  Created by Cory D. Wiles on 1/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScaleViewViewController.h"
#import "QuartzCore/QuartzCore.h"

static inline double radians(float degrees) {
  
  return (degrees * M_PI) / 180.0;
}

@implementation ScaleViewViewController

@synthesize customView;
@synthesize btn;
@synthesize orig;
@synthesize origCenter;
@synthesize origFrame;
@synthesize containerSubview;

- (void)dealloc {
  
  [customView release];
  [btn release];
  [orig release];
  [containerSubview release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {

  [super viewDidLoad];
  
  self.containerSubview = [[UIView alloc] initWithFrame:CGRectMake(300.0, 300.0, 400.0, 400.0)];
  self.containerSubview.alpha = 1.5;

  self.containerSubview.backgroundColor = [UIColor blackColor];
  
  [self.view addSubview:self.containerSubview];
  
  self.customView = [[CustomView alloc] initWithFrame:CGRectMake(176.0, 258.0, 72.0, 96.0)];
  self.customView.alpha = 1.0;
  
  [self.view addSubview:self.customView];
}

- (void)viewDidUnload {
  
  [self.customView removeFromSuperview];
  [self.containerSubview removeFromSuperview];
  
  self.containerSubview = nil;
  self.customView       = nil;
  self.btn              = nil;
  self.orig             = nil;
  
  [super viewDidUnload];
}

- (IBAction)resizeView:(id)sender {
  
//  NSLog(@"center point: %@", NSStringFromCGPoint(self.customView.center));
//  
//  origFrame  = self.customView.frame;
//  origCenter = self.customView.center;
//  
//  [UIView animateWithDuration:2.0 
//                   animations:^ {
//                     
//                     self.customView.frame       = CGRectMake(self.containerSubview.frame.origin.x, self.containerSubview.frame.origin.y, 200, 300);
//                     self.containerSubview.alpha = 0.2;
//                     self.customView.transform   = CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI / 2), CGAffineTransformMakeScale(1.5, 1.5));
//                     self.customView.center      = self.containerSubview.center;
//                   } 
//                   completion:^(BOOL finished) {
//                     NSLog(@"center point: %@", NSStringFromCGPoint(self.customView.center));
//                   }
//   ];
  
  
  
  // Set up fade out effect
  CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  
  [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.3]];
  fadeOutAnimation.fillMode            = kCAFillModeForwards;
  fadeOutAnimation.removedOnCompletion = NO;
  
  // Set up scaling
  CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
  
  [resizeAnimation setToValue:[NSValue valueWithCGSize:CGSizeMake(200, 300)]];
  resizeAnimation.fillMode            = kCAFillModeForwards;
  resizeAnimation.removedOnCompletion = NO;
  
  // Set up path movement
  CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  pathAnimation.calculationMode      = kCAAnimationPaced;
  pathAnimation.fillMode             = kCAFillModeForwards;
  pathAnimation.removedOnCompletion  = NO;
  
  CGPoint endPoint            = self.containerSubview.center;
  CGMutablePathRef curvedPath = CGPathCreateMutable();
  
  CGPathMoveToPoint(curvedPath, NULL, self.customView.frame.origin.x, self.customView.frame.origin.y);
  CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, self.customView.frame.origin.y, endPoint.x, self.customView.frame.origin.y, endPoint.x, endPoint.y);
  
  pathAnimation.path = curvedPath;
  
  CGPathRelease(curvedPath);
  
  CAAnimationGroup *group = [CAAnimationGroup animation]; 
  
  [group setAnimations:[NSArray arrayWithObjects:fadeOutAnimation, pathAnimation, resizeAnimation, nil]];
  group.fillMode            = kCAFillModeForwards;
  group.removedOnCompletion = NO;
  group.duration            = 2.0f;
  group.delegate            = self;

  [group setValue:self.customView forKey:@"imageViewBeingAnimated"];
  
  [self.customView.layer addAnimation:group forKey:@"savingAnimation"];
}

- (IBAction)origView:(id)sender {
  
  [UIView animateWithDuration:2.0 
                   animations:^ {
                     self.customView.frame       = origFrame;
                     self.customView.transform   = CGAffineTransformIdentity;
                     self.containerSubview.alpha = 1.0;
                   } 
                   completion:^(BOOL finished) {
                     
                   }
   ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

@end
