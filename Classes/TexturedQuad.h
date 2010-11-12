/*
 *  TexturedQuad.h
 *  SpaceHike
 *
 *  Created by jrk on 6/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once
#include <string>
#include "Util.h"
#include "bm_font.h"

class Texture2D;

class IRenderable
{
public:
	
	static unsigned int LAST_GUID;
	
	IRenderable()
	{
		_guid = ++LAST_GUID;
		init();
	}
	
	virtual void init()
	{
		anchorPoint.x = 0.5;
		anchorPoint.y = 0.5;
		x = y = z = 0.0;
		scale = 1.0;
		rotation = 0.0;
		alpha = 1.0;
		w = h = 0;
	}
	
	
	virtual void renderContent()
	{
		//no op
	};
	
	float x;
	float y;
	float z;
	float w;
	float h;
	float alpha;
	float scale;
	float rotation;
	vector2D anchorPoint;

	unsigned int _guid;
};

class OGLFont : public IRenderable
{
public:
	OGLFont (std::string fnt_filename)
	{
		IRenderable::IRenderable();
		init();
		
		loadFromFNTFile (fnt_filename);
	}
	
	void init()
	{
		IRenderable::init();
		text = NULL;
		texture = NULL;
	}
	
	void transform ();
	void renderContent();
	
	bool loadFromFNTFile (std::string fnt_filename);
	
	char *text;
	bm_font font;
	Texture2D *texture;
};

class TexturedQuad : public IRenderable
{
public:
	TexturedQuad();
	TexturedQuad(Texture2D *existing_texture);
	TexturedQuad(Texture2D *existing_texture, float frame_x, float frame_y, float sprite_frame_width, float sprite_frame_height);
	TexturedQuad(std::string filename);
	~TexturedQuad ();

	void init()
	{
		IRenderable::init();
		
		texture = NULL;
		isAtlas = false;
		src.x = src.y = src.w = src.h = 0.0;
	}
	
	bool loadFromFile (std::string filename);
		
	void transform ();
	void renderContent();

	void renderFromAtlas ();
	
//	int atlas_frame_index_x;		//the frame index of the sprite from the atlas
//	int atlas_frame_index_y;		//this will be converted into texels. float texel_x = atlasInfo.w * atlas_frame_index_x ...
									//frame indizes start in top left corner. so x0,y0 = top left subimage
//	rect atlasInfo;
	bool isAtlas;
	
	
	rect src;
	
	Texture2D *texture;
};