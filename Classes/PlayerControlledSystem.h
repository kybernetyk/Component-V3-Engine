/*
 *  PlayerControlledSystem.h
 *  ComponentV3
 *
 *  Created by jrk on 8/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once
#include <vector>
#include "EntityManager.h"

class PlayerControlledSystem
{
public:
	PlayerControlledSystem (MANAGERCLASS *entityManager);
	void update (float delta);	
protected:
	MANAGERCLASS *_entityManager;
};

