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


const int TICKS_PER_SECOND = 30;
const int SKIP_TICKS = 1000 / TICKS_PER_SECOND;
const int MAX_FRAMESKIP = 5;
unsigned int next_game_tick = 1;//SDL_GetTicks();
int loops;
float interpolation;

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
	[displayLink setFrameInterval: 2];
	[displayLink addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
	
	timer = new Timer();
	timer->update();
}


- (void)applicationWillTerminate:(UIApplication *)application 
{
}

- (void)dealloc 
{
	[window release];
	[glView release];
	[super dealloc];
}


- (void)renderScene
{

	timer->update();
	
//	loops = 0;

	//interpolation klappt nur, wenn SDL_GetTicks() geportet wurde >.<
#define ADVANCED_LOOP
	//interpoliert
	timer->printFPS();
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
	scene->update(timer->fdelta());
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


@end