/*
 *  GameLogicSystem.cpp
 *  ComponentV3
 *
 *  Created by jrk on 10/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "GameLogicSystem.h"
#include "Texture2D.h"

GameLogicSystem::GameLogicSystem (MANAGERCLASS *entityManager)
{
	_entityManager = entityManager;
}

void GameLogicSystem::handle_player_enemy_collision ()
{
	Entity *player = NULL;
	Position *player_pos = NULL;
	
	std::vector<Entity*>::const_iterator it = _players.begin();
	
	
	//lol how many players can we have? :D
	while (it != _players.end())
	{
		player = *it;
		player_pos = _entityManager->getComponent <Position> (player);
		
		++it;
	}
	
	if (!player)
		return;
	//now rape enemies
	it = _enemies.begin();
	
	Entity *enemy;
	Position *enemy_pos;
	
	float horn_x = player_pos->x + 190 * player_pos->scale;
	float horn_y = player_pos->y + 190 * player_pos->scale;
	
	Enemy *enemy_information = NULL;
	while (it != _enemies.end())
	{
		enemy = *it;
		//_entityManager->dumpEntity(enemy);
		enemy_pos = _entityManager->getComponent <Position> (enemy);
		enemy_information = _entityManager->getComponent <Enemy>(enemy);
		++it;
		
		if (!enemy_pos)
			_entityManager->dumpEntity(enemy);	
		
		//check if the horn is in the enemy
		if (horn_x+2 > enemy_pos->x-16 && horn_x-2 < enemy_pos->x+16 &&
			horn_y+2 > enemy_pos->y-16 && horn_y-2 < enemy_pos->y+16 &&
			!enemy_information->has_been_handled)
		{
			enemy_information->has_been_handled = true;
			
			MoveToAction *mta = new MoveToAction();
			mta->x = enemy_information->origin_x;
			mta->y = enemy_information->origin_y;
			mta->duration = 0.5;
			
			AddComponentAction *aca = new AddComponentAction();
			aca->component_to_add = new MarkOfDeath();
			mta->next_action = aca;
			
			_entityManager->addComponent(enemy, mta);
			
			g_GameState.score += 17;
		}
	}
}

void GameLogicSystem::update (float delta)
{
	_enemies.clear();
	_players.clear();
	
	
	_entityManager->getEntitiesPossessingComponents(_players,  PlayerController::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );
	_entityManager->getEntitiesPossessingComponents(_enemies,  Enemy::COMPONENT_ID,Position::COMPONENT_ID, ARGLIST_END );
	
	_delta = delta;
	
	
	g_GameState.enemies_left = _enemies.size();
	
	if (g_GameState.enemies_left <= 0)
	{
		if (g_GameState.game_state == GAMESTATE_PLAYING_LEVEL &&
			g_GameState.next_state == GAMESTATE_PLAYING_LEVEL)
		{
			g_GameState.next_state = GAMESTATE_WAITING_FOR_WAVE;
		}
	}
	
	
	if (_players.size() == 0 || _enemies.size() == 0)
		return;
	
	
	handle_player_enemy_collision();
	
	
}