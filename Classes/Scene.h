/*
 *  Game.h
 *  SpaceHike
 *
 *  Created by jrk on 6/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once
#include "Texture2D.h"
#include "TexturedQuad.h"
#include "EntityManager.h"
#include "RenderSystem.h"
#include "MovementSystem.h"
#include "PlayerControlledSystem.h"
#include "AttachmentSystem.h"
#include "ActionSystem.h"
#include "GameLogicSystem.h"
#include "CorpseRetrievalSystem.h"
#include "HUDSystem.h"

class Scene
{
public:
	virtual void init ();
	virtual void end ();
	
	virtual void update (float delta);
	virtual void render (float interpolation);
	
	virtual void frameDone ();

	void spawnEnemies ();
	
protected:
	bool _isRunning;
	
	MANAGERCLASS *_entityManager;
	RenderSystem *_renderSystem;
	MovementSystem *_movementSystem;
	PlayerControlledSystem *_playerControlledSystem;
	AttachmentSystem *_attachmentSystem;
	ActionSystem *_actionSystem;
	GameLogicSystem *_gameLogicSystem;
	CorpseRetrievalSystem *_corpseRetrievalSystem;	
	HUDSystem *_hudSystem;
	
	Entity *red_blob;
	Entity *green_blob;
	Entity *blue_blob;

};

