/*
 *  RenderSystem.h
 *  components
 *
 *  Created by jrk on 5/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once
#include <vector>
#include "EntityManager.h"


class TexturedQuad;
class IRenderable;


class RenderSystem
{
public:
	RenderSystem (MANAGERCLASS *entityManager);
	void render (void);	
	void refreshCaches ();

protected:
	MANAGERCLASS *_entityManager;
	
	std::vector <IRenderable *> gl_data;
	std::vector<Entity*> moveableList;
};
