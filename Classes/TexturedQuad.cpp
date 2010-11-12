/*
 *  TexturedQuad.cpp
 *  SpaceHike
 *
 *  Created by jrk on 6/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "TexturedQuad.h"
#include <OpenGLES/ES1/gl.h>
#include "RenderDevice.h"
#include "Texture2D.h"

unsigned int IRenderable::LAST_GUID = 0;

TexturedQuad::TexturedQuad ()
{
	IRenderable::IRenderable();
	init();
}

TexturedQuad::TexturedQuad(Texture2D *existing_texture)
{
	IRenderable::IRenderable();
	init();

	texture = existing_texture;
	w = texture->w;
	h = texture->h;
}

TexturedQuad::TexturedQuad(Texture2D *existing_texture, float frame_x, float frame_y, float sprite_frame_width, float sprite_frame_height)
{
	IRenderable::IRenderable();	
	init();
	isAtlas = true;
	
	texture = existing_texture;
	
	w = sprite_frame_width;
	h = sprite_frame_height;
	

	src.x = frame_x;
	src.y = frame_y;
	src.w = sprite_frame_width;
	src.h = sprite_frame_height;
	
/*	float ffx = (w / existing_texture->w);
	float ffy = (h / existing_texture->h);
	
	atlasInfo.w = ffx; //frame width in texel units - not in pixels
	atlasInfo.h = ffy; // " " "

	atlasInfo.x = 0.0; //frame src x in texel units - not in pixels
	atlasInfo.y = 0.0; //
*/	
/*	int i_x = 2;
	int i_y = 0;
	
	rect *r = &sprite->sprite->atlasInfo;
	r->x = ffx * i_x;
	r->y = ffy * i_y;
	r->w = ffx;
	r->h = ffy;
	sprite->sprite->isAtlas = true;*/
	
	//w = texture->atlas_frame_w;
//	h = texture->atlas_frame_h;
	
}

TexturedQuad::TexturedQuad(std::string filename)
{
	IRenderable::IRenderable();
	init();
	loadFromFile(filename);
}

TexturedQuad::~TexturedQuad ()
{
	printf("%p: TexturedQuad::~TexturedQuad()\n",this);
	
	if (texture)
	{
		delete texture;
		texture = NULL;
	}
}

bool TexturedQuad::loadFromFile (std::string filename)
{
	texture = new Texture2D(filename);
	if (!texture)
	{
		delete texture;
		texture = NULL;
		return false;
	}
	texture->setAliasTexParams();
	
	w = texture->w;
	h = texture->h;
	
	
	return true;
}

#define USE_GL_SCALE 1

void TexturedQuad::transform ()
{
	glTranslatef( (w/2.0) - (anchorPoint.x*w) + x , (h/2.0) - (anchorPoint.y*h) + y, 0.0);

	if (rotation != 0.0f )
		glRotatef( -rotation, 0.0f, 0.0f, 1.0f );

#ifdef USE_GL_SCALE	
	if (scale != 1.0)
		glScalef( scale, scale, 1.0f );
#endif
}


void TexturedQuad::renderFromAtlas ()
{
	
	if (texture)
	{	
		//glLoadIdentity();
		glPushMatrix();
		transform();
		rect atlasInfo;
		atlasInfo.x = src.x / texture->w;
		atlasInfo.y = src.y / texture->h;
		
		atlasInfo.w = src.w / texture->w;
		atlasInfo.h = src.h / texture->h;		
		
		//atlasInfo.x = atlas_frame_index_x * atlasInfo.w;
		//atlasInfo.y = atlas_frame_index_y * atlasInfo.h;
		
	/*	GLfloat		coordinates[] = { 0.0f,	1.0,
			1.0,	1.0,
			0.0f,	0.0f,
			1.0,	0.0f };*/

		GLfloat		coordinates[] = { atlasInfo.x,	atlasInfo.y + atlasInfo.h,
			atlasInfo.x + atlasInfo.w,	atlasInfo.y + atlasInfo.h,
			atlasInfo.x,	atlasInfo.y,
			atlasInfo.x + atlasInfo.w,	atlasInfo.y };


/*		GLfloat		coordinates[] = { src.x,	src.y + src.h,
		 src.x + src.w,	src.y + src.h,
		 src.x,	src.y,
		 src.x + src.w,	src.y };*/
		
		
/*		GLfloat		coordinates[] = { 0.0f,	0.5,
		 1.0,	1.0,
		 0.5f,	0.0f,
		 1.0,	0.0f };*/
		
#ifdef USE_GL_SCALE		
		GLfloat		vertices[] = 
		{	
			-w/2,-h/2,z,
			w/2,-h/2,z,
			-w/2,h/2,z,
			w/2,h/2,z
		};
#else
		GLfloat		vertices[] = 
		{	
			-w*scale/2,-h*scale/2,z,
			w*scale/2,-h*scale/2,z,
			-w*scale/2,h*scale/2,z,
			w*scale/2,h*scale/2,z
		};
#endif
		
		glEnableClientState( GL_VERTEX_ARRAY);
		glEnableClientState( GL_TEXTURE_COORD_ARRAY );
		
		glEnable( GL_TEXTURE_2D);
		texture->makeActive();
		glColor4f(1.0, 1.0,1.0, alpha);
		glVertexPointer(3, GL_FLOAT, 0, vertices);
		glTexCoordPointer(2, GL_FLOAT, 0, coordinates);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		
		glDisable( GL_TEXTURE_2D);
		glDisableClientState(GL_VERTEX_ARRAY );
		glDisableClientState( GL_TEXTURE_COORD_ARRAY );
		glPopMatrix();
	}
	
}



void TexturedQuad::renderContent ()
{
	//	loadMatrix();
	if (isAtlas)
	{
		renderFromAtlas();
		return;
	}
	
	
	if (texture)
	{	
		//glLoadIdentity();
		glPushMatrix();
		transform();
		
		
		GLfloat		coordinates[] = { 0.0f,	1.0,
			1.0,	1.0,
			0.0f,	0.0f,
			1.0,	0.0f };
		
#ifdef USE_GL_SCALE		
		GLfloat		vertices[] = 
		{	
			-w/2,-h/2,z,
			w/2,-h/2,z,
			-w/2,h/2,z,
			w/2,h/2,z
		};
#else
		GLfloat		vertices[] = 
		{	
			-w*scale/2,-h*scale/2,z,
			w*scale/2,-h*scale/2,z,
			-w*scale/2,h*scale/2,z,
			w*scale/2,h*scale/2,z
		};
#endif
		
		
		glEnableClientState( GL_VERTEX_ARRAY);
		glEnableClientState( GL_TEXTURE_COORD_ARRAY );
		
		glEnable( GL_TEXTURE_2D);
		texture->makeActive();
		glColor4f(1.0, 1.0,1.0, alpha);
		glVertexPointer(3, GL_FLOAT, 0, vertices);
		glTexCoordPointer(2, GL_FLOAT, 0, coordinates);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		
		glDisable( GL_TEXTURE_2D);
		glDisableClientState(GL_VERTEX_ARRAY );
		glDisableClientState( GL_TEXTURE_COORD_ARRAY );
		glPopMatrix();
	}
	
}


extern std::string pathForFile2 (const char *filename);
#include "bm_font.h"
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

int bm_loadfont (const char *filename, bm_font *font)
{
	char spaces[100];
	
	
	FILE *f_in = fopen(filename, "rt");
	if (!f_in)
		return 0;
	
	//info skip
	char buff[512];
	memset(buff,0x00,512);
	fgets(buff, 512, f_in);
	//printf("buff: %s\n",buff);
	
	int packed;
	
	//header
	int br = fscanf(f_in, "common lineHeight=%d base=%d scaleW=%d scaleH=%d pages=%d packed=%d\n",
					&font->line_h, &font->base, &font->w, &font->h, &font->pages,&packed
					);
	
	//printf("br: %i\n", br);
	
	
	//page skip
	
	memset(buff,0x00,512);
	fgets(buff, 512, f_in);
	
	int page_id = 0;
	br = sscanf(buff, "page%[ ]id=%d%[ ]file=\"%s\"%[ ]\n",spaces,&page_id,spaces,font->tex_filename,spaces);
	
	if (font->tex_filename[strlen(font->tex_filename)-1] == '"')
		font->tex_filename[strlen(font->tex_filename)-1] = 0; //remove "
	
	//printf("buff: %s\n",buff);
	//printf("tex: %s\n",font->tex_filename);
	
	//char count
	memset(buff,0x00,512);
	fgets(buff, 512, f_in);
//	printf("buff: %s\n",buff);
	int chars_count = 0;
	br = sscanf(buff, "chars%[ ]count=%d%[ ]\n",spaces,&chars_count,spaces);
	
	
	//chars
	
	
	for (int i = 0; i <= chars_count; i++)
	{
		int char_id;
		bm_char temp_char;
		
		memset(buff,0x00,512);
		fgets(buff, 512, f_in);
	//	printf("buff: %s\n",buff);
		
		
		br = sscanf(buff, "char id=%d%[ ]x=%d%[ ]y=%d%[ ]width=%d%[ ]height=%d%[ ]xoffset=%d%[ ]yoffset=%d%[ ]xadvance=%d%[ ]page=%d%[ ]chnl=%d%[ ]\n",
					&char_id, spaces,
					
					&temp_char.x, spaces,
					&temp_char.y, spaces,
					&temp_char.w, spaces,
					&temp_char.h, spaces,
					&temp_char.x_offset, spaces,
					&temp_char.y_offset, spaces,
					&temp_char.x_advance, spaces,
					&temp_char.page, spaces,
					&temp_char.chnl,spaces	
					);
		if (br == 20)
		{
			font->chars[char_id] = temp_char;
		}
		else
		{
			abort();
		}
		//printf("i: %i - br: %i\n",i, br);
		
	}
	
	
	fclose (f_in);
	return 1;
}

int bm_width (bm_font *font, char *text)
{
	int w, l;

	w = 0;
	l = strlen(text);
	
	for (int i = 0; i < l; i++)
	{
		//w += font->chars[text[i]].w;
		w += font->chars[text[i]].x_advance-font->chars[text[i]].x_offset;
	}
	
	return w;
}

int bm_height (bm_font *font, char *text)
{
	int h = 0;
	int l = strlen(text);
	int th = 0;
	for (int i = 0; i < l; i++)
	{
		th = font->chars[text[i]].h;
		if (th > h)
			h = th;
	}
	
	return h;
}

void bm_destroyfont (bm_font *font)
{
	
}

bool OGLFont::loadFromFNTFile (std::string fnt_filename)
{
	const char *fn = pathForFile2 (fnt_filename.c_str()).c_str();;
	
	if (!bm_loadfont(fn, &font))
	{
		abort();
	}
	
	texture = new Texture2D(font.tex_filename);
	if (!texture)
	{
		delete texture;
		texture = NULL;
		
		abort();
		
		return false;
	}
	texture->setAliasTexParams();

	
//	w = texture->w;
//	h = texture->h;
}

void OGLFont::transform ()
{
	int w = bm_width(&font, text);
	float h = font.line_h*.75; //bm_height(&font, text);
	//rotation = -45.0;
//	anchorPoint.y = 0.5;
/*	anchorPoint.x = 1.0;
*/	
	glTranslatef(x, y, z);
	
	if (rotation != 0.0f )
		glRotatef( -rotation, 0.0f, 0.0f, 1.0f );

	if (scale != 1.0)
		glScalef( scale, scale, 1.0f );
	
	glTranslatef(- (anchorPoint.x * w),h - (anchorPoint.y * h), 0);
}


void OGLFont::renderContent()
{
	//printf("rendering %s @ %f,%f,%f\n",text, x,y,z);
	
	if (texture)
	{	
		//glLoadIdentity();
		glPushMatrix();
		transform();

		int l = strlen(text);
		
		
		glEnableClientState( GL_VERTEX_ARRAY);
		glEnableClientState( GL_TEXTURE_COORD_ARRAY );
		
		glEnable( GL_TEXTURE_2D);
		texture->makeActive();
		glColor4f(1.0, 1.0,1.0, alpha);

		
		double tx,ty,tw,th;
		
		
		bm_char *pchar = NULL;
		for (int i = 0; i < l; i++)
		{
			pchar = &font.chars[ text[i] ];
			
//			int w = pchar->w;
//			int h = pchar->h;
			
			tx = (double)pchar->x / (double)texture->w;
			ty = (double)pchar->y / (double)texture->h;
			tw = (double)pchar->w / (double)texture->w;
			th = (double)pchar->h / (double)texture->h;
			
/*			int _x = 0;
			int _y = 0;
			int _w = _x+pchar->w;
			int _h = _y+pchar->h;

			GLfloat		vertices[] = 
			 {	
				 _x,	_y,		0,
				 _w,	_y,		0,
				 _x,	_h,		0,
				 _w,	_h,		0
			 };
			 			
*/			
			
			GLfloat		vertices[] = 
			{	
				0,			0,			0,
				pchar->w,	0,			0,
				0,			pchar->h,	0,
				pchar->w,	pchar->h,	0
			};
			
			GLfloat		coordinates[] = { tx,	ty + th,
				tx + tw,	ty + th,
				tx,	ty,
				tx + tw,	ty };

			glTranslatef(0, -pchar->h, 0.0);
			glTranslatef(pchar->x_offset, -pchar->y_offset, 0.0);			

			glVertexPointer(3, GL_FLOAT, 0, vertices);
			glTexCoordPointer(2, GL_FLOAT, 0, coordinates);
			glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

			glTranslatef(-pchar->x_offset, pchar->y_offset, 0.0);			
			glTranslatef(0, pchar->h, 0.0);

			
			glTranslatef(pchar->x_advance-pchar->x_offset, 0, 0.0);			
		}
		
		glDisable( GL_TEXTURE_2D);
		glDisableClientState(GL_VERTEX_ARRAY );
		glDisableClientState( GL_TEXTURE_COORD_ARRAY );
		
		
		glPopMatrix();
	}
}
