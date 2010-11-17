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
#include "Timer.h"
using namespace mx3;

namespace game 
{

	class HUDSystem
	{
	public:
		HUDSystem (EntityManager *entityManager);
		void update (float delta);
		
	protected:
		EntityManager *_entityManager;
		Entity *hud_img;
		Entity *xp_bar;
		Entity *score_ui;
		Entity *xp_ui;
		Entity *level_ui;
		
		bool kawaii_showing;
		float kawaii_countdown;
		
		bool lvlup_showing;
		float lvlup_countdown;
		
		Entity *kawaii_or_fail;
		Entity *next_wave_label;
		Entity *lvlup_graphic;
		
		int cached_level;

		Entity *fps_label;

		OGLFont *font;
	};


}