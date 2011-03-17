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

  origFrame  = self.customView.frame;
  origCenter = self.customView.center;

  /**
   * Set up scaling
   */
  CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
  
  [resizeAnimation setToValue:[NSValue valueWithCGSize:CGSizeMake(300, 450)]];
  resizeAnimation.fillMode            = kCAFillModeForwards;
  resizeAnimation.removedOnCompletion = NO;
  
  /**
   * Set up path movement
   */
  UIBezierPath *movePath = [UIBezierPath bezierPath];
  CGPoint ctlPoint       = CGPointMake(self.customView.center.x, self.customView.center.y);
  
  [movePath moveToPoint:self.customView.center];
  [movePath addQuadCurveToPoint:self.containerSubview.center controlPoint:ctlPoint];

  CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  
  moveAnim.path                = movePath.CGPath;
  moveAnim.removedOnCompletion = YES;
  
  /**
   * Setup rotation animation
   */
  CABasicAnimation* rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
  CATransform3D fromTransform       = CATransform3DMakeRotation(0, 0, 0, 1);
  CATransform3D toTransform         = CATransform3DMakeRotation(radians(90), 0, 0, 1);
  
  rotateAnimation.toValue             = [NSValue valueWithCATransform3D:toTransform];
  rotateAnimation.fromValue           = [NSValue valueWithCATransform3D:fromTransform];
  rotateAnimation.duration            = 2;
  rotateAnimation.fillMode            = kCAFillModeForwards;
  rotateAnimation.removedOnCompletion = NO;
  
  /**
   * Setup and add all animations to the group
   */
  CAAnimationGroup *group = [CAAnimationGroup animation]; 
  
  [group setAnimations:[NSArray arrayWithObjects:moveAnim, rotateAnimation, resizeAnimation, nil]];
  
  group.fillMode            = kCAFillModeForwards;
  group.removedOnCompletion = NO;
  group.duration            = 2.0f;
  group.delegate            = self;

  [group setValue:self.customView forKey:@"imageViewBeingAnimated"];
  
  /**
   * ...and go
   */
  [self.customView.layer addAnimation:group forKey:@"savingAnimation"];
}

- (IBAction)origView:(id)sender {
  
  /**
   * Set the scaling animation
   */
	CABasicAnimation *scaling = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
	
  scaling.fromValue           = [[self.customView.layer presentationLayer] valueForKeyPath:@"bounds.size"];
	scaling.toValue             = [NSValue valueWithCGSize:origFrame.size];
	scaling.removedOnCompletion = NO;
	scaling.fillMode            = kCAFillModeForwards;  
  
  /**
   * Set the rotating animation
   */ 
	CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform"];;
  CATransform3D toTransform  = CATransform3DMakeRotation(0, 0, 0, 1);

	rotation.fromValue           = [[self.customView.layer presentationLayer] valueForKeyPath:@"transform"];
	rotation.toValue             = [NSValue valueWithCATransform3D:toTransform];
	rotation.removedOnCompletion = NO;
	rotation.fillMode            = kCAFillModeForwards;
	rotation.duration            = 2.0;
  
  /**
   * Set up path movement
   */
  UIBezierPath *movePath = [UIBezierPath bezierPath];
  CGPoint ctlPoint       = CGPointMake(self.customView.center.x, self.customView.center.y);
  
  [movePath moveToPoint:self.containerSubview.center];
  [movePath addQuadCurveToPoint:origCenter controlPoint:ctlPoint];
  
  CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  
  moveAnim.path                = movePath.CGPath;
  moveAnim.removedOnCompletion = YES;

  /**
   * Set the group animation for both transformations to be applied at the same time
   */
	CAAnimationGroup *animation   = [CAAnimationGroup animation];
	animation.removedOnCompletion = NO;
	animation.autoreverses        = NO;
	animation.fillMode            = kCAFillModeForwards;
	animation.duration            = 2.0;
	animation.animations          = [NSArray arrayWithObjects:scaling, moveAnim, rotation, nil];
  
  [animation setValue:self.customView forKey:@"imageViewBeingAnimated"];
  
	[self.customView.layer addAnimation:animation forKey:@"animateLayer"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

#pragma - CAAnimationGroup Delegate Methods

- (void)animationDidStart:(CAAnimation *)anim {
  
  [UIView animateWithDuration:2.0 
                   animations:^ {
                     self.containerSubview.alpha = 0.2;
                   } 
                   completion:^(BOOL finished) {
                     NSLog(@"center point: %@", NSStringFromCGPoint(self.customView.center));
                   }
   ];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  
}

@end
