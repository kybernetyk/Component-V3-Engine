//
//  SpaceHikeAppDelegate.h
//  SpaceHike
//
//  Created by AaronF on 14/12/2008.
//  Copyright Strange Flavour Ltd 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

#include "Timer.h"
#include "Scene.h"

#define FPS 60.0
// handy value to convert degrees to radians
#define RAD_DEGREE 0.01745


@interface ComponentV3AppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
	NSTimer*			mTimer;   // Rendering Timer
	CADisplayLink *displayLink;
	mx3::Timer timer;
	game::Scene *scene;

	EAGLView *glView;
	
	MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

-(void)renderScene;
-(void)LoadPrefs;
-(void)SavePrefs;

@end

