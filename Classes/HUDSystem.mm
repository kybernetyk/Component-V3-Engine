/*
 *  HUDSystem.cpp
 *  ComponentV3
 *
 *  Created by jrk on 12/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "HUDSystem.h"
#include "Texture2D.h"
#include "SoundSystem.h"

HUDSystem::HUDSystem (MANAGERCLASS *entityManager)
{
	_entityManager = entityManager;

	kawaii_showing = false;
	kawaii_or_fail = NULL;

	hud_img = _entityManager->createNewEntity();
	_entityManager->addComponent<Position>(hud_img);
	Sprite *sprite = _entityManager->addComponent <Sprite> (hud_img);
	sprite->sprite = new TexturedQuad ("hud.png");
	sprite->sprite->anchorPoint.x = 0.0;
	sprite->sprite->anchorPoint.y = 0.0;
	sprite->z = 5.5;
	_entityManager->addComponent<Name>(hud_img)->name = "hud_img";


	
	xp_bar = _entityManager->createNewEntity();
	_entityManager->addComponent<Name>(xp_bar)->name = "xp_bar";

	Position *pos = _entityManager->addComponent <Position> (xp_bar);
	pos->y = 32.0;
	sprite = _entityManager->addComponent<Sprite>(xp_bar);
	sprite->sprite = new TexturedQuad("xp_bar.png");
	sprite->sprite->anchorPoint.x = 0.0;
	sprite->sprite->anchorPoint.y = 0.0;
	sprite->z = 5.6;
	
	score_ui = _entityManager->createNewEntity();
	_entityManager->addComponent<Name>(score_ui)->name = "score_ui";

	_entityManager->addComponent <Position> (score_ui);
	TextLabel *label = _entityManager->addComponent <TextLabel> (score_ui);
	label->ogl_font = new OGLFont("zomg.fnt");
	label->ogl_font->anchorPoint.x = 0.0;
	label->ogl_font->anchorPoint.y = 0.0;
	label->text = "Score: 0";
	score_ui->get<Position>()->x = 0.0;
	score_ui->get<Position>()->y = 2;
	label->z = 6.0;
	score_ui->get<Position>()->scale_x = 0.4;	
	score_ui->get<Position>()->scale_y = 0.4;
	
	xp_ui = _entityManager->createNewEntity();
	_entityManager->addComponent<Name>(xp_ui)->name = "xp_ui";

	_entityManager->addComponent <Position> (xp_ui);
	label = _entityManager->addComponent<TextLabel> (xp_ui);
	label->ogl_font = new OGLFont("zomg.fnt");
	label->ogl_font->anchorPoint.x = 1.0;
	label->ogl_font->anchorPoint.y = 0.0;
	label->text = "Xp: 0/0";
	xp_ui->get<Position>()->x = 480;
	xp_ui->get<Position>()->y = 2;
	label->z = 6.0;
	xp_ui->get<Position>()->scale_x = 0.4;
	xp_ui->get<Position>()->scale_y = 0.4;
	
	level_ui = _entityManager->createNewEntity();
	_entityManager->addComponent<Name>(level_ui)->name = "level_ui";
	
	_entityManager->addComponent <Position> (level_ui);
	label = _entityManager->addComponent<TextLabel> (level_ui);
	label->ogl_font = new OGLFont("zomg.fnt");
	label->ogl_font->anchorPoint.x = 0.5;
	label->ogl_font->anchorPoint.y = 0.0;
	label->text = "Level: 0";
	level_ui->get<Position>()->x = 480/2;
	level_ui->get<Position>()->y = 2;
	label->z = 6.0;
	level_ui->get<Position>()->scale_x = 0.4;
	level_ui->get<Position>()->scale_y = 0.4;
	
	Texture2D *loltex = new Texture2D("lolsheet.png");
	
	//LOLSHEET
	kawaii_or_fail = _entityManager->createNewEntity();
	_entityManager->addComponent<Name>(kawaii_or_fail)->name = "kawaii_or_fail";
	
	_entityManager->addComponent <Position> (kawaii_or_fail);
	kawaii_or_fail->get<Position>()->x = 480+200;
	kawaii_or_fail->get<Position>()->y = 320/2+20;
	
	_entityManager->addComponent <Sprite> (kawaii_or_fail);
	kawaii_or_fail->get<Sprite>()->sprite = new TexturedQuad(loltex,0,0,296,64);
	kawaii_or_fail->get<Sprite>()->z = 9.0;
	
	
	//next wave
	next_wave_label = _entityManager->createNewEntity();
	_entityManager->addComponent<Name>(next_wave_label)->name = "next_wave_label";

	_entityManager->addComponent <Position> (next_wave_label);
	next_wave_label->get<Position>()->x = 400+480/2;
	next_wave_label->get<Position>()->y = 320/2-20;
	next_wave_label->get<Position>()->scale_x = 0.5;
	next_wave_label->get<Position>()->scale_y = 0.5;
	
	label = _entityManager->addComponent <TextLabel> (next_wave_label);
	label->ogl_font = new OGLFont("zomg.fnt");
	label->z = 9.0;
	label->text = "Next wave in 5 ...";
	
}

Action *flyin_and_shake_action ()
{
	MoveToAction *actn = new MoveToAction;
	actn->duration = 0.3;
	actn->x = 480/2-10;
	actn->y = 320/2+20;
	
	Action *prev_actn = actn;
	int max = 10;
	for (int i = 0; i < max; i++)
	{
		MoveByAction *mb = new MoveByAction;
		mb->duration = 0.05;
		
		if (i % 2 == 0)
			mb->x = (max-i)*2;
		else
			mb->x = -(max-i)*2;
		
		prev_actn->next_action = mb;
		prev_actn = mb;
	}
	

	return actn;
}

Action *flyout_and_reset_action ()
{
	MoveToAction *actn = new MoveToAction;
	actn->duration = 0.3;
	actn->x = -400;
	actn->y = 320/2+20;
	
	MoveByAction *mb = new MoveByAction;
	mb->x = 0.0;
	mb->y = 400;
	mb->duration = 0.0;
	actn->next_action = mb;
	
	MoveByAction *mb2 = new MoveByAction;
	mb2->x = 400+480+200;
	mb2->y = 0;
	mb2->duration = 0.0;
	mb->next_action = mb2;
	
	MoveToAction *mb3 = new MoveToAction;
	mb3->x = 480+200;
	mb3->y = 320/2+20;
	mb3->duration = 0.0;
	mb2->next_action = mb3;

	return actn;
}


void HUDSystem::update (float delta)
{
	char s[255];
	sprintf(s,"Score: %i", g_GameState.score);
	score_ui->get<TextLabel>()->text = s;
	
	sprintf(s, "XP: %i/%i", g_GameState.experience, g_GameState.experience_needed_to_levelup);
	xp_ui->get<TextLabel>()->text = s;
	
	sprintf(s, "Level: %i", g_GameState.level);
	level_ui->get<TextLabel>()->text = s;
	
	float sx = (1.0/g_GameState.experience_needed_to_levelup) * g_GameState.experience;
	
	xp_bar->get<Position>()->scale_x = sx;
	
	if (g_GameState.game_state != GAMESTATE_WAITING_FOR_WAVE)
		return;
	
	kawaii_countdown -= delta;
	
	//printf("enemies: %i\n", g_GameState.enemies_left);
	
	if (kawaii_countdown >= 0.0)
	{	
		char s[255];
		sprintf(s,"Next wave in %.2f ...",kawaii_countdown );
		next_wave_label->get<TextLabel>()->text = s;
	}
	
	
	if (!kawaii_showing)
	{
		kawaii_showing = true;
		kawaii_countdown = 5.0;
			
		next_wave_label->get<Position>()->x = 480/2;
		next_wave_label->get<Position>()->y = 320/2-20;
		
		Action *actn = flyin_and_shake_action();
		
		_entityManager->addComponent(kawaii_or_fail, actn);
		
		Entity *kawaii_sound = _entityManager->createNewEntity();
		SoundEffect *sfx = new SoundEffect();
		sfx->sfx_id = SFX_KAWAII;
		_entityManager->addComponent(kawaii_sound, sfx);
	}
	
	if (kawaii_countdown <= 0.0 && kawaii_showing)
	{
		
		kawaii_showing = false;
		Action *actn = flyout_and_reset_action();
		_entityManager->addComponent(kawaii_or_fail, actn);

		
		next_wave_label->get<Position>()->x = 600+480/2;
		next_wave_label->get<Position>()->y = 320/2-20;
		
		g_GameState.next_state = GAMESTATE_PLAYING_LEVEL;
		
		
		Entity *kawaii_sound = _entityManager->createNewEntity();
		SoundEffect *sfx = new SoundEffect();
		sfx->sfx_id = SFX_KAWAII2;
		_entityManager->addComponent(kawaii_sound, sfx);
		
		
//		spawnEnemies();
		kawaii_showing = false;
	}
	
}