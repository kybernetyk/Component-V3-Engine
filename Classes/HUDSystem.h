/*
 *  HUDSystem.h
 *  ComponentV3
 *
 *  Created by jrk on 12/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once
#include <vector>
#include "EntityManager.h"

class HUDSystem
{
public:
	HUDSystem (MANAGERCLASS *entityManager);
	void update (float delta);
	void refreshCaches ();
	
protected:
	MANAGERCLASS *_entityManager;
	Entity *hud_img;
	Entity *xp_bar;
	Entity *score_ui;
	Entity *xp_ui;
	Entity *level_ui;
	
	bool kawaii_showing;
	float kawaii_countdown;
	
	Entity *kawaii_or_fail;
	Entity *next_wave_label;
	


};

