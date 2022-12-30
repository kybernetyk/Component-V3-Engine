//
//  SpaceHikeAppDelegate.m
//  SpaceHike
//
//  Created by AaronF on 14/12/2008.
//  Copyright Strange Flavour Ltd 2008. All rights reserved.
//

#import "ComponentV3AppDelegate.h"
#import "EAGLView.h"
#include <sys/time.h>
#include "Entity.h"
#include "EntityManager.h"
#import "MainViewController.h"
#include "Scene.h"
#include "RenderDevice.h"
#import <QuartzCore/QuartzCore.h>
#include "Timer.h"
#include "globals.h"

using namespace mx3;
using namespace game;



const int TICKS_PER_SECOND = 60;
const int SKIP_TICKS = 1000 / TICKS_PER_SECOND;
const int MAX_FRAMESKIP = 5;
unsigned int next_game_tick = 1;//SDL_GetTicks();
int loops;
float interpolation;
bool paused = false;

/* returns the system time in milliseconds */
unsigned int My_SDL_GetTicks()
{
	timeval v;
	gettimeofday(&v, 0);
	//long millis = (v.tv_sec * 1000) + (v.tv_usec / 1000);
	//return millis;
	
	return (v.tv_sec * 1000) + (v.tv_usec / 1000);
}




@implementation ComponentV3AppDelegate
@synthesize window;


#pragma mark -
#pragma mark stuff
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	mainViewController = [[MainViewController alloc] initWithNibName: @"MainViewController" bundle: nil];
	CGFloat height = UIScreen.mainScreen.bounds.size.height;
	CGFloat width = UIScreen.mainScreen.bounds.size.width;

	[mainViewController.view setFrame: CGRectMake(0, 0, width, height)];

//	[window setFrame: CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width)];
////	[window addSubview: [mainViewController view]];

	[window setFrame: CGRectMake(0, 0, width, height)];
	[window setRootViewController: mainViewController];

	[mainViewController.view setFrame: CGRectMake(0, 0, width, height)];

	glView = [[mainViewController glView] retain];
	
	scene = new Scene();
	scene->init();
	
	RenderDevice::sharedInstance()->init (width, height);
	
	next_game_tick = My_SDL_GetTicks();
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
	displayLink = [CADisplayLink displayLinkWithTarget: self selector:@selector(renderScene)];
	[displayLink setFrameInterval: 1];
	[displayLink addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
	//mac init
#endif
	
	paused = false;
	//timer = new Timer();
	//timer->update();
	
	
}


- (void)applicationWillTerminate:(UIApplication *)application 
{
	[self saveGameState];
}

- (void)dealloc 
{
	[[mainViewController view] removeFromSuperview];
	[mainViewController release];
	[window release];
	[glView release];
	[super dealloc];
}


- (void)renderScene
{
	if (paused)
		return;
	
	timer.update();
	g_FPS = timer.printFPS(false);
	
#define ADVANCED_LOOP
#ifdef ADVANCED_LOOP
	loops = 0;
	while( My_SDL_GetTicks() > next_game_tick && loops < MAX_FRAMESKIP) 
	{
		scene->update(1.0/TICKS_PER_SECOND);
		next_game_tick += SKIP_TICKS;
		loops++;
	}
#else
	scene->update(timer.fdelta());
#endif

	
	//draw
	[glView startDrawing];
	RenderDevice::sharedInstance()->beginRender();

	//scene->render(interpolation * (1.0/TICKS_PER_SECOND));
	scene->render(1.0);
	
	scene->frameDone();
	RenderDevice::sharedInstance()->endRender();
	[glView endDrawing];
}

-(void)SavePrefs
{
}

-(void)LoadPrefs
{
}

#pragma mark -
#pragma mark delegate

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application 
{
	[self saveGameState];
	paused = true;
	//	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application 
{
//	[[CCDirector sharedDirector] resume];
		paused = false;
	next_game_tick = My_SDL_GetTicks();
	timer.update();
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
//	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application 
{
//	[[CCDirector sharedDirector] stopAnimation];
	paused = true;
}

-(void) applicationWillEnterForeground:(UIApplication*)application 
{
//	[[CCDirector sharedDirector] startAnimation];
	paused = false;
	next_game_tick = My_SDL_GetTicks();
	timer.update();
}


- (void)applicationSignificantTimeChange:(UIApplication *)application 
{
	//[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
	next_game_tick = My_SDL_GetTicks();
	timer.update();
}

#pragma mark -
#pragma mark restoresave
- (void) saveGameState
{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	
	if (g_GameState.level <= 0)
	{
		g_GameState.level = 1;
		g_GameState.experience_needed_to_levelup = g_GameState.level*g_GameState.level*g_GameState.level+100;
	}
	
	[defs setInteger: g_GameState.experience forKey: @"gs_experience"];
	[defs setInteger: g_GameState.level forKey: @"gs_level"];
	[defs setInteger: g_GameState.score forKey: @"gs_score"];
	[defs synchronize];	
}

- (void) loadGameState
{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	
	NSInteger xp = [defs integerForKey: @"gs_experience"];
	NSInteger level = [defs integerForKey: @"gs_level"];
	NSInteger score = [defs integerForKey: @"gs_score"];
	if (level <= 0)
		level = 1;
	
	g_GameState.experience = xp;
	g_GameState.level = level;
	g_GameState.score = score;
	g_GameState.experience_needed_to_levelup =g_GameState.level*g_GameState.level*g_GameState.level+100;
	
}

@end
