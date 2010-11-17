/*
 *  GameComponens.h
 *  ComponentV3
 *
 *  Created by jrk on 16/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once

#include "Component.h"

using namespace mx3;
namespace game
{
#pragma mark -
#pragma mark game 
	struct PlayerController : public Component
	{
		static ComponentID COMPONENT_ID;
		
		PlayerController ()
		{
			_id = COMPONENT_ID;
		}
		
		DEBUGINFO ("Player Controller")
	};
	
	struct Enemy : public Component
	{
		static ComponentID COMPONENT_ID;
		
		bool has_been_handled;
		float origin_x;
		float origin_y;
		
		Enemy ()
		{
			_id = COMPONENT_ID;
			has_been_handled = false;
			origin_x = origin_y = 0.0;
		}
		
		DEBUGINFO ("Enemy. has_been_handled: %i origin_x: %f origin_y: %f", has_been_handled, origin_x, origin_y)
	};

}
