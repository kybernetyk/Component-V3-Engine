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
#include "globals.h"

void Scene::spawnEnemies ()
{

	MoveToAction *mt = new MoveToAction();
	mt->x = -40.0;
	mt->y = 0.0;
	mt->duration = 0.5;
	_entityManager->addComponent(player, mt);
	
	Action *idle = new Action();
	idle->duration = 2.0;
	mt->next_action = idle;
	
	MoveToAction *mt2 = new MoveToAction();
	mt2->x = 0.0;
	mt2->y = 40.0;
	mt2->duration = 0.5;
	idle->next_action = mt2;
	
	AddComponentAction *aca = new AddComponentAction();
	aca->component_to_add = new PlayerController();
	mt2->next_action = aca;
	
	
	_entityManager->removeComponent(player, PlayerController::COMPONENT_ID);
	
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
			
			blob->get<Position>()->scale_x = 1.0;
			blob->get<Position>()->scale_y = 1.0;
			
			//Renderable *r = mob->getComponent<Renderable>();
			//	_entityManager->getComponent <Sprite> (blob)->sprite->atlas_frame_index_x = atlas_x;
			//	_entityManager->getComponent <Sprite> (blob)->sprite->atlas_frame_index_y = atlas_y;
			
			blob->get<AtlasSprite>()->src = mob->get<AtlasSprite>()->src;
						
			Enemy *enemy = _entityManager->addComponent <Enemy> (blob);
			enemy->origin_x = pos->x;
			enemy->origin_y = pos->y;
			
			AtlasSprite *r =	_entityManager->getComponent<AtlasSprite>(blob);
			r->z = rand()%6;
			r->alpha = 0.5;
			
			//MoveByAction *actn = _entityManager->addComponent <MoveByAction> (mob);
			MoveToAction *actn = _entityManager->addComponent <MoveToAction> (blob);
			
			actn->x = (rand()%(480-32))+16;
			actn->y = (rand()%(320-32-40))+16+40;
			
			
			actn->duration = 2.5;
			

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
	
	_entityManager = new EntityManager;
	_renderSystem = new RenderSystem (_entityManager);
	_movementSystem = new MovementSystem (_entityManager);
	_playerControlledSystem = new PlayerControlledSystem (_entityManager);
	_attachmentSystem = new AttachmentSystem (_entityManager);
	_actionSystem = new ActionSystem (_entityManager);
	_gameLogicSystem = new GameLogicSystem (_entityManager);
	_corpseRetrievalSystem = new CorpseRetrievalSystem (_entityManager);
	_hudSystem = new HUDSystem (_entityManager);
	_soundSystem = new SoundSystem (_entityManager);
	_animationSystem = new AnimationSystem (_entityManager);
	
	_soundSystem->playMusic(MUSIC_GAME);

	/* create background */	
	Entity *bg = _entityManager->createNewEntity();
	Position *pos = _entityManager->addComponent <Position> (bg);
	Sprite *sprite = _entityManager->addComponent <Sprite> (bg);
	sprite->quad = g_RenderableManager.accquireTexturedQuad ("bg.png");
	sprite->anchorPoint = vector2D_make(0.0, 0.0);
	sprite->z = -5.0;
	
	Name *name = _entityManager->addComponent <Name> (bg);
	name->name = "Game Background";

	// 3 blobs
	green_blob = SimpleMobFactory::createNewSimpleMob(_entityManager, 240,160+20);
	_entityManager->getComponent <AtlasSprite> (green_blob)->src = rect_make(2*32.0, 0*32.0, 32.0, 32.0);

	
	red_blob = SimpleMobFactory::createNewSimpleMob(_entityManager, 240-128,160+20);
	_entityManager->getComponent <AtlasSprite> (red_blob)->src = rect_make(2*32.0,2*32.0,32.0,32.0);

	
	blue_blob = SimpleMobFactory::createNewSimpleMob(_entityManager, 240+128,160+20);
	_entityManager->getComponent <AtlasSprite> (blue_blob)->src = rect_make(0*32.0, 1*32.0, 32.0, 32.0);


	
	_entityManager->addComponent<Name>(green_blob)->name = "green_blob";
	_entityManager->addComponent<Name>(red_blob)->name = "red_blob";
	_entityManager->addComponent<Name>(blue_blob)->name = "blue_blob";

	
	//PLAYER ENTITY
	player = _entityManager->createNewEntity();
	_entityManager->addComponent <PlayerController> (player);
	pos = _entityManager->addComponent <Position> (player);
	pos->x = 0;
	pos->y = 60;
	pos->scale_x = 0.5;
	pos->scale_y = 0.5;

	sprite = _entityManager->addComponent <Sprite> (player);	
	sprite->quad = g_RenderableManager.accquireTexturedQuad ("das_minyx.png");
	sprite->z = 3.0;
	
	name = _entityManager->addComponent <Name> (player);
	name->name = "Player Figure";
	
	
	//Animation test
/*		Entity *anim = _entityManager->createNewEntity();
	
	
	AtlasSprite *atlas_sprite = _entityManager->addComponent <AtlasSprite> (anim);
	atlas_sprite->atlas_quad = g_RenderableManager.accquireTexturedAtlasQuad ("anims.png");
	atlas_sprite->src = rect_make(0.0, 0.0, 32.0, 32.0);
	atlas_sprite->z = 9.0;
	
	pos = _entityManager->addComponent<Position>(anim);
	pos->x = 480/2;
	pos->y = 320/2;
	
	FrameAnimation *frame_animation = _entityManager->addComponent <FrameAnimation> (anim);
	frame_animation->frame_size = rect_make(0.0, 0.0, 32.0, 32.0);
	frame_animation->frames_per_second = 24;
	frame_animation->speed_scale = 1.0;
	frame_animation->start_frame = 31;
	frame_animation->end_frame = 0;
	frame_animation->current_frame = frame_animation->start_frame;
	frame_animation->state = ANIMATION_STATE_PLAY;
	frame_animation->loop = true;
	frame_animation->destroy_on_finish = false;
	_entityManager->dumpEntityCount();


	
	anim = _entityManager->createNewEntity();
	
	atlas_sprite = _entityManager->addComponent <AtlasSprite> (anim);
	atlas_sprite->atlas_quad = g_RenderableManager.accquireTexturedAtlasQuad ("anims.png");
	atlas_sprite->src = rect_make(0.0, 0.0, 32.0, 32.0);
	atlas_sprite->z = 9.0;
	
	pos = _entityManager->addComponent<Position>(anim);
	pos->x = 480/2+64;
	pos->y = 320/2;
	
	frame_animation = _entityManager->addComponent <FrameAnimation> (anim);
	frame_animation->frame_size = rect_make(0.0, 0.0, 32.0, 32.0);
	frame_animation->frames_per_second = 24;
	frame_animation->speed_scale = 1.0;
	frame_animation->start_frame = 0;
	frame_animation->end_frame = 63;
	frame_animation->current_frame = frame_animation->start_frame;
	frame_animation->state = ANIMATION_STATE_PLAY;
	frame_animation->loop = true;
	frame_animation->destroy_on_finish = false;

	
	
	_entityManager->dumpEntityCount();
	*/
	
}

void Scene::end ()
{

}

void Scene::update (float delta)
{
	InputDevice::sharedInstance()->update();

	//we must collect the corpses from the last frame
	//as the entity-manager's isDirty property is reset each frame
	//so if we did corpse collection at the end of update
	//the systems wouldn't know that the manager is dirty 
	//and a shitstorm of dangling references would rain down on them
	_corpseRetrievalSystem->collectCorpses();
	
	
	
	
	_playerControlledSystem->update(delta);
	_actionSystem->update(delta);
	_movementSystem->update(delta);
	_attachmentSystem->update(delta);
	_animationSystem->update(delta);
	_gameLogicSystem->update(delta);
	_hudSystem->update(delta);
	_soundSystem->update(delta);
	

	if (g_GameState.game_state != g_GameState.next_state)
	{
		g_GameState.game_state = g_GameState.next_state;
		
		if (g_GameState.game_state == GAMESTATE_PLAYING_LEVEL)
		{
			spawnEnemies();
		}
		
	}
	
	
	
	
}

void Scene::render (float interpolation)
{
	_renderSystem->render();

}

void Scene::frameDone ()
{
	_entityManager->setIsDirty (false);
}