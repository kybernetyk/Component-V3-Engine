/*
 *  MovementSystem.h
 *  components
 *
 *  Created by jrk on 5/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once
#include <vector>
#include "EntityManager.h"
#include "Entity.h"

class MovementSystem
{
public:
	MovementSystem (MANAGERCLASS *entityManager);
	void update (float delta);	
protected:
	MANAGERCLASS *_entityManager;
	std::vector<Entity*> moveableList;
};

