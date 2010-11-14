/*
 *  AnimationSystem.h
 *  ComponentV3
 *
 *  Created by jrk on 14/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once
#include <vector>
#include "EntityManager.h"
#include "Entity.h"

class AnimationSystem
{
public:
	AnimationSystem (MANAGERCLASS *entityManager);
	void update (float delta);	
	
protected:
	MANAGERCLASS *_entityManager;
	std::vector<Entity*> _entities;
};

