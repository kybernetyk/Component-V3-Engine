/*
 *  Component.h
 *  components
 *
 *  Created by jrk on 3/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */
#pragma once
#ifndef __COMPONENT_H__
#define __COMPONENT_H__
#include <math.h>
#import "types.h"
#include <string>
#include "TexturedQuad.h"


#ifdef __RUNTIME_INFORMATION__
	#define DEBUGINFO(format,...) virtual std::string toString () \
	{\
		char s[512]; \
		sprintf(s, format, ##__VA_ARGS__); \
		return std::string (s);	\
	}
#else
	#define DEBUGINFO(format,...)
#endif


struct Component
{
	ComponentID _id;
	Component ()
	{
		_id = 0;
	}
	
	/*~Component ()
	{
		printf("PENIS LOL PENIS\n");
	}*/
	DEBUGINFO("Component")
	
};

struct MarkOfDeath : public Component 
{
	static ComponentID COMPONENT_ID;
	
	MarkOfDeath()
	{
		_id = COMPONENT_ID;
	}

	DEBUGINFO("Mark Of Death")
};

struct Position : public Component 
{
	static ComponentID COMPONENT_ID;
	float x,y;
	float rot;
	float scale;
	Position()
	{
		x = y = 0.0;
		rot = 0.0;
		scale = 1.0;
		_id = COMPONENT_ID;
	}
	
	DEBUGINFO ("Position: x=%f, y=%f, rot=%f, scale=%f",x,y,rot,scale)
};


struct Name : public Component 
{
	static ComponentID COMPONENT_ID;
	std::string name;

	Name()
	{
		name = "no name given";
		_id = COMPONENT_ID;
	}
	
	DEBUGINFO ("Name: %s",name.c_str())
};


struct Movement : public Component
{
	static ComponentID COMPONENT_ID;
	
	float vx;
	float vy;

	Movement()
	{
		_id = COMPONENT_ID;

		vx = 0.0;
		vy = 0.0;
	}
	
	DEBUGINFO ("Movement: vx=%f, vy=%f",vx,vy)
};

#define RENDERABLETYPE_BASE 0
#define RENDERABLETYPE_SPRITE 1
#define RENDERABLETYPE_TEXT 2
struct Renderable : public Component
{
	static ComponentID COMPONENT_ID;
	unsigned int _renderable_type;
	
	float z;
	Renderable()
	{
		_id = COMPONENT_ID;
		_renderable_type = RENDERABLETYPE_BASE;
		
		z = 0.0;
	}
	//WARNING: Don't forget to set the entity manager to dirty when you change the z value of an existing component! (Which shouldn't happen too often anyways)

	DEBUGINFO ("Renderable Base: z=%f", z)
};

struct Sprite : public Renderable
{
	static ComponentID COMPONENT_ID;
	
	TexturedQuad *sprite;

	Sprite()
	{
		Renderable::Renderable();
		
		_id = COMPONENT_ID;
		_renderable_type = RENDERABLETYPE_SPRITE;
		
		sprite = NULL;
	}
	//WARNING: Don't forget to set the entity manager to dirty when you change the z value of an existing component! (Which shouldn't happen too often anyways)
	
	DEBUGINFO ("Renderable: sprite=%p, z=%f", sprite,z)
};



struct TextLabel : public Renderable
{
	static ComponentID COMPONENT_ID;
	
	std::string text;
	
	OGLFont *ogl_font;
	
	TextLabel()
	{
		Renderable::Renderable();
		
		_id = COMPONENT_ID;
		_renderable_type = RENDERABLETYPE_TEXT;
		
		text = "fill me!";
		
		ogl_font = NULL;
	}
	//WARNING: Don't forget to set the entity manager to dirty when you change the z value of an existing component! (Which shouldn't happen too often anyways)
	
	DEBUGINFO ("Renderable: %s, z=%f", text.c_str(),z)
};


struct PlayerController : public Component
{
	static ComponentID COMPONENT_ID;
	
	PlayerController ()
	{
		_id = COMPONENT_ID;
	}
	
	DEBUGINFO ("Player Controller")
};

struct Enemy : public Component
{
	static ComponentID COMPONENT_ID;
	
	bool has_been_handled;
	float origin_x;
	float origin_y;
	
	Enemy ()
	{
		_id = COMPONENT_ID;
		has_been_handled = false;
		origin_x = origin_y = 0.0;
	}
	
	DEBUGINFO ("Enemy. has_been_handled: %i origin_x: %f origin_y: %f", has_been_handled, origin_x, origin_y)
};


struct Attachment : public Component
{
	static ComponentID COMPONENT_ID;
	EntityGUID targetEntityID;
	unsigned int entityChecksum;
	
	float offset_x;
	float offset_y;
	
	Attachment ()
	{
		_id = COMPONENT_ID;

		offset_x = offset_y = 0.0;
		entityChecksum = 0;
		targetEntityID = 0;
	}
	
	DEBUGINFO ("Attachment attached to: %i, attached entity checksum: %i",targetEntityID, entityChecksum)
};

#define ACTIONTYPE_NONE 0
#define ACTIONTYPE_MOVE_TO 1
#define ACTIONTYPE_MOVE_BY 2
#define ACTIONTYPE_ADD_COMPONENT 3

struct Action : public Component
{
	static ComponentID COMPONENT_ID;	//component id for the component's manager internal use
	unsigned int action_type;			//action type for the action system's internal use

	float duration;						//the action's duration
	float _timestamp;					//internal framecounter				
	
	Action *next_action;				//the action that should be ran after this one. NULL indicates no action
	
	bool may_be_aborted;				//may this action be aborted/replaced by another one?
	
	Action()
	{
		_id = COMPONENT_ID;
		action_type = ACTIONTYPE_NONE;
		next_action = NULL;
		_timestamp = duration = 0.0;
		may_be_aborted = true;
	}
	
	DEBUGINFO ("Empty Action with duration: %f and timestamp: %f", duration, _timestamp)
};
struct MoveToAction : public Action
{
	static ComponentID COMPONENT_ID;
	float x,y;			//absolute position to reach after duration
	
	float _ups_x;		//units per second - internal speed value
	float _ups_y;		//units per second - internal speed value
	
	MoveToAction()
	{
		Action::Action();

		_id = COMPONENT_ID;
		_ups_x = INFINITY;
		_ups_y = INFINITY;
		
		x = y = 0.0;
		action_type = ACTIONTYPE_MOVE_TO;
	}
	
	DEBUGINFO ("Move To: x=%f, y=%f duration: %f timestamp: %f",x,y,duration, _timestamp)
};
struct MoveByAction : public Action
{
	static ComponentID COMPONENT_ID;

	float x,y;	//relative distance to go during duration
	
	float _dx;	//cached destination x - internal use for action system
	float _dy;	//cached destination y - internal use for action system
	
	MoveByAction()
	{
		Action::Action();
		
		_id = COMPONENT_ID;
		_dx = _dy = INFINITY;			//mark with INFINITY to dirty so the action system can see that this value needs an init
		x = y = 0.0;
		action_type = ACTIONTYPE_MOVE_BY;
	}
	
	DEBUGINFO ("Move By: x=%f, y=%f duration: %f timestamp: %f",x,y,duration, _timestamp)
};
struct AddComponentAction : public Action
{
	static ComponentID COMPONENT_ID;

	Component *component_to_add;		//this will add the existing component pointed to
	
	
	AddComponentAction()
	{
		Action::Action();
		_id = COMPONENT_ID;

		component_to_add = NULL;
		
		action_type = ACTIONTYPE_ADD_COMPONENT;
	}
	
	DEBUGINFO ("AddComponentAction: %p duration: %f timestamp: %f",component_to_add,duration,_timestamp)
	
};

#endif