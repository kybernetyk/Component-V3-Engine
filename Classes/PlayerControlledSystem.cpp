/*
 *  PlayerControlledSystem.cpp
 *  ComponentV3
 *
 *  Created by jrk on 8/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "Util.h"
#include "PlayerControlledSystem.h"
#include "InputDevice.h"

PlayerControlledSystem::PlayerControlledSystem (MANAGERCLASS *entityManager)
{
	_entityManager = entityManager;
}

void PlayerControlledSystem::update (float delta)
{
	vector2D v;
	
	if (InputDevice::sharedInstance()->touchUpReceived())
		v = InputDevice::sharedInstance()->touchLocation();
	 else
		return;
	
	
	std::vector<Entity*> entities;
	
	_entityManager->getEntitiesPossessingComponents(entities,  PlayerController::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );
	std::vector<Entity*>::const_iterator it = entities.begin();
	
	Entity *current_entity = NULL;
	Position *pos = NULL;
	while (it != entities.end())
	{
		current_entity = *it;
		
		Action *a = _entityManager->getComponent <Action> (current_entity);
		if (a)
		{
			printf("already runnign an action!");
			
			if (!a->may_be_aborted)
			{
				printf("may be not aborted!\n");
				
				++it;
				continue;
			}
		}
			
		
		MoveToAction *actn = _entityManager->addComponent <MoveToAction> (current_entity);
		actn->x = v.x-105;
		actn->y = v.y-95;
		actn->duration = 0.5;
		actn->may_be_aborted = false;

		MoveToAction *actn3 = new MoveToAction();
		actn3->x = 0;
		actn3->y = 0;
		actn3->duration = 0.5;
		actn3->may_be_aborted = false;
		
		actn->next_action = actn3;
		
		
		
	/*	MoveByAction *actn2 = new MoveByAction();
		actn2->x = 100;
		actn2->y = -100;
		actn2->duration = 2.0;
		
		MoveToAction *actn3 = new MoveToAction();
		actn3->x = 0;
		actn3->y = 0;
		actn3->duration = 2.0;
		
		actn->next_action = actn2;
		actn2->next_action = actn3;*/
		
		++it;
	}
}