/*
 *  RenderableManager.cpp
 *  ComponentV3
 *
 *  Created by jrk on 16/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "RenderableManager.h"
#include "TexturedQuad.h"

TexturedQuad *RenderableManager::accquireTexturedQuad (std::string filename)
{
	printf("loading tex quad: %s = ", filename.c_str());
	if (_referenceCounts[filename] > 0)
	{
		_referenceCounts[filename] ++;
		printf("%p\n",_renderables[filename]);
		return (TexturedQuad*)_renderables[filename];
	}
	
	TexturedQuad *ret = new TexturedQuad(filename);
	if (!ret)
		return NULL;
	
	_renderables[filename] = ret;
	_referenceCounts[filename] = 1;
	printf("%p\n",_renderables[filename]);	
	return ret;
}


TexturedAtlasQuad *RenderableManager::accquireTexturedAtlasQuad (std::string filename)
{
	printf("loading tex atlas quad: %s = ", filename.c_str());
	if (_referenceCounts[filename] > 0)
	{
		_referenceCounts[filename] ++;
		printf("%p\n",_renderables[filename]);
		return (TexturedAtlasQuad*)_renderables[filename];
	}
	
	TexturedAtlasQuad *ret = new TexturedAtlasQuad(filename);
	if (!ret)
		return NULL;
	
	_renderables[filename] = ret;
	_referenceCounts[filename] = 1;
	printf("%p\n",_renderables[filename]);	
	return ret;
	
}


OGLFont *RenderableManager::accquireOGLFont (std::string filename)
{
	printf("loading ogl font: %s = ", filename.c_str());
	if (_referenceCounts[filename] > 0)
	{
		_referenceCounts[filename] ++;
		printf("%p\n",_renderables[filename]);
		return (OGLFont*)_renderables[filename];
	}
	
	OGLFont *ret = new OGLFont(filename);
	if (!ret)
		return NULL;
	
	_renderables[filename] = ret;
	_referenceCounts[filename] = 1;
	printf("%p\n",_renderables[filename]);	
	return ret;
	
}

void RenderableManager::release (IRenderable *pRenderable)
{
	if (!pRenderable)
		return;
	
	std::string filename = pRenderable->_filename;
	
	printf("releasing renderable: %s =\n", filename.c_str());
	_referenceCounts[filename] --;
	printf("%p | %i\n",_renderables[filename],_referenceCounts[filename]);
	if (_referenceCounts[filename] <= 0)
	{
		IRenderable *p = _renderables[filename];
		_renderables[filename] = NULL;
		delete p;
		_referenceCounts[filename] = 0;
	}
}