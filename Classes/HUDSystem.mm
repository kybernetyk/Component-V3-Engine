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
#include "Timer.h"
#include "globals.h"

HUDSystem::HUDSystem (EntityManager *entityManager)
{
	_entityManager = entityManager;

	kawaii_showing = false;
	kawaii_or_fail = NULL;

	hud_img = _entityManager->createNewEntity();
	_entityManager->addComponent<Position>(hud_img);
	Sprite *sprite = _entityManager->addComponent <Sprite> (hud_img);
	sprite->quad = g_RenderableManager.accquireTexturedQuad ("wolke2000.png");
	sprite->anchorPoint = vector2D_make(0.0, 0.0);
	sprite->z = 5.5;
	_entityManager->addComponent<Name>(hud_img)->name = "hud_img";


	
	xp_bar = _entityManager->createNewEntity();
	_entityManager->addComponent<Name>(xp_bar)->name = "xp_bar";

	Position *pos = _entityManager->addComponent <Position> (xp_bar);
	pos->y = -2.0;
	sprite = _entityManager->addComponent<Sprite>(xp_bar);
	sprite->quad = g_RenderableManager.accquireTexturedQuad ("xp_bar.png");
	sprite->anchorPoint = vector2D_make(0.0, 0.0);
	sprite->z = 5.6;
	
	score_ui = _entityManager->createNewEntity();
	_entityManager->addComponent<Name>(score_ui)->name = "score_ui";

	font = g_RenderableManager.accquireOGLFont("zomg.fnt");
	
	//score
	_entityManager->addComponent <Position> (score_ui);
	TextLabel *label = _entityManager->addComponent <TextLabel> (score_ui);
	label->ogl_font = font;
	label->anchorPoint = vector2D_make(0.0, 0.0);
	label->text = "0";
	score_ui->get<Position>()->x = 32.0;
	score_ui->get<Position>()->y = 10;
	label->z = 6.0;
	score_ui->get<Position>()->scale_x = 0.4;	
	score_ui->get<Position>()->scale_y = 0.4;

	//xp
	xp_ui = _entityManager->createNewEntity();
	_entityManager->addComponent<Name>(xp_ui)->name = "xp_ui";
	_entityManager->addComponent <Position> (xp_ui);
	label = _entityManager->addComponent<TextLabel> (xp_ui);
	label->ogl_font = font;
	label->anchorPoint = vector2D_make(1.0, 0.0);
	label->text = "Xp: 0/0";
	xp_ui->get<Position>()->x = 480-2;
	xp_ui->get<Position>()->y = 10;
	label->z = 6.0;
	xp_ui->get<Position>()->scale_x = 0.4;
	xp_ui->get<Position>()->scale_y = 0.4;
	
	
	//level
	level_ui = _entityManager->createNewEntity();
	_entityManager->addComponent<Name>(level_ui)->name = "level_ui";
	_entityManager->addComponent <Position> (level_ui);
	label = _entityManager->addComponent<TextLabel> (level_ui);
	label->ogl_font = font;
	label->anchorPoint = vector2D_make(0.5, 0.0);
	label->text = "Lvl. 0";
	level_ui->get<Position>()->x = 480/2-16;
	level_ui->get<Position>()->y = 10;
	label->z = 6.0;
	level_ui->get<Position>()->scale_x = 0.4;
	level_ui->get<Position>()->scale_y = 0.4;
	
	//fps label
	fps_label = _entityManager->createNewEntity();
	_entityManager->addComponent<Name>(fps_label)->name = "fps_label";
	_entityManager->addComponent<Position> (fps_label);
	fps_label->get<Position>()->x = 0.0;
	fps_label->get<Position>()->y = 320.0;
	label = _entityManager->addComponent<TextLabel> (fps_label);
	label->ogl_font = font;
	label->anchorPoint = vector2D_make(0.0, 1.0);
	label->text = "FPS: 0";
	label->z = 6.0;
	
	
	
	//LOLSHEET
	kawaii_or_fail = _entityManager->createNewEntity();
	_entityManager->addComponent<Name>(kawaii_or_fail)->name = "kawaii_or_fail";
	
	_entityManager->addComponent <Position> (kawaii_or_fail);
	kawaii_or_fail->get<Position>()->x = 480+200;
	kawaii_or_fail->get<Position>()->y = 320/2+20;
	
	_entityManager->addComponent <AtlasSprite> (kawaii_or_fail);
	kawaii_or_fail->get<AtlasSprite>()->atlas_quad = g_RenderableManager.accquireTexturedAtlasQuad ("lolsheet.png");
	kawaii_or_fail->get<AtlasSprite>()->src = rect_make(0.0, 0.0, 296.0, 64.0);
	kawaii_or_fail->get<AtlasSprite>()->z = 9.0;
	
	
	//next wave
	next_wave_label = _entityManager->createNewEntity();
	_entityManager->addComponent<Name>(next_wave_label)->name = "next_wave_label";

	_entityManager->addComponent <Position> (next_wave_label);
	next_wave_label->get<Position>()->x = 400+480/2;
	next_wave_label->get<Position>()->y = 320/2-20;
	next_wave_label->get<Position>()->scale_x = 0.5;
	next_wave_label->get<Position>()->scale_y = 0.5;
	
	label = _entityManager->addComponent <TextLabel> (next_wave_label);
	label->ogl_font = font;
	label->z = 9.0;
	label->text = "Next wave in 5 ...";
	
	//lvlup
	lvlup_graphic = _entityManager->createNewEntity();
	_entityManager->addComponent<Name>(lvlup_graphic)->name = "lvlup_graphic";

	_entityManager->addComponent <AtlasSprite> (lvlup_graphic);
	lvlup_graphic->get<AtlasSprite>()->atlas_quad = g_RenderableManager.accquireTexturedAtlasQuad ("lolsheet.png");
	lvlup_graphic->get<AtlasSprite>()->src = rect_make(0.0, 140.0, 320.0, 70.0);
	lvlup_graphic->get<AtlasSprite>()->z = 9.0;
	
	_entityManager->addComponent <Position> (lvlup_graphic);
	lvlup_graphic->get<Position>()->x = 400+480/2;
	lvlup_graphic->get<Position>()->y = 320/2+20;
	
	
	cached_level = g_GameState.level;
	lvlup_showing = false;
	lvlup_countdown = 0.0;
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
	/*
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
	*/
	
	MoveToAction *mb3 = new MoveToAction;
	mb3->x = 480+200;
	mb3->y = 320/2+20;
	mb3->duration = 0.0;
	//mb2->next_action = mb3;
	actn->next_action = mb3;

	return actn;
}


void HUDSystem::update (float delta)
{
	char s[255];
	sprintf(s,"%i", g_GameState.score);
	score_ui->get<TextLabel>()->text = s;
	
	sprintf(s, "XP: %i/%i", g_GameState.experience, g_GameState.experience_needed_to_levelup);
	xp_ui->get<TextLabel>()->text = s;
	
	sprintf(s, "Lvl. %i", g_GameState.level);
	level_ui->get<TextLabel>()->text = s;
	
	if (delta > 0.0)
	{
		sprintf(s, "Fps: %.2f", g_FPS);
		fps_label->get<TextLabel>()->text = s;
	}
	
	float sx = (1.0/g_GameState.experience_needed_to_levelup) * g_GameState.experience;
	
	xp_bar->get<Position>()->scale_x = sx;
	
	
	if (g_GameState.game_state == GAMESTATE_PLAYING_LEVEL)
	{
		lvlup_countdown -= delta;
		
		//lvlup sound + gfx
		if (cached_level != g_GameState.level)
		{
			cached_level = g_GameState.level;
			
			Entity *lvlup_sound = _entityManager->createNewEntity();
			_entityManager->addComponent<SoundEffect>(lvlup_sound)->sfx_id = SFX_LEVELUP;
			
			if (!lvlup_showing)
			{
				lvlup_countdown = 2.5;
				lvlup_showing = true;
				Action *actn = flyin_and_shake_action();
				_entityManager->addComponent(lvlup_graphic, actn);
			}
			
		}
		
		if (lvlup_countdown <= 0.0 && lvlup_showing)
		{
			lvlup_showing = false;
			Action *actn = flyout_and_reset_action();
			_entityManager->addComponent(lvlup_graphic, actn);
			
		}
	}
	
	if (g_GameState.game_state == GAMESTATE_WAITING_FOR_WAVE)
	{
		kawaii_countdown -= delta;
		lvlup_countdown = 0.0; //hide the lvlup info
		
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
	
}