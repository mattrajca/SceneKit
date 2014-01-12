//
//  AppDelegate.m
//  ColorCube
//
//  Created by Matt on 1/11/14.
//  Copyright (c) 2014 Matt Rajca. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate {
	NSMutableArray *_spheres;
	BOOL _filterHues;
}

/* RGB TO HSV */

typedef struct {
	CGFloat h;
	CGFloat s, v;
} HSV;

HSV RGBtoHSV(CGFloat r, CGFloat g, CGFloat b) {
	HSV o;
	
	CGFloat min, max, delta;
	min = MIN(r, MIN(g, b));
	max = MAX(r, MAX(g, b));
	
	o.v = max;
	
	delta = max - min;
	
	if (max != 0)
		o.s = delta / max;
	else {
		o.s = 0;
		o.h = -1;
		return o;
	}
	
	if (r == max)
		o.h = (g - b) / delta;
	else if (g == max)
		o.h = 2 + (b - r) / delta;
	else
		o.h = 4 + (r - g) / delta;
	
	o.h *= 60.0f;
	
	if (o.h < 0)
		o.h += 360.0f;
	
	return o;
}

- (void)awakeFromNib {
	self.sceneView.scene = [SCNScene scene];
	
	[self _setupColorCube];
}

- (void)_setupColorCube {
	_spheres = [NSMutableArray new];
	
	[SCNTransaction begin];
	
	for (CGFloat x = -1.0f; x <= 1.0f; x += 0.1) {
		for (CGFloat y = -1.0f; y <= 1.0f; y += 0.1) {
			for (CGFloat z = -1.0f; z <= 1.0f; z += 0.1) {
				CGFloat r = (x + 1.0f) / 2;
				CGFloat g = (y + 1.0f) / 2;
				CGFloat b = (z + 1.0f) / 2;
				
				SCNSphere *sphere = [SCNSphere sphereWithRadius:0.05];
				sphere.firstMaterial.diffuse.contents = [NSColor colorWithCalibratedRed:r green:g blue:b alpha:1.0f];
				
				SCNNode *node = [SCNNode nodeWithGeometry:sphere];
				node.position = SCNVector3Make(x, y, z);
				
				[self.sceneView.scene.rootNode addChildNode:node];
				
				[_spheres addObject:node];
			}
		}
	}
	
	[SCNTransaction commit];
}

- (void)filterHues:(id)sender {
	if ([sender state] == NSOnState) {
		_filterHues = YES;
	}
	else {
		_filterHues = NO;
	}
	
	[self adjustHue:nil];
}

- (void)adjustHue:(id)sender {
	CGFloat hueMin = [self.hueMinSlider floatValue] * 360;
	CGFloat hueMax = [self.hueMaxSlider floatValue] * 360;
	
	[SCNTransaction begin];
	
	for (SCNNode *sphere in _spheres) {
		NSColor *color = sphere.geometry.firstMaterial.diffuse.contents;
		
		CGFloat r = [color redComponent];
		CGFloat g = [color greenComponent];
		CGFloat b = [color blueComponent];
		
		HSV hsv = RGBtoHSV(r, g, b);
		
		if (!_filterHues) {
			sphere.opacity = 1.0;
		}
		else {
			if (hsv.h >= hueMin && hsv.h <= hueMax) {
				sphere.opacity = 0.0;
			}
			else {
				sphere.opacity = 1.0;
			}
		}
	}
	
	[SCNTransaction commit];
}

@end
