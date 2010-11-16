/*
 *  SimpleMob.h
 *  components
 *
 *  Created by jrk on 5/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once
#import "types.h"
#include "Entity.h"
#include "EntityManager.h"

class SimpleMobFactory
{
public:
	static Entity *createNewSimpleMob(EntityManager *system, float pos_x, float pos_y);
	static Entity *createNewSimpleMob(EntityManager *system, float pos_x, float pos_y, float vx, float vy);
	static void destroySimpleMob (EntityManager *manager, Entity *e);
	
};

