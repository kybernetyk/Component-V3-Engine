//
//  EAGLView.m
//  SpaceHike
//
//  Created by AaronF on 14/12/2008.
//  Copyright Strange Flavour Ltd 2008. All rights reserved.
//



#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "EAGLView.h"
#include "InputDevice.h"

#define USE_DEPTH_BUFFER 0

// global variables

int gTouched; // gets set 1-5 when on screen buttons are pressed
int gMapX,gMapY; // returns map offset for navigation

// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end


@implementation EAGLView

@synthesize context;


// You must implement this method
+ (Class)layerClass 
{
    return [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder 
{
    
    if ((self = [super initWithCoder:coder])) {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
    }
    return self;
}
- (BOOL) isMultipleTouchEnabled {
	return YES;
}


- (void)startDrawing 
{
    [EAGLContext setCurrentContext:context];
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glClearColor(0.5f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
	glLoadIdentity();
    
}

- (void)endDrawing 
{
	
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


- (void)layoutSubviews 
{
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
}


- (BOOL)createFramebuffer {
    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


- (void)destroyFramebuffer {
    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}



- (void)dealloc 
{
        
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context release];  
    [super dealloc];
}

#pragma mark -
#pragma mark === Touch handling  ===
#pragma mark

-(CGPoint)convertToGL:(CGPoint)uiPoint
{
	CGSize size = [self bounds].size;

	CGFloat x = uiPoint.x / size.width * 480.0f;
	CGFloat y = uiPoint.y / size.height * 320.0f;


#ifdef ORIENTATION_LANDSCAPE
	CGPoint ret = CGPointZero;
	ret.x = x;
	ret.y = 320.0 - y;
#endif
	
	return ret;
/*	CGSize s = winSizeInPoints_;
	float newY = s.height - uiPoint.y;
	float newX = s.width - uiPoint.x;
	
	CGPoint ret = CGPointZero;
	switch ( deviceOrientation_) {
		case CCDeviceOrientationPortrait:
			ret = ccp( uiPoint.x, newY );
			break;
		case CCDeviceOrientationPortraitUpsideDown:
			ret = ccp(newX, uiPoint.y);
			break;
		case CCDeviceOrientationLandscapeLeft:
			ret.x = uiPoint.y;
			ret.y = uiPoint.x;
			break;
		case CCDeviceOrientationLandscapeRight:
			ret.x = newY;
			ret.y = newX;
			break;
	}*/
	
	//	if( __ccContentScaleFactor != 1 && isContentScaleSupported_ )
	//		ret = ccpMult(ret, __ccContentScaleFactor);
	return ret;
}


// Handles the start of a touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	UITouch *touch = [[touches allObjects] objectAtIndex: 0];
	CGPoint loc = [touch locationInView: self];

	loc = [self convertToGL: loc];
	mx3::vector2D v = {(GLfloat)loc.x,(GLfloat)loc.y};

//	NSLog(@"touch down!");	
//	NSLog(@"loc: %f,%f",loc.x, loc.y);

	mx3::InputDevice::sharedInstance()->setTouchDownReceived(true);
	mx3::InputDevice::sharedInstance()->setTouchActive(true);
	mx3::InputDevice::sharedInstance()->setTouchLocation (v);
	
	
	// Enumerate through all the touch objects.
   /* for (UITouch *touch in touches)
	{
        // Send to the dispatch method, which will make sure the appropriate subview is acted upon
        //[self dispatchFirstTouchAtPoint:[touch locationInView:self]];
	
		//convert the touch to our game coordinates
		//iphone coord system: 0,0 = top/left in portrait mode
		//so to landscape: game.x = iphone.y; game.y = iphone.x
		NSLog(@"touch: %@ | %f, %f",touch,[touch locationInView:self].x,[touch locationInView:self].y);
		
		vector2D v;
		v.x = [touch locationInView:self].y;
		v.y = [touch locationInView:self].x;
		
		InputDevice::sharedInstance()->setTouchActive(true);
		InputDevice::sharedInstance()->setTouchLocation (v);
    }    */
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"moved!");
	UITouch *touch = [[touches allObjects] objectAtIndex: 0];
	CGPoint loc = [touch locationInView: self];

	loc = [self convertToGL: loc];
	mx3::vector2D v = {(GLfloat)loc.x,(GLfloat)loc.y};
	
//	NSLog(@"touch moved!");	
//	NSLog(@"loc: %f,%f",loc.x, loc.y);

	mx3::InputDevice::sharedInstance()->setTouchMoved(true);
	mx3::InputDevice::sharedInstance()->setTouchActive(true);
	mx3::InputDevice::sharedInstance()->setTouchLocation (v);
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[touches allObjects] objectAtIndex: 0];
	CGPoint loc = [touch locationInView: self];
	
	loc = [self convertToGL: loc];
	mx3::vector2D v = {(GLfloat)loc.x,(GLfloat)loc.y};
	mx3::InputDevice::sharedInstance()->setTouchLocation (v);
	
//	NSLog(@"touch ended!");	
//	NSLog(@"loc: %f,%f",loc.x, loc.y);

	
	//NSLog(@"touch ended");
	mx3::InputDevice::sharedInstance()->setTouchActive(false);
	mx3::InputDevice::sharedInstance()->setTouchUpReceived(true);
}

@end

