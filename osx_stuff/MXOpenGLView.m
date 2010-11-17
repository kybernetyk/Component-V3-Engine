//
//  MXOpenGLView.m
//  gltest
//
//  Created by jrk on 17/11/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "MXOpenGLView.h"
#import <OpenGL/OpenGL.h>

// This is the renderer output callback function
static CVReturn MyDisplayLinkCallback(CVDisplayLinkRef displayLink, const CVTimeStamp* now, const CVTimeStamp* outputTime,
									  CVOptionFlags flagsIn, CVOptionFlags* flagsOut, void* displayLinkContext)
{
    CVReturn result = [(MXOpenGLView*)displayLinkContext getFrameForTime:outputTime];

    return result;
}


@implementation MXOpenGLView
@synthesize delegate;

- (void)prepareOpenGL
{
	// Synchronize buffer swaps with vertical refresh rate
    GLint swapInt = 1;
    [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];

    
	// Create a display link capable of being used with all active displays
    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
	
    // Set the renderer output callback function
    CVDisplayLinkSetOutputCallback(displayLink, &MyDisplayLinkCallback, self);
	
    // Set the display link for the current renderer
    CGLContextObj cglContext = [[self openGLContext] CGLContextObj];
    CGLPixelFormatObj cglPixelFormat = [[self pixelFormat] CGLPixelFormatObj];
    CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, cglContext, cglPixelFormat);
	
    // Activate the display link
    CVDisplayLinkStart(displayLink);
}

- (void) startDrawing
{
	CGLLockContext([[self openGLContext] CGLContextObj]);
	[[self openGLContext] makeCurrentContext];
}

- (void) endDrawing
{
//	glFlush();
	[[self openGLContext] flushBuffer];	
	CGLUnlockContext([[self openGLContext] CGLContextObj]);
}

- (CVReturn)getFrameForTime:(const CVTimeStamp*)outputTime
{
	[delegate renderScene];
	


    return kCVReturnSuccess;
}

- (void)dealloc
{
    // Release the display link
    CVDisplayLinkRelease(displayLink);
	
    [super dealloc];
}
@end
