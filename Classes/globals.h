/*
 *  globals.h
 *  ComponentV3
 *
 *  Created by jrk on 11/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once

typedef struct GameState
{
	int score;
	
	int enemies_left;
	
	
	int game_state;
	int next_state;
	
	int level;
	
	int experience;
	int experience_needed_to_levelup;
	
} GameState;

#define GAMESTATE_WAITING_FOR_WAVE 0
#define GAMESTATE_PLAYING_LEVEL 1

extern GameState g_GameState;