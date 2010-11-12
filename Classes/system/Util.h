/*
 *  Util.h
 *  framework
 *
 *  Created by Jaroslaw Szpilewski on 22.06.08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */
#pragma once
#ifndef __UTIL_H__
#define __UTIL_H__ 44

#define DEG2RAD(x) (0.0174532925 * (x))
#define RAD2DEG(x) (57.295779578 * (x))

struct vector2D
{
	float x;
	float y;
};

struct rect
{
	float x;
	float y;
	float w;
	float h;
};

#endif