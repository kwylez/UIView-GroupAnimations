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

  self.customView = nil;
  self.btn        = nil;
  self.orig       = nil;
  
  [super viewDidUnload];
}

- (IBAction)resizeView:(id)sender {
  
  NSLog(@"center point: %@", NSStringFromCGPoint(self.customView.center));
  
  origFrame  = self.customView.frame;
  origCenter = self.customView.center;
  
  [UIView animateWithDuration:2.0 
                   animations:^ {

                     CGRect viewFrame;

                     viewFrame = CGRectMake(self.containerSubview.frame.origin.x, self.containerSubview.frame.origin.x, 200, 300);
                     self.customView.frame       = viewFrame;
                     self.containerSubview.alpha = 0.2;
                     self.customView.center      = self.containerSubview.center;
                     self.customView.transform   = CGAffineTransformMakeRotation(M_PI / 2);
                   } 
                   completion:^(BOOL finished) {
                     NSLog(@"center point: %@", NSStringFromCGPoint(self.customView.center));
                   }
   ];
}

- (IBAction)origView:(id)sender {
  
  [UIView animateWithDuration:2.0 
                   animations:^ {
                     self.customView.frame     = origFrame;
                     self.customView.transform = CGAffineTransformIdentity;
                   } 
                   completion:^(BOOL finished) {
                     
                   }
   ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

@end
