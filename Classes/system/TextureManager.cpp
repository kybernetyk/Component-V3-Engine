/*
 *  TextureManager.cpp
 *  ComponentV3
 *
 *  Created by jrk on 16/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "TextureManager.h"

Texture2D *TextureManager::accquireTexture (std::string filename)
{
	printf("loading texture: %s = ", filename.c_str());
	if (_referenceCounts[filename] > 0)
	{
		_referenceCounts[filename] ++;
		printf("%p\n",_textures[filename]);
		return _textures[filename];
	}

	Texture2D *ret = new Texture2D(filename);
	if (!ret)
		return NULL;

	_textures[filename] = ret;
	_referenceCounts[filename] = 1;
	printf("%p\n",_textures[filename]);	
	return ret;
}

void TextureManager::releaseTexture (Texture2D *pTexture)
{
	if (!pTexture)
		return;
	
	std::string filename = pTexture->_filename;
	printf("releasing texture: %s =\n", filename.c_str());
	_referenceCounts[filename] --;
	printf("%p | %i\n",_textures[filename],_referenceCounts[filename]);
	if (_referenceCounts[filename] <= 0)
	{
		Texture2D *p = _textures[filename];
		_textures[filename] = NULL;
		delete p;
		_referenceCounts[filename] = 0;
	}
}