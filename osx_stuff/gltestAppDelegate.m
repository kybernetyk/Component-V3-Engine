//
//  gltestAppDelegate.m
//  gltest
//
//  Created by jrk on 17/11/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "gltestAppDelegate.h"
#import "MXOpenGLView.h"

@implementation gltestAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{
	// Insert code here to initialize your application 
}

- (void) renderScene
{
	[glView startDrawing];
	

	[glView endDrawing];
}

@end
