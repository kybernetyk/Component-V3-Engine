/*
 *  RenderSystem.cpp
 *  components
 *
 *  Created by jrk on 5/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#import "RenderSystem.h"
#import "EntityManager.h"
#import "Component.h"
#import "Entity.h"

RenderSystem::RenderSystem (MANAGERCLASS *entityManager)
{
	_entityManager = entityManager;
}

/*
bool blah (Entity *i,Entity *j)
{
	Renderable *ren1 = i->getComponentCached<Renderable>();
	Renderable *ren2 = j->getComponentCached<Renderable>();
	
	return (ren1->z < ren2->z);
	
}*/

bool blah3 (IRenderable *q1, IRenderable *q2)
{
	//ok, if both z's are equal the outome of the sort is undefined 
	//and renderables with the same z value might switch render position every re-sort
	//<strike>so we let the memory address decide which renderable to render first (the memory address shouldn't change)</strike>
	//the guid it is
	if (q1->z == q2->z)
		return (q1->_guid < q2->_guid);
	
	return (q1->z < q2->z);
	
}

void RenderSystem::render (void)
{
	bool isdirty = _entityManager->isDirty();
	if (isdirty)
	{
		//printf("is dirty!\n");
		
		//invalidate cached values and get new stuff
		gl_data.clear();
		moveableList.clear();
		_entityManager->getEntitiesPossessingComponents (moveableList, Position::COMPONENT_ID, Renderable::COMPONENT_ID, ARGLIST_END);
	}
	
	
	std::vector<Entity*>::const_iterator it = moveableList.begin();

	Entity *current_entity = NULL;
	Position *pos = NULL;
	Renderable *ren = NULL;
	//IRenderable *gl_object = NULL;
	
	Sprite *sprite = NULL;
	TextLabel *label = NULL;

	TexturedQuad *textured_quad = NULL;
	OGLFont *font = NULL;
	
	while (it != moveableList.end())
	{
		current_entity = *it;
		
		pos = _entityManager->getComponent<Position>(current_entity);
		ren = _entityManager->getComponent<Renderable>(current_entity);
		
		if (ren->_renderable_type == RENDERABLETYPE_SPRITE)
		{
			sprite = (Sprite*)ren;
			
			textured_quad = sprite->sprite;
			textured_quad->x = pos->x;
			textured_quad->y = pos->y;
			textured_quad->z = ren->z;
			textured_quad->scale = pos->scale;
			textured_quad->rotation = pos->rot;
			
			if (isdirty)
				gl_data.push_back (textured_quad);
			
			++it;
			continue;
		}
		
		if (ren->_renderable_type == RENDERABLETYPE_TEXT)
		{
			label = (TextLabel*)ren;
			font = label->ogl_font;
			font->x = pos->x;
			font->y = pos->y;
			font->z = ren->z;
			font->rotation = pos->rot;
			font->scale = pos->scale;
			
			font->text = (char*)label->text.c_str();
			
			if (isdirty)
				gl_data.push_back (font);
			
			++it;
			continue;
		}
		
		printf("unhandled render!\n");
		
		++it;
	}

	if (isdirty)
	{	
		std::sort (gl_data.begin(), gl_data.end(), blah3); 	
	}
	
	std::vector<IRenderable *>::const_iterator it2 = gl_data.begin();
	while (it2 != gl_data.end())
	{
		(*it2)->renderContent();
		++it2;
	}
	
//	printf("i: %i\n",i);
	
}

