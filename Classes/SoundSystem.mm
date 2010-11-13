/*
 *  SoundSystem.cpp
 *  ComponentV3
 *
 *  Created by jrk on 12/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#include "SoundSystem.h"
#import "EntityManager.h"
#import "Component.h"
#import "Entity.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


SystemSoundID loadSound (const char *fn)
{
	NSString *filename = [NSString stringWithCString: fn];
	
	// Create the URL for the source audio file. The URLForResource:withExtension: method is
	//    new in iOS 4.0.
	NSURL *soundURL   = [[NSBundle mainBundle] URLForResource: filename
												withExtension: nil];
	
	// Store the URL as a CFURLRef instance
	CFURLRef soundFileURLRef = (CFURLRef) [soundURL retain];
	SystemSoundID sid;
	
	// Create a system sound object representing the sound file.
	AudioServicesCreateSystemSoundID (
									  soundFileURLRef,
									  &sid
									  );		
	
	
	//NSNumber *theID = [NSNumber numberWithInt: sid];
	
	//[soundRefs setObject: theID forKey: filename];
	
	return sid;
	
	//AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);		
	//AudioServicesPlaySystemSound (sid);		
	
}


SoundSystem::SoundSystem (MANAGERCLASS *entityManager)
{
	_entityManager = entityManager;
	memset(sounds,0x00,32*sizeof(SystemSoundID));
//	memset(sound_delays, 0x00, 32 * sizeof(float));
	
	for (int i = 0; i <32; i++)
		sound_delays[i] = 0.0;
	
	music_playing = 0;
	musicPlayer = nil;
	
	sounds[SFX_TICK] = loadSound("tick.wav");
	sounds[SFX_BLAM] = loadSound("bam1.wav");
	sounds[SFX_KAWAII] = loadSound("kawaii2.wav");
	sounds[SFX_KAWAII2] = loadSound("kawaii.wav");	
}

void SoundSystem::playMusic (int music_id)
{
	if (music_playing == music_id)
		return;

	[musicPlayer stop];
	[musicPlayer release];
	musicPlayer = nil;
	
	if (music_id == 0)
		return;
		
	NSString *filename = nil;
	
	
	if (music_id == MUSIC_GAME)
		filename = @"maulwurf.mp4";
	
	if (!filename)
		return;
	
	NSError *error;
	NSURL *soundURL   = [[NSBundle mainBundle] URLForResource: filename
												withExtension: nil];
		
	musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: soundURL error: &error];
	[musicPlayer setNumberOfLoops: -1];
	[musicPlayer play];

}

void SoundSystem::refreshCaches ()
{
	_entities.clear();
	_entityManager->getEntitiesPossessingComponent (_entities,SoundEffect::COMPONENT_ID);
	
}

void SoundSystem::update (float delta)
{

	
	std::vector<Entity*>::const_iterator it = _entities.begin();
	Entity *current_entity = NULL;

	for (int i = 0; i < 32; i++)
		sound_delays[i] -= delta;
	
	SoundEffect *current_sound = NULL;
	
	while (it != _entities.end())
	{
		current_entity = *it;
		++it;
		
		current_sound = _entityManager->getComponent <SoundEffect> (current_entity);
		
		if (current_sound)
		{
			if (current_sound->sfx_id == SFX_KAWAII)
			{
				printf("PENISSS \n");
			}
			
			int sid = current_sound->sfx_id;
			if (sid)
			{
				if (sound_delays[sid] <= 0.0)
				{	
					AudioServicesPlaySystemSound (sounds[sid]);
					sound_delays[sid] = 0.05;
				}
			}
		}
		
		
		//printf("playing audio effetc ...\n");
		_entityManager->addComponent<MarkOfDeath>(current_entity);
		
		//_entityManager->removeEntity(current_entity->_guid);
	}
}

