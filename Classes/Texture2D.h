/*
 *  Texture2D.h
 *  SpaceHike
 *
 *  Created by jrk on 6/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once
#include <string>
#include <OpenGLES/ES1/gl.h>
namespace mx3 
{
	
		
	typedef struct _TextureParams 
	{
		GLuint	minFilter;
		GLuint	magFilter;
		GLuint	wrapS;
		GLuint	wrapT;
	} TextureParams;


	class Texture2D
	{
	public:
		Texture2D (std::string filename);
		~Texture2D ();
		
		bool loadFromFile (std::string filename);
		void makeActive ();
		
		unsigned int _openGlTextureID;
		
		std::string _filename;
		
		void setTexParams (TextureParams *texParams);
		
		void setAliasTexParams ();
		void setAntiAliasTexParams ();
		
		unsigned int w;
		unsigned int h;
	};


}