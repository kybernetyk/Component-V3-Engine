//
//  gltestAppDelegate.h
//  gltest
//
//  Created by jrk on 17/11/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MXOpenGLView.h"

@interface gltestAppDelegate : NSObject <NSApplicationDelegate> 
{
    NSWindow *window;
	
	IBOutlet MXOpenGLView *glView;
}

@property (assign) IBOutlet NSWindow *window;

@end
