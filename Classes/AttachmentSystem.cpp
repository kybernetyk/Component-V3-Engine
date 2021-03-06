/*
 *  AttachementController.cpp
 *  ComponentV3
 *
 *  Created by jrk on 8/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "Util.h"
#include "AttachmentSystem.h"
namespace mx3 
{
	
		
	AttachmentSystem::AttachmentSystem (EntityManager *entityManager)
	{
		_entityManager = entityManager;
	}

	void AttachmentSystem::update (float delta)
	{
		std::vector<Entity*> entities;
		
		_entityManager->getEntitiesPossessingComponents(entities,  Attachment::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );
		std::vector<Entity*>::const_iterator it = entities.begin();
		
		Entity *current_entity = NULL;
		Entity *attached_to_entity = NULL;
		Position *current_pos = NULL;
		Position *attached_to_pos = NULL;
		Attachment *current_attachment = NULL;
		while (it != entities.end())
		{ 
			current_entity = *it;
			current_attachment = _entityManager->getComponent <Attachment> (current_entity);
			attached_to_entity = _entityManager->getEntity( current_attachment->targetEntityID );
			if (!attached_to_entity)
			{
				++it;

				printf("\n\n** couldn't find entity referenced by attachment: %s\n", current_attachment->toString().c_str());
				printf("removing the errornous attachment ...\n");
				
				printf("current_entity:");
				_entityManager->dumpEntity(current_entity);
				printf("removing the errornous attachment ...\n");
				_entityManager->removeComponent <Attachment> (current_entity);
				printf("current_entity looks now like:");
				_entityManager->dumpEntity(current_entity);
				
				
				continue;
			}
			if (attached_to_entity->checksum != current_attachment->entityChecksum)
			{
				++it;
				
				printf("\n\n ** attachment's checksum != presented entitie's checksum. (AttachmentSystem.cpp update())\n");
				printf("current_entity:");
				_entityManager->dumpEntity(current_entity);
				printf("\n\n(wrongfully!) attached_to_entity:");
				_entityManager->dumpEntity(attached_to_entity);
				printf("removing the errornous attachment ...\n");
				_entityManager->removeComponent <Attachment> (current_entity);
				printf("current_entity looks now like:");
				_entityManager->dumpEntity(current_entity);
				
				continue;
			}
			
			current_pos = _entityManager->getComponent <Position> (current_entity);
			attached_to_pos = _entityManager->getComponent <Position> (attached_to_entity);
					
			current_pos->x = attached_to_pos->x + current_attachment->offset_x;
			current_pos->y = attached_to_pos->y + current_attachment->offset_y;
			
			++it;
		}
	}

}