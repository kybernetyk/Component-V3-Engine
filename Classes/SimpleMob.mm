/*
 *  SimpleMob.cpp
 *  components
 *
 *  Created by jrk on 5/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#import "SimpleMob.h"
#import "Entity.h"
#import "Component.h"
#import "EntityManager.h"
#import "TexturedQuad.h"
#include "Texture2D.h"

Texture2D *cachedBlobTex = 0;
TexturedAtlasQuad *cachedBlobQuad = 0;

void SimpleMobFactory::destroySimpleMob (MANAGERCLASS *manager, Entity *e)
{
	AtlasSprite *r = manager->getComponent <AtlasSprite> (e);
	if (r)
	{

	}
	
	manager->removeEntity(e->_guid);
}

Entity *SimpleMobFactory::createNewSimpleMob(MANAGERCLASS *system, float pos_x, float pos_y)
{
	Entity *e = system->createNewEntity();
	
	Position *pos = system->addComponent <Position> (e);
	pos->x = pos_x;
	pos->y = pos_y;
	pos->scale_x = 4.0;
	pos->scale_y = 4.0;
	
	AtlasSprite *sprite = system->addComponent <AtlasSprite> (e);
	//sprite->sprite = [[CCSprite spriteWithFile: @"Icon.png"] retain];
	
	if (!cachedBlobTex)
	{
		cachedBlobTex = new Texture2D("blobs4.png");
		cachedBlobTex->setAliasTexParams();
	}
	if (!cachedBlobQuad)
	{
		cachedBlobQuad = new TexturedAtlasQuad (cachedBlobTex);
	}
	
	/*sprite->sprite = new TexturedQuad (cachedTex);

	float tex_w = sprite->sprite->w;
	float tex_h = sprite->sprite->h;
	
	sprite->sprite->w = 32.0;
	sprite->sprite->h = 32.0;

	float ffx = (sprite->sprite->w / tex_w);
	float ffy = (sprite->sprite->h / tex_h);
	
	int i_x = 2;
	int i_y = 0;
	
	rect *r = &sprite->sprite->atlasInfo;
	r->x = ffx * i_x;
	r->y = ffy * i_y;
	r->w = ffx;
	r->h = ffy;
	sprite->sprite->isAtlas = true;*/
	
	sprite->sprite = cachedBlobQuad;
	//sprite->sprite->scale = 4.0;
	sprite->z = 0.0;
	rect src = {0.0,0.0,32.0,32.0};
	sprite->src = src;
	
	Name *name = system->addComponent <Name> (e);
	name->name = "Simple Mob";
	
	return e;
}

Entity *SimpleMobFactory::createNewSimpleMob(MANAGERCLASS *system, float pos_x, float pos_y, float vx, float vy)
{
	Entity *e = SimpleMobFactory::createNewSimpleMob(system,pos_x,pos_y);
	Movement *mov = system->addComponent <Movement>(e);
	mov->vx = vx;
	mov->vy = vy;

	return e;
}