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


#include "Scene.h"
#include "RenderDevice.h"
#import <QuartzCore/QuartzCore.h>

//Game::GameApp *app;

Scene::Scene *scene;


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
@synthesize glView;
- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	//mTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0/FPS) target:self selector:@selector(renderScene) userInfo:nil repeats:YES];
	
	
	//set landscape
	[[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeRight animated:NO];
	
	scene = new Scene();
	scene->init();

	RenderDevice::sharedInstance()->init ();
	
	next_game_tick = My_SDL_GetTicks();
	
	displayLink = [CADisplayLink displayLinkWithTarget: self selector:@selector(renderScene)];
	[displayLink setFrameInterval: 1];
	[displayLink addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
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
	[window release];
	[glView release];
	[super dealloc];
}


- (void)renderScene
{
	if (paused)
		return;
	
	timer.update();
	
//	loops = 0;

	//interpolation klappt nur, wenn SDL_GetTicks() geportet wurde >.<
#define ADVANCED_LOOP
	//interpoliert
	timer.printFPS();
#ifdef ADVANCED_LOOP
	loops = 0;
	while( My_SDL_GetTicks() > next_game_tick && loops < MAX_FRAMESKIP) 
	{
		scene->update(1.0/TICKS_PER_SECOND);
		next_game_tick += SKIP_TICKS;
		loops++;
		//printf(".");
	}
	//printf("\n");
	
#else
	scene->update(timer.fdelta());
#endif
	
	//printf("delta: %f\n", timer->fdelta());
	//interpolation = float( My_SDL_GetTicks() + SKIP_TICKS - next_game_tick ) / float( SKIP_TICKS );

	[glView startDrawing];
	RenderDevice::sharedInstance()->beginRender();

	//scene->render(interpolation * (1.0/TICKS_PER_SECOND));
	scene->render(1.0);
	
	////////////////////////////////////////////////
	//oder einfach auf nstimer verlassen
	
/*	app->update(1.0/TICKS_PER_SECOND);
	interpolation = 1.0;
	app->render(interpolation * (1.0/TICKS_PER_SECOND));*/
	
	//nxf::RenderDevice::sharedInstance()->flushRenderPipeline();

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
		g_GameState.experience_needed_to_levelup = g_GameState.level*g_GameState.level*g_GameState.level+280;
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
	g_GameState.experience_needed_to_levelup =g_GameState.level*g_GameState.level*g_GameState.level+280;
	
}

@end
