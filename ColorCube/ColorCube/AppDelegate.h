//
//  AppDelegate.h
//  ColorCube
//
//  Created by Matt on 1/11/14.
//  Copyright (c) 2014 Matt Rajca. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SceneKit/SceneKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, weak) IBOutlet SCNView *sceneView;
@property (nonatomic, weak) IBOutlet NSSlider *hueMinSlider;
@property (nonatomic, weak) IBOutlet NSSlider *hueMaxSlider;

- (IBAction)filterHues:(id)sender;
- (IBAction)adjustHue:(id)sender;

@end
