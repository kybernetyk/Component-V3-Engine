/*
 *  ActionSystem.h
 *  ComponentV3
 *
 *  Created by jrk on 8/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once

#include <vector>
#include "EntityManager.h"

class ActionSystem
{
public:
	ActionSystem (MANAGERCLASS *entityManager);
	void update (float delta);	
	
	
protected:

	
	void setupNextActionOrStop (Entity *e,Action *current_action);
	
	MANAGERCLASS *_entityManager;
	
	std::vector<Entity*> _entities;
};


