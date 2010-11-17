//
//  MXOpenGLView.h
//  gltest
//
//  Created by jrk on 17/11/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface MXOpenGLView : NSOpenGLView
{
	CVDisplayLinkRef displayLink;
	id delegate;
}
@property (readwrite, assign) IBOutlet id delegate;

- (void) startDrawing;
- (void) endDrawing;


- (CVReturn)getFrameForTime:(const CVTimeStamp*)outputTime;


@end
