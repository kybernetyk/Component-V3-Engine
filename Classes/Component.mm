/*
 *  Component.cpp
 *  components
 *
 *  Created by jrk on 3/11/10.
 *  Copyright 2010 flux forge. All rights reserved.
 *
 */

#import "Component.h"

//0 is reserved!!!!!
ComponentID MarkOfDeath::COMPONENT_ID = 1;

ComponentID Position::COMPONENT_ID = 2;

ComponentID Movement::COMPONENT_ID = 3;

ComponentID Renderable::COMPONENT_ID = 4;
ComponentID Sprite::COMPONENT_ID = 4;
ComponentID TextLabel::COMPONENT_ID = 4;

ComponentID Name::COMPONENT_ID = 5;

ComponentID Attachment::COMPONENT_ID = 6;

ComponentID Action::COMPONENT_ID = 7;
ComponentID MoveToAction::COMPONENT_ID = 7;
ComponentID MoveByAction::COMPONENT_ID = 7;
ComponentID AddComponentAction::COMPONENT_ID = 7;


//user
ComponentID PlayerController::COMPONENT_ID = 16;

ComponentID Enemy::COMPONENT_ID = 17;