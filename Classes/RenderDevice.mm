#include "RenderDevice.h"
#include <memory.h>
#include <stdlib.h>
#include <algorithm>
#include "Util.h"

//#include "SDL.h"

//#include <windows.h>
//#include <OpenGL/gl.h>        // Header File For The OpenGL32 Library
//#include <OpenGL/glu.h>       // Header File For The GLu32 Library
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/Es1/glext.h>


RenderDevice* RenderDevice::_sharedInstance = 0;

RenderDevice::RenderDevice (void)
{

}

RenderDevice::~RenderDevice (void)
{

}

RenderDevice* RenderDevice::sharedInstance (void)
{
	if(!_sharedInstance)
		_sharedInstance = new RenderDevice;

   return _sharedInstance;
}

void RenderDevice::unload (void)
{
//   SDL_Quit ();

	if (_sharedInstance)
   {
      delete _sharedInstance;
      _sharedInstance = NULL;
   }
}

void RenderDevice::setupViewportAndProjection (int viewport_width_in_pixels, int viewport_height_in_pixels, float viewport_width_in_meters, float viewport_height_in_meters)
{
	
	/*glMatrixMode(GL_PROJECTION);
	 glOrthof(-160,160,-240,240, -500, 500);
	 glMatrixMode(GL_MODELVIEW);
	 glViewport(0, 0, 320, 480);
	 //Initialize OpenGL states
	 glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	 glEnable(GL_TEXTURE_2D);
	 glEnable(GL_BLEND);
	 glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
	 
	 glEnableClientState(GL_VERTEX_ARRAY);
	 glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	 */
	
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	glViewport(0,0,viewport_width_in_pixels, viewport_height_in_pixels);
	
    glEnable(GL_TEXTURE_2D); //enable texture mapping
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f); //Black Background
    glClearDepthf(1.0); //enables clearing of deapth buffer
    glDepthFunc(GL_LEQUAL); //type of depth test
    glEnable(GL_DEPTH_TEST); //enables depth testing
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );//GL_ONE_MINUS_SRC_ALPHA);      // Enable Alpha Blending (disable alpha testing)
    
    glShadeModel(GL_SMOOTH); //enables smooth color shading
	glEnable(GL_ALPHA_TEST);
	glAlphaFunc(GL_GREATER, 0.1);
	
	glEnable(GL_BLEND);
	
	
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity(); //Reset projection matrix

	glOrthof(-viewport_width_in_meters/2.0 , viewport_width_in_meters/2.0 , -viewport_height_in_meters/2.0, viewport_height_in_meters/2.0 , -10.0 , 10.0 );

	//landscape

#ifdef MANUAL_LANDSCAPE
	glRotatef(-90, 0, 0, 1);
#endif
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	
			glEnableClientState( GL_VERTEX_ARRAY);
			glEnableClientState( GL_TEXTURE_COORD_ARRAY );
	
			glEnable( GL_TEXTURE_2D);
	
//	printf("OMFG");

/*	_pixelViewportSize.x = viewport_width_in_pixels;
	_pixelViewportSize.y = viewport_height_in_pixels;
	
	_meterViewportSize.x = viewport_width_in_meters;
	_meterViewportSize.y = viewport_height_in_meters;*/

	
	//iphone landscape
	 _pixelViewportSize.x = viewport_width_in_pixels;
	 _pixelViewportSize.y = viewport_height_in_pixels;
	 
	/*
	 iPhone muessen wir die meter-size invertieren, da das ding ja um 90 grad landscape gehalten wird
	 */
	 _meterViewportSize.x = viewport_height_in_meters;
	 _meterViewportSize.y = viewport_width_in_meters;
	
	
}

void RenderDevice::init (void)
{
//	SDL_Init (SDL_INIT_VIDEO);

	// Create a double-buffered draw context
  //  SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);

	//fuer welches bildformat wurden die grafiken gemacht?
//	_referenceScreenSize.x = 8000;
//	_referenceScreenSize.y = 6000;

//	_pixelToMeterRatio = 1.0 / 32.0f; //1 meter equals 32 pixels
									  //wird nur fuer pixelToMeter() benutzt
									  //mal depreacaten?
	
	_pixelToMeterRatio = 1.0;
	
	//physikalischer screen size
#ifdef MANUAL_LANDSCAPE
	float screen_size_x = 320.0;
	float screen_size_y = 480.0;
#else
	float screen_size_x = 480.0;
	float screen_size_y = 320.0;
#endif
	float xyratio = screen_size_x / screen_size_y;
	

#ifdef MANUAL_LANDSCAPE
	float viewport_size_x = 320.0;
	float viewport_size_y = 480.0;// / pixeltometerratio;//viewport_size_x / xyratio;
#else
	float viewport_size_x = 480.0;// / pixeltometerratio;//viewport_size_x / xyratio;
	float viewport_size_y = 320.0;	
#endif
	
	float mapzoom = 1.00; //cvgmap zooms in by 25% >.<

	setupViewportAndProjection(screen_size_x,screen_size_y,viewport_size_x*mapzoom,viewport_size_y*mapzoom);
	
}


/*void RenderDevice::flip (void)
{
	//SDL_GL_SwapBuffers(); - WICHTIK
	//glClearColor(0.7,0.0,0.7,0.0);
	//glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);	 // Clear The Screen And The Depth Buffer
	glLoadIdentity();
	glTranslatef(-_pixelViewportSize.x/2.0, -_pixelViewportSize.y/2.0, 0);
}*/

void RenderDevice::beginRender (void)
{
	glLoadIdentity();
	
#ifdef MANUAL_LANDSCAPE
	glTranslatef(-_pixelViewportSize.y/2.0, -_pixelViewportSize.x/2.0, 0);
#else
	glTranslatef(-_pixelViewportSize.x/2.0, -_pixelViewportSize.y/2.0, 0);
#endif
}

void RenderDevice::endRender (void)
{
	
}


void RenderDevice::release (void)
{

}

