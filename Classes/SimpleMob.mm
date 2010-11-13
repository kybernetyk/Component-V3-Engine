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
	if (!cachedBlobTex)
	{
		cachedBlobTex = new Texture2D("blobs4.png");
		cachedBlobTex->setAliasTexParams();
	}
	if (!cachedBlobQuad)
	{
		cachedBlobQuad = new TexturedAtlasQuad (cachedBlobTex);
	}
	
	
	Entity *e = system->createNewEntity();
	
	Position *pos = system->addComponent <Position> (e);
	pos->x = pos_x;
	pos->y = pos_y;
	pos->scale_x = 4.0;
	pos->scale_y = 4.0;
	
	AtlasSprite *sprite = system->addComponent <AtlasSprite> (e);
	sprite->atlas_quad = cachedBlobQuad;
	sprite->z = 0.0;
	sprite->src = rect_make(0.0, 0.0, 32.0, 32.0);
	
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