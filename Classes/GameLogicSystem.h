/*
 *  GameLogicSystem.h
 *  ComponentV3
 *
 *  Created by jrk on 10/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#pragma once
#include <vector>
#include "EntityManager.h"

class GameLogicSystem
{
public:
	GameLogicSystem (MANAGERCLASS *entityManager);
	void update (float delta);
	void refreshCaches ();
	
protected:
	void handle_player_enemy_collision ();
	void check_player_for_levelup ();
	
	void restoreGameStateFromFile();
	void saveGameStateToFile();
	
	std::vector<Entity*> _enemies;
	std::vector<Entity*> _players;
	float _delta;
	
	MANAGERCLASS *_entityManager;
	
};

