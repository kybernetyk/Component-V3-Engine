/*
 *  Game.cpp
 *  SpaceHike
 *
 *  Created by jrk on 6/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "Scene.h"
#include "InputDevice.h"
#include "Entity.h"

#include "EntityManager.h"
#include "Component.h"

#include "RenderSystem.h"
#include "MovementSystem.h"
#include "SimpleMob.h"
#include "HUDSystem.h"

void Scene::spawnEnemies ()
{
	for (int j = 1; j < 4; j++)
	{
		Entity *mob = red_blob;
		
		if (j % 2 == 0)
			mob = green_blob;
		
		if (j % 3 == 0)
			mob = blue_blob;
		
		//this is the fast way to do (for stuff that has to be done every frame)
		//		Position *pos = _entityManager->getComponent <Position> (mob);
		//		int atlas_x = _entityManager->getComponent <Sprite> (mob)->sprite->atlas_frame_index_x;
		//		int atlas_y = _entityManager->getComponent <Sprite> (mob)->sprite->atlas_frame_index_y;
		
		//this is the slower(3 method calls), convinient way (for initialization, building, stuff that doesn't happen every frame)
		Position *pos = mob->get<Position>();
		//int atlas_x = mob->get<Sprite>()->sprite->atlas_frame_index_x;;
		//int atlas_y = mob->get<Sprite>()->sprite->atlas_frame_index_y;
		
		for (int i = 0; i < 100; i++)
		{
			Entity *blob = SimpleMobFactory::createNewSimpleMob(_entityManager, pos->x, pos->y);
			
			blob->get<Position>()->scale = 1.0;
			
			//Renderable *r = mob->getComponent<Renderable>();
			//	_entityManager->getComponent <Sprite> (blob)->sprite->atlas_frame_index_x = atlas_x;
			//	_entityManager->getComponent <Sprite> (blob)->sprite->atlas_frame_index_y = atlas_y;
			
			blob->get<Sprite>()->sprite->src = mob->get<Sprite>()->sprite->src;
			
			Enemy *enemy = _entityManager->addComponent <Enemy> (blob);
			enemy->origin_x = pos->x;
			enemy->origin_y = pos->y;
			
			Sprite *r =	_entityManager->getComponent<Sprite>(blob);
			r->z = rand()%6;
			
			//MoveByAction *actn = _entityManager->addComponent <MoveByAction> (mob);
			MoveToAction *actn = _entityManager->addComponent <MoveToAction> (blob);
			
			actn->x = (rand()%(480-32))+16;
			actn->y = (rand()%(320-32))+16;
			
			
			actn->duration = 2.5;
			
			r->sprite->alpha = 0.5;
			g_GameState.enemies_left ++;
		}
		
	}
	
}

void Scene::init ()
{
	_isRunning = true;
	srand(time(0));

	g_GameState.game_state = GAMESTATE_WAITING_FOR_WAVE;
	g_GameState.next_state = GAMESTATE_WAITING_FOR_WAVE;
	
	_entityManager = new MANAGERCLASS;
	_renderSystem = new RenderSystem (_entityManager);
	_movementSystem = new MovementSystem (_entityManager);
	_playerControlledSystem = new PlayerControlledSystem (_entityManager);
	_attachmentSystem = new AttachmentSystem (_entityManager);
	_actionSystem = new ActionSystem (_entityManager);
	_gameLogicSystem = new GameLogicSystem (_entityManager);
	_corpseRetrievalSystem = new CorpseRetrievalSystem (_entityManager);
	_hudSystem = new HUDSystem (_entityManager);
	

	/* create background */	
	Entity *bg = _entityManager->createNewEntity();
	Position *pos = _entityManager->addComponent <Position> (bg);
	Sprite *sprite = _entityManager->addComponent <Sprite> (bg);
	sprite->sprite = new TexturedQuad("bg.png");
	sprite->sprite->texture->setAliasTexParams();
	sprite->sprite->anchorPoint.x = 0.0;
	sprite->sprite->anchorPoint.y = 0.0;
	sprite->z = -5.0;
	
	Name *name = _entityManager->addComponent <Name> (bg);
	name->name = "Game Background";

	// 3 blobs
	rect src = {2 * 32.0, 0 * 32.0, 32.0,32.0};
	green_blob = SimpleMobFactory::createNewSimpleMob(_entityManager, 240,160);
	_entityManager->getComponent <Sprite> (green_blob)->sprite->src = src;
	rect src2 = {2 * 32.0, 2 * 32.0, 32.0,32.0};	
	red_blob = SimpleMobFactory::createNewSimpleMob(_entityManager, 240-128,160);
	_entityManager->getComponent <Sprite> (red_blob)->sprite->src = src2;
	rect src3 = {0 * 32.0, 1 * 32.0, 32.0,32.0};		
	blue_blob = SimpleMobFactory::createNewSimpleMob(_entityManager, 240+128,160);
	_entityManager->getComponent <Sprite> (blue_blob)->sprite->src = src3;

	
		
	//PLAYER ENTITY
	Entity *player = _entityManager->createNewEntity();
	_entityManager->addComponent <PlayerController> (player);
	pos = _entityManager->addComponent <Position> (player);
	pos->x = 0;
	pos->y = 0;
	pos->scale = 0.5;
	sprite = _entityManager->addComponent <Sprite> (player);	
	sprite->sprite = new TexturedQuad("das_minyx.png");
	sprite->z = 3.0;
	//sprite->sprite->scale = 0.5;
	sprite->sprite->texture->setAliasTexParams();
	
	name = _entityManager->addComponent <Name> (player);
	name->name = "Player Figure";
	
	g_GameState.score = 0;
	
	
	
		
	_entityManager->dumpEntityCount();
	
}

void Scene::end ()
{

}

void Scene::update (float delta)
{
	InputDevice::sharedInstance()->update();

	if (g_GameState.game_state != g_GameState.next_state)
	{
		g_GameState.game_state = g_GameState.next_state;
		
		if (g_GameState.game_state == GAMESTATE_PLAYING_LEVEL)
		{
			spawnEnemies();
		}
		
	}
	
	
	_playerControlledSystem->update(delta);
	_actionSystem->update(delta);
	_movementSystem->update(delta);
	_attachmentSystem->update(delta);
	_gameLogicSystem->update(delta);
	_hudSystem->update(delta);
	_corpseRetrievalSystem->collectCorpses();
}

void Scene::render (float interpolation)
{
	_renderSystem->render();

}

void Scene::frameDone ()
{
	_entityManager->setIsDirty (false);
}