/*
 *  AttachementController.h
 *  ComponentV3
 *
 *  Created by jrk on 8/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once
#include <vector>
#include "EntityManager.h"

class AttachmentSystem
{
public:
	AttachmentSystem (MANAGERCLASS *entityManager);
	void update (float delta);	
	void refreshCaches ();

protected:
	MANAGERCLASS *_entityManager;
};

